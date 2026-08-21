-- =============================================================================
-- Joyo — Impostore: informazioni segrete per giocatore.
--
-- Negli altri giochi il contenuto del round è uguale per tutti e sta in
-- rounds.content, che chiunque nella stanza può leggere. Qui no: la parola
-- segreta non deve arrivare all'impostore, quindi ogni giocatore ha una riga
-- separata che solo lui può leggere.
--
-- Anche il calcolo dei punti sta sul server: l'host è un giocatore come gli
-- altri e potrebbe essere lui l'impostore, quindi il suo telefono non deve mai
-- vedere la parola.
-- =============================================================================

create table if not exists public.round_secrets (
  round_id  uuid not null references public.rounds(id) on delete cascade,
  player_id uuid not null references public.players(id) on delete cascade,
  payload   jsonb not null,
  primary key (round_id, player_id)
);

alter table public.round_secrets enable row level security;

-- si vede solo la propria riga: è tutto il senso della tabella
drop policy if exists round_secrets_select_own on public.round_secrets;
create policy round_secrets_select_own on public.round_secrets
  for select to authenticated
  using (
    exists (
      select 1 from public.players p
      where p.id = round_secrets.player_id and p.user_id = auth.uid()
    )
  );

-- nessuna policy di insert/update/delete: le righe le scrive solo il server
revoke insert, update, delete on public.round_secrets from anon, authenticated;

-- -----------------------------------------------------------------------------
-- Avvio round: sceglie l'impostore e distribuisce la parola.
-- -----------------------------------------------------------------------------
create or replace function public.start_impostore_round(
  p_room         uuid,
  p_round_number int,
  p_word         text,
  p_word_index   int,
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
-- Chiusura round: conta i voti, assegna i punti, svela la parola.
-- Idempotente: sul round già svelato non fa nulla.
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

  -- voti ricevuti dall'impostore e massimo assoluto
  select count(*) into v_impvotes
  from public.votes v
  where v.round_id = p_round and v.value->>'suspect' = v_impostor::text;

  select coalesce(max(c), 0) into v_max from (
    select count(*) as c
    from public.votes v
    where v.round_id = p_round and v.value->>'suspect' is not null
    group by v.value->>'suspect'
  ) t;

  v_caught := v_impvotes > 0 and v_impvotes = v_max;

  select v.value->>'guess' into v_guess
  from public.votes v
  where v.round_id = p_round and v.player_id = v_impostor;

  if v_word is not null and v_guess is not null then
    v_guess_ok := lower(btrim(v_guess)) = lower(btrim(v_word));
  end if;

  if v_caught then
    -- punti a chi ha smascherato
    for v_voter in
      select v.player_id
      from public.votes v
      where v.round_id = p_round and v.value->>'suspect' = v_impostor::text
    loop
      update public.players p set score = p.score + 2 where p.id = v_voter.player_id;
    end loop;
    -- l'impostore scoperto si riscatta se indovina la parola
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

revoke all on function public.start_impostore_round(uuid, int, text, int, int) from public, anon;
revoke all on function public.resolve_impostore(uuid) from public, anon;
grant execute on function public.start_impostore_round(uuid, int, text, int, int) to authenticated;
grant execute on function public.resolve_impostore(uuid) to authenticated;

-- realtime anche sui segreti: ogni client riceve la propria riga appena creata
alter table public.round_secrets replica identity full;
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public'
      and tablename = 'round_secrets'
  ) then
    alter publication supabase_realtime add table public.round_secrets;
  end if;
end $$;
