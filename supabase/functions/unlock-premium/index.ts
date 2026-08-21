// Joyo — sblocco del premium AI per una stanza.
//
// Due usi:
//   * acquisto in-app completato  -> is_premium_ai = true per quella stanza;
//   * annuncio con premio visto   -> +1 credito AI.
//
// Il client non può scrivere né is_premium_ai né ai_credits (i permessi sono
// revocati a livello di colonna), quindi passare da qui è l'unica strada.
//
// ATTENZIONE prima del rilascio: la verifica della ricevuta Google Play è
// ancora da fare. Finché manca, un client modificato potrebbe chiamare questa
// funzione con un token inventato e sbloccare il premium senza pagare.
// Serve un service account Google e una chiamata a
// androidpublisher.purchases.products.get: vedi VERIFICA_ACQUISTO più sotto.
//
// Deploy: supabase functions deploy unlock-premium

import { createClient } from 'jsr:@supabase/supabase-js@2';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
};

type Body = {
  room_id: string;
  kind: 'purchase' | 'reward';
  /** Solo per kind = purchase. */
  purchase_token?: string;
  product_id?: string;
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
  if (!body.room_id || !body.kind) return json({ error: 'BAD_REQUEST' }, 400);

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

  // solo l'host della stanza
  const { data: host } = await admin
    .from('players')
    .select('id')
    .eq('room_id', body.room_id)
    .eq('user_id', user.id)
    .eq('is_host', true)
    .maybeSingle();
  if (!host) return json({ error: 'NOT_HOST' }, 403);

  if (body.kind === 'purchase') {
    if (!body.purchase_token) return json({ error: 'BAD_REQUEST' }, 400);

    // VERIFICA_ACQUISTO: qui va la chiamata a Google Play Developer API con un
    // service account, per confermare che purchase_token sia reale, riferito a
    // product_id e non ancora consumato. Senza, il flag è sbloccabile a mano.
    const verified = true;
    if (!verified) return json({ error: 'INVALID_PURCHASE' }, 402);

    await admin
      .from('rooms')
      .update({ is_premium_ai: true })
      .eq('id', body.room_id);
    return json({ ok: true, premium: true });
  }

  // annuncio con premio: un singolo contenuto AI
  const { data: room } = await admin
    .from('rooms')
    .select('ai_credits')
    .eq('id', body.room_id)
    .maybeSingle();
  if (!room) return json({ error: 'ROOM_NOT_FOUND' }, 404);

  await admin
    .from('rooms')
    .update({ ai_credits: (room.ai_credits ?? 0) + 1 })
    .eq('id', body.room_id);

  return json({ ok: true, credits: (room.ai_credits ?? 0) + 1 });
});
