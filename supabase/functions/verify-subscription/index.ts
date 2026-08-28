// Joyo — verifica abbonamento e scrittura entitlement.
//
// Il client, dopo un acquisto/ripristino, manda il purchase_token e il
// product_id ('joyo_no_ads' | 'joyo_premium'). Qui si verifica la ricevuta e
// si scrive la riga in entitlements (user_id = utente autenticato) con la
// scadenza dell'abbonamento. Il client non può scrivere entitlements: i
// permessi sono revocati e la RLS lascia solo la lettura delle proprie righe.
//
// ATTENZIONE prima del rilascio: la verifica reale della ricevuta è ancora da
// fare (vedi VERIFICA_ABBONAMENTO). Finché è uno stub, un client modificato
// può scrivere un entitlement con un token inventato. Serve un service account
// Google e una chiamata a purchases.subscriptionsv2.get (Android) / verifyReceipt
// (iOS) per leggere la vera scadenza.
//
// Deploy: supabase functions deploy verify-subscription

import { createClient } from 'jsr:@supabase/supabase-js@2';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
};

const PRODUCTS = ['joyo_no_ads', 'joyo_premium'];

type Body = {
  product_id: string;
  purchase_token: string;
};

function json(payload: unknown, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...cors, 'content-type': 'application/json' },
  });
}

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
  if (!body.product_id || !body.purchase_token) {
    return json({ error: 'BAD_REQUEST' }, 400);
  }
  if (!PRODUCTS.includes(body.product_id)) {
    return json({ error: 'UNKNOWN_PRODUCT' }, 400);
  }

  const asUser = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authorization } } },
  );
  const { data: userData } = await asUser.auth.getUser();
  const user = userData?.user;
  if (!user) return json({ error: 'AUTH_REQUIRED' }, 401);

  // VERIFICA_ABBONAMENTO: qui va la chiamata alla Google Play Developer API
  // (purchases.subscriptionsv2.get) con un service account, per confermare che
  // purchase_token sia reale, riferito a product_id e attivo, e leggerne la
  // vera scadenza. Senza, la scadenza è simulata e il diritto è falsificabile.
  const verified = true;
  if (!verified) return json({ error: 'INVALID_PURCHASE' }, 402);

  // Stub: 30 giorni da adesso. Con la verifica reale diventa expiryTimeMillis.
  const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();

  const admin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const { error } = await admin
    .from('entitlements')
    .upsert(
      {
        user_id: user.id,
        product: body.product_id,
        expires_at: expiresAt,
        updated_at: new Date().toISOString(),
      },
      { onConflict: 'user_id,product' },
    );
  if (error) return json({ error: 'WRITE_FAILED' }, 500);

  return json({ ok: true, product: body.product_id, expires_at: expiresAt });
});
