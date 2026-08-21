// Joyo — generazione contenuti con GPT-4o-mini.
//
// Gira solo qui: la chiave OpenAI non deve mai stare nell'app, perché
// chiunque potrebbe estrarla dall'APK e usarla a spese nostre.
//
// Prima di generare qualsiasi cosa la funzione verifica che:
//   1. chi chiama sia autenticato (anche anonimo va bene);
//   2. sia l'host della stanza;
//   3. la stanza abbia il premium attivo oppure almeno un credito AI.
// Il credito viene consumato solo se la generazione è andata a buon fine.
//
// Deploy:  supabase functions deploy generate-content
// Segreti: supabase secrets set OPENAI_API_KEY=sk-...

import { createClient } from 'jsr:@supabase/supabase-js@2';

const OPENAI_URL = 'https://api.openai.com/v1/chat/completions';
const MODEL = 'gpt-4o-mini';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
};

type Body = {
  room_id: string;
  game: 'chi_lo_potrebbe_fare' | 'bluff_story';
  /** Nomi dei giocatori presenti, per contenuti su misura. */
  players?: string[];
  /** Bluff Story: il fatto vero scritto dal giocatore. */
  truth?: string;
  tone?: 'soft' | 'piccante' | 'cattivo';
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

  const openaiKey = Deno.env.get('OPENAI_API_KEY');
  if (!openaiKey) return json({ error: 'MISSING_OPENAI_KEY' }, 500);

  let body: Body;
  try {
    body = await req.json();
  } catch {
    return json({ error: 'BAD_REQUEST' }, 400);
  }
  if (!body.room_id || !body.game) return json({ error: 'BAD_REQUEST' }, 400);

  // client "come utente": serve solo a sapere chi sta chiamando
  const asUser = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authorization } } },
  );
  const { data: userData } = await asUser.auth.getUser();
  const user = userData?.user;
  if (!user) return json({ error: 'AUTH_REQUIRED' }, 401);

  // client di servizio: legge e scrive ignorando la RLS
  const admin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const { data: room } = await admin
    .from('rooms')
    .select('id, tone, is_premium_ai, ai_credits')
    .eq('id', body.room_id)
    .maybeSingle();
  if (!room) return json({ error: 'ROOM_NOT_FOUND' }, 404);

  const { data: host } = await admin
    .from('players')
    .select('id')
    .eq('room_id', body.room_id)
    .eq('user_id', user.id)
    .eq('is_host', true)
    .maybeSingle();
  if (!host) return json({ error: 'NOT_HOST' }, 403);

  const usingCredit = !room.is_premium_ai;
  if (usingCredit && (room.ai_credits ?? 0) <= 0) {
    return json({ error: 'NO_AI_ACCESS' }, 402);
  }

  const tone = body.tone ?? room.tone ?? 'soft';
  const names = (body.players ?? []).slice(0, 10).join(', ');

  const prompt =
    body.game === 'bluff_story'
      ? [
          'Sei l\'autore di un party game italiano.',
          `Un giocatore ha scritto questo fatto VERO su di sé: "${body.truth ?? ''}".`,
          'Scrivi DUE affermazioni FALSE ma credibili, nello stesso stile,',
          'stessa lunghezza e stesso registro, in prima persona.',
          'Devono essere plausibili per la stessa persona, senza esagerazioni.',
          'Rispondi solo con un array JSON di due stringhe.',
        ].join(' ')
      : [
          'Sei l\'autore di un party game italiano.',
          `Scrivi UNA domanda del tipo "Chi del gruppo...?" con tono ${tone}.`,
          names ? `I giocatori presenti sono: ${names}.` : '',
          'La domanda deve funzionare per qualsiasi gruppo di amici, essere',
          'divertente, breve (massimo 90 caratteri) e non offensiva.',
          'Rispondi solo con un array JSON contenente una sola stringa.',
        ].join(' ');

  const completion = await fetch(OPENAI_URL, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${openaiKey}`,
      'content-type': 'application/json',
    },
    body: JSON.stringify({
      model: MODEL,
      temperature: 1,
      max_tokens: 300,
      messages: [
        {
          role: 'system',
          content:
            'Rispondi sempre e solo con JSON valido, senza spiegazioni e ' +
            'senza blocchi di codice. Scrivi in italiano.',
        },
        { role: 'user', content: prompt },
      ],
    }),
  });

  if (!completion.ok) {
    const detail = await completion.text();
    console.error('openai error', completion.status, detail);
    return json({ error: 'AI_FAILED' }, 502);
  }

  const payload = await completion.json();
  const raw = payload?.choices?.[0]?.message?.content ?? '';

  let items: string[];
  try {
    const parsed = JSON.parse(raw.replace(/```json|```/g, '').trim());
    items = Array.isArray(parsed) ? parsed.map(String) : [String(parsed)];
  } catch {
    console.error('parse error', raw);
    return json({ error: 'AI_FAILED' }, 502);
  }
  if (items.length === 0) return json({ error: 'AI_FAILED' }, 502);

  // il credito si scala solo adesso, a generazione riuscita
  if (usingCredit) {
    await admin
      .from('rooms')
      .update({ ai_credits: Math.max(0, (room.ai_credits ?? 1) - 1) })
      .eq('id', room.id);
  }

  return json({ items, source: room.is_premium_ai ? 'premium' : 'credit' });
});
