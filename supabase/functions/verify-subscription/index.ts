// Joyo — verifica abbonamento e scrittura entitlement.
//
// Il client, dopo un acquisto/ripristino, manda platform ('android' | 'ios'),
// product_id ('joyo_no_ads' | 'joyo_premium') e purchase_token (il token Play
// su Android, la ricevuta base64 su iOS). Qui la ricevuta viene verificata
// PRESSO lo store e si scrive la riga in entitlements (user_id = utente
// autenticato) con la scadenza reale dell'abbonamento. Il client non può
// scrivere entitlements: i permessi sono revocati e la RLS lascia solo la
// lettura delle proprie righe.
//
// Secrets richiesti (supabase secrets set ...):
//  - GOOGLE_SERVICE_ACCOUNT: JSON completo della chiave del service account
//    (Play Console → API access) con permesso su Android Publisher.
//  - APPLE_SHARED_SECRET: shared secret dell'app (App Store Connect → App →
//    Informazioni app → Shared secret specifico per l'app).
// Senza il secret della piattaforma richiesta la verifica FALLISCE (fail
// closed): meglio un acquisto da riprovare che un diritto falsificabile.
//
// Modalità refresh ({ refresh: true }): riverifica presso lo store tutti gli
// abbonamenti già registrati dell'utente usando il token conservato in
// entitlements, e riallinea expires_at (rinnovi, disdette). Il client la
// chiama a ogni avvio; non serve alcun prompt dello store sul dispositivo.
//
// Deploy: supabase functions deploy verify-subscription

import { createClient } from 'jsr:@supabase/supabase-js@2';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
};

const PRODUCTS = ['joyo_no_ads', 'joyo_premium'];
const ANDROID_PACKAGE = 'com.blueinhope.joyo';
const IOS_BUNDLE_ID = 'com.blueinhope.joyo';

type Body = {
  platform?: string;
  product_id?: string;
  purchase_token?: string;
  refresh?: boolean;
};

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...cors, 'content-type': 'application/json' },
  });
}

// ---------------------------------------------------------------------------
// Google: service account JWT → access token → purchases.subscriptionsv2.get
// ---------------------------------------------------------------------------

function base64UrlEncode(bytes: Uint8Array): string {
  let ascii = '';
  for (const b of bytes) ascii += String.fromCharCode(b);
  return btoa(ascii).replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
}

/// Firma un JWT RS256 con la chiave privata PEM del service account.
async function signGoogleJwt(email: string, privateKeyPem: string): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const claims = {
    iss: email,
    scope: 'https://www.googleapis.com/auth/androidpublisher',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  };
  const encoder = new TextEncoder();
  const unsigned =
    base64UrlEncode(encoder.encode(JSON.stringify(header))) +
    '.' +
    base64UrlEncode(encoder.encode(JSON.stringify(claims)));

  const pem = privateKeyPem
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replaceAll('\\n', '')
    .replaceAll('\n', '')
    .trim();
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    'pkcs8',
    der,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = new Uint8Array(
    await crypto.subtle.sign('RSASSA-PKCS1-v1_5', key, encoder.encode(unsigned)),
  );
  return unsigned + '.' + base64UrlEncode(signature);
}

async function googleAccessToken(): Promise<string | null> {
  const raw = Deno.env.get('GOOGLE_SERVICE_ACCOUNT');
  if (!raw) return null;
  let account: { client_email: string; private_key: string };
  try {
    account = JSON.parse(raw);
  } catch {
    console.error('GOOGLE_SERVICE_ACCOUNT non è JSON valido');
    return null;
  }
  const jwt = await signGoogleJwt(account.client_email, account.private_key);
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });
  if (!response.ok) {
    console.error('Token Google rifiutato:', response.status, await response.text());
    return null;
  }
  const data = await response.json();
  return typeof data.access_token === 'string' ? data.access_token : null;
}

type VerifyResult =
  | { ok: true; expiresAt: string; token?: string }
  | { ok: false; error: 'VERIFY_UNAVAILABLE' | 'INVALID_PURCHASE' };

/// Verifica un token di abbonamento Play: il token deve esistere, riferirsi al
/// prodotto richiesto ed essere attivo (o in grace period). Torna la scadenza
/// vera (expiryTime dell'ultima line item del prodotto).
async function verifyAndroid(productId: string, token: string): Promise<VerifyResult> {
  const accessToken = await googleAccessToken();
  if (!accessToken) return { ok: false, error: 'VERIFY_UNAVAILABLE' };

  const url =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/` +
    `${ANDROID_PACKAGE}/purchases/subscriptionsv2/tokens/${encodeURIComponent(token)}`;
  const response = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (!response.ok) {
    // 404/400: token inesistente o malformato → acquisto non valido.
    console.error('subscriptionsv2.get:', response.status, await response.text());
    return { ok: false, error: 'INVALID_PURCHASE' };
  }
  const sub = await response.json();

  const state = sub.subscriptionState as string | undefined;
  const active =
    state === 'SUBSCRIPTION_STATE_ACTIVE' || state === 'SUBSCRIPTION_STATE_IN_GRACE_PERIOD';
  if (!active) return { ok: false, error: 'INVALID_PURCHASE' };

  const items: Array<{ productId?: string; expiryTime?: string }> = sub.lineItems ?? [];
  const item = items.find((i) => i.productId === productId);
  if (!item?.expiryTime) return { ok: false, error: 'INVALID_PURCHASE' };

  const expiry = new Date(item.expiryTime);
  if (!(expiry.getTime() > Date.now())) return { ok: false, error: 'INVALID_PURCHASE' };
  return { ok: true, expiresAt: expiry.toISOString() };
}

// ---------------------------------------------------------------------------
// Apple: verifyReceipt (prod, con fallback sandbox per le build TestFlight)
// ---------------------------------------------------------------------------

async function appleVerifyReceipt(
  endpoint: string,
  receipt: string,
  sharedSecret: string,
): Promise<Record<string, unknown> | null> {
  const response = await fetch(endpoint, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      'receipt-data': receipt,
      password: sharedSecret,
      'exclude-old-transactions': true,
    }),
  });
  if (!response.ok) {
    console.error('verifyReceipt:', response.status, await response.text());
    return null;
  }
  return await response.json();
}

/// Verifica una ricevuta iOS: bundle id giusto e abbonamento del prodotto
/// richiesto non scaduto. Torna la scadenza più recente per quel prodotto.
async function verifyIos(productId: string, receipt: string): Promise<VerifyResult> {
  const sharedSecret = Deno.env.get('APPLE_SHARED_SECRET');
  if (!sharedSecret) return { ok: false, error: 'VERIFY_UNAVAILABLE' };

  let data = await appleVerifyReceipt(
    'https://buy.itunes.apple.com/verifyReceipt',
    receipt,
    sharedSecret,
  );
  // 21007: ricevuta sandbox mandata all'endpoint di produzione (TestFlight e
  // review Apple usano sandbox) → si riprova sull'endpoint sandbox.
  if (data && data.status === 21007) {
    data = await appleVerifyReceipt(
      'https://sandbox.itunes.apple.com/verifyReceipt',
      receipt,
      sharedSecret,
    );
  }
  if (!data) return { ok: false, error: 'VERIFY_UNAVAILABLE' };
  if (data.status !== 0) {
    console.error('verifyReceipt status:', data.status);
    return { ok: false, error: 'INVALID_PURCHASE' };
  }

  const receiptInfo = data.receipt as { bundle_id?: string } | undefined;
  if (receiptInfo?.bundle_id !== IOS_BUNDLE_ID) {
    return { ok: false, error: 'INVALID_PURCHASE' };
  }

  const latest = (data.latest_receipt_info ?? []) as Array<{
    product_id?: string;
    expires_date_ms?: string;
  }>;
  let expiryMs = 0;
  for (const tx of latest) {
    if (tx.product_id !== productId) continue;
    const ms = Number(tx.expires_date_ms ?? 0);
    if (ms > expiryMs) expiryMs = ms;
  }
  if (!(expiryMs > Date.now())) return { ok: false, error: 'INVALID_PURCHASE' };
  // latest_receipt è la ricevuta aggiornata coi rinnovi: conservandola le
  // riverifiche successive partono dallo stato più recente.
  const latestReceipt = typeof data.latest_receipt === 'string' ? data.latest_receipt : undefined;
  return { ok: true, expiresAt: new Date(expiryMs).toISOString(), token: latestReceipt };
}

function verifyWithStore(platform: string, productId: string, token: string): Promise<VerifyResult> {
  return platform === 'android' ? verifyAndroid(productId, token) : verifyIos(productId, token);
}

// ---------------------------------------------------------------------------

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });

  const authorization = req.headers.get('Authorization');
  if (!authorization) return json({ error: 'AUTH_REQUIRED' }, 401);

  let body: Body;
  try {
    body = await req.json();
  } catch {
    return json({ error: 'BAD_REQUEST' }, 400);
  }
  const isRefresh = body.refresh === true;
  if (!isRefresh) {
    if (!body.product_id || !body.purchase_token || !body.platform) {
      return json({ error: 'BAD_REQUEST' }, 400);
    }
    if (!PRODUCTS.includes(body.product_id)) {
      return json({ error: 'UNKNOWN_PRODUCT' }, 400);
    }
    if (body.platform !== 'android' && body.platform !== 'ios') {
      return json({ error: 'UNKNOWN_PLATFORM' }, 400);
    }
  }

  const asUser = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authorization } } },
  );
  const { data: userData } = await asUser.auth.getUser();
  const user = userData?.user;
  if (!user) return json({ error: 'AUTH_REQUIRED' }, 401);

  const admin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  if (isRefresh) return await refreshEntitlements(admin, user.id);

  const result = await verifyWithStore(body.platform!, body.product_id!, body.purchase_token!);
  if (!result.ok) {
    // VERIFY_UNAVAILABLE = configurazione server mancante/errore store (503,
    // il client può riprovare); INVALID_PURCHASE = ricevuta non valida (402).
    return json({ error: result.error }, result.error === 'VERIFY_UNAVAILABLE' ? 503 : 402);
  }

  const now = new Date().toISOString();
  const { error } = await admin
    .from('entitlements')
    .upsert(
      {
        user_id: user.id,
        product: body.product_id,
        expires_at: result.expiresAt,
        platform: body.platform,
        purchase_token: result.token ?? body.purchase_token,
        last_checked_at: now,
        updated_at: now,
      },
      { onConflict: 'user_id,product' },
    );
  if (error) return json({ error: 'WRITE_FAILED' }, 500);

  return json({ ok: true, product: body.product_id, expires_at: result.expiresAt });
});

// ---------------------------------------------------------------------------
// Refresh: riverifica gli abbonamenti registrati con il token conservato.
//  - ok            → expires_at aggiornata (rinnovo avvenuto o scadenza uguale);
//  - INVALID       → lo store dice scaduto/disdetto: expires_at = adesso;
//  - UNAVAILABLE   → store/config non raggiungibile: riga lasciata com'è.
// Le righe senza token (registrate prima di 0024) restano come sono finché
// l'utente non rifà "Ripristina acquisti".
// ---------------------------------------------------------------------------

type EntitlementRow = {
  product: string;
  platform: string | null;
  purchase_token: string | null;
  expires_at: string;
};

async function refreshEntitlements(
  admin: ReturnType<typeof createClient>,
  userId: string,
): Promise<Response> {
  const { data, error } = await admin
    .from('entitlements')
    .select('product, platform, purchase_token, expires_at')
    .eq('user_id', userId);
  if (error) return json({ error: 'READ_FAILED' }, 500);

  const rows = (data ?? []) as EntitlementRow[];
  const active: string[] = [];
  const now = new Date();

  for (const row of rows) {
    if (!row.platform || !row.purchase_token) {
      if (new Date(row.expires_at) > now) active.push(row.product);
      continue;
    }
    const result = await verifyWithStore(row.platform, row.product, row.purchase_token);
    if (!result.ok && result.error === 'VERIFY_UNAVAILABLE') {
      if (new Date(row.expires_at) > now) active.push(row.product);
      continue;
    }
    const expiresAt = result.ok ? result.expiresAt : now.toISOString();
    const update: Record<string, unknown> = {
      expires_at: expiresAt,
      last_checked_at: now.toISOString(),
      updated_at: now.toISOString(),
    };
    if (result.ok && result.token) update.purchase_token = result.token;
    const { error: writeError } = await admin
      .from('entitlements')
      .update(update)
      .eq('user_id', userId)
      .eq('product', row.product);
    if (writeError) console.error('refresh write:', row.product, writeError.message);
    if (result.ok) active.push(row.product);
  }

  return json({ ok: true, products: active });
}
