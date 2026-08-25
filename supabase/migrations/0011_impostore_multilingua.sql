-- =============================================================================
-- Joyo — Impostore multilingua: indovinare la parola in una lingua qualsiasi.
--
-- La parola segreta esce a ogni giocatore nella lingua del suo telefono
-- (lato client, dall'indice del pool in rounds.content->>'i'). Ma l'impostore,
-- quando prova a indovinarla, la scrive nella SUA lingua: confrontarla solo
-- con la parola nella lingua dell'host la darebbe per sbagliata anche quando è
-- giusta. Qui salviamo la parola in tutte le lingue e accettiamo l'ipotesi se
-- combacia con una qualunque di esse.
--
-- Le traduzioni stanno in una tabella separata che nessun client può leggere:
-- darebbero all'impostore la parola. Le legge solo il server, a round chiuso.
-- =============================================================================

create table if not exists public.round_answers (
  round_id uuid not null references public.rounds(id) on delete cascade,
  answers  jsonb not null,
  primary key (round_id)
);

alter table public.round_answers enable row level security;

-- Nessuna policy di select: la tabella è off-limits per i client. La leggono
-- solo le funzioni security definer (che girano come proprietario e saltano la
-- RLS). Revoca esplicita per non lasciare permessi di default in giro.
revoke all on public.round_answers from anon, authenticated;

-- -----------------------------------------------------------------------------
-- Avvio round: come prima, ma riceve anche le traduzioni della parola e le
-- mette da parte nella tabella privata.
-- -----------------------------------------------------------------------------
drop function if exists public.start_impostore_round(uuid, int, text, int, int);

create or replace function public.start_impostore_round(
  p_room         uuid,
  p_round_number int,
  p_word         text,
  p_word_index   int,
  p_answers      jsonb default null,
  p_discussion   int default 90
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_round     uuid;
  v_impostor  uuid;
  v_player    record;
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  select p.id into v_impostor
  from public.players p
  where p.room_id = p_room
  order by random()
  limit 1;

  if v_impostor is null then
    raise exception 'NO_PLAYERS';
  end if;

  insert into public.rounds (room_id, game_type, round_number, content)
  values (
    p_room,
    'impostore',
    p_round_number,
    jsonb_build_object(
      'i', p_word_index,
      'discussion_seconds', p_discussion,
      'secret_seconds', 12
    )
  )
  returning id into v_round;

  if p_answers is not null then
    insert into public.round_answers (round_id, answers)
    values (v_round, p_answers);
  end if;

  for v_player in
    select p.id from public.players p where p.room_id = p_room
  loop
    insert into public.round_secrets (round_id, player_id, payload)
    values (
      v_round,
      v_player.id,
      case
        when v_player.id = v_impostor
          then jsonb_build_object('impostor', true)
        else jsonb_build_object('impostor', false, 'word', p_word)
      end
    );
  end loop;

  return v_round;
end;
$$;

-- -----------------------------------------------------------------------------
-- Chiusura round: uguale a prima, ma l'ipotesi dell'impostore è giusta se
-- combacia con la parola in una qualsiasi delle lingue (fallback: la parola
-- dell'host, per i round creati prima di questa migrazione).
-- -----------------------------------------------------------------------------
create or replace function public.resolve_impostore(p_round uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_round     public.rounds%rowtype;
  v_impostor  uuid;
  v_word      text;
  v_answers   jsonb;
  v_max       int;
  v_impvotes  int;
  v_caught    boolean;
  v_guess     text;
  v_guess_ok  boolean := false;
  v_voter     record;
begin
  select r.* into v_round from public.rounds r where r.id = p_round;
  if not found then
    raise exception 'ROUND_NOT_FOUND';
  end if;
  if not public.is_room_host(v_round.room_id) then
    raise exception 'NOT_HOST';
  end if;
  if v_round.status <> 'waiting_votes' then
    return;
  end if;

  select s.player_id into v_impostor
  from public.round_secrets s
  where s.round_id = p_round and (s.payload->>'impostor')::boolean
  limit 1;

  select s.payload->>'word' into v_word
  from public.round_secrets s
  where s.round_id = p_round and s.payload ? 'word'
  limit 1;

  select a.answers into v_answers
  from public.round_answers a
  where a.round_id = p_round;

  -- l'autovoto dell'impostore non conta né per smascherarlo né per i punti
  select count(*) into v_impvotes
  from public.votes v
  where v.round_id = p_round
    and v.value->>'suspect' = v_impostor::text
    and v.player_id <> v_impostor;

  select coalesce(max(c), 0) into v_max from (
    select count(*) as c
    from public.votes v
    where v.round_id = p_round
      and v.value->>'suspect' is not null
      and v.player_id <> v_impostor
    group by v.value->>'suspect'
  ) t;

  v_caught := v_impvotes > 0 and v_impvotes = v_max;

  select v.value->>'guess' into v_guess
  from public.votes v
  where v.round_id = p_round and v.player_id = v_impostor;

  if v_guess is not null then
    if v_answers is not null then
      -- giusta se combacia con la parola in una qualsiasi delle lingue
      v_guess_ok := exists (
        select 1
        from jsonb_array_elements_text(v_answers) w
        where lower(btrim(w)) = lower(btrim(v_guess))
      );
    elsif v_word is not null then
      v_guess_ok := lower(btrim(v_guess)) = lower(btrim(v_word));
    end if;
  end if;

  if v_caught then
    for v_voter in
      select v.player_id
      from public.votes v
      where v.round_id = p_round
        and v.value->>'suspect' = v_impostor::text
        and v.player_id <> v_impostor
    loop
      update public.players p set score = p.score + 2 where p.id = v_voter.player_id;
    end loop;
    if v_guess_ok then
      update public.players p set score = p.score + 3 where p.id = v_impostor;
    end if;
  else
    update public.players p set score = p.score + 5 where p.id = v_impostor;
  end if;

  update public.rounds r
     set content = r.content || jsonb_build_object(
           'word', v_word,
           'impostor', v_impostor,
           'caught', v_caught,
           'guess', v_guess,
           'guess_ok', v_guess_ok
         ),
         status = 'revealed'
   where r.id = p_round;
end;
$$;

revoke all on function public.start_impostore_round(uuid, int, text, int, jsonb, int) from public, anon;
grant execute on function public.start_impostore_round(uuid, int, text, int, jsonb, int) to authenticated;
