-- =============================================================================
-- Joyo — Fase 1: schema iniziale
-- Eseguire per intero nell'SQL Editor di Supabase (è idempotente: si può
-- rilanciare senza rompere nulla).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Tipi enum
-- -----------------------------------------------------------------------------
do $$ begin
  create type public.room_status as enum ('lobby', 'in_game', 'finished');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.round_status as enum ('waiting_votes', 'revealed');
exception when duplicate_object then null; end $$;

-- -----------------------------------------------------------------------------
-- 2. Tabelle
-- -----------------------------------------------------------------------------

-- rooms ------------------------------------------------------------------------
create table if not exists public.rooms (
  id            uuid primary key default gen_random_uuid(),
  code          text not null unique check (code ~ '^[A-Z0-9]{4}$'),
  host_id       uuid,                       -- FK a players, popolata dopo (vedi sotto)
  status        public.room_status not null default 'lobby',
  active_game   text,
  is_premium_ai boolean not null default false,
  -- impostazioni di partita (dal flusso applicativo: tono contenuti + n. round)
  tone          text not null default 'soft' check (tone in ('soft', 'piccante', 'cattivo')),
  rounds_total  int  not null default 10 check (rounds_total between 1 and 50),
  created_at    timestamptz not null default now()
);

-- players ----------------------------------------------------------------------
-- user_id non era nella specifica ma serve per legare la riga all'utente
-- anonimo di Supabase Auth: è la base di tutte le policy RLS.
create table if not exists public.players (
  id        uuid primary key default gen_random_uuid(),
  room_id   uuid not null references public.rooms(id) on delete cascade,
  user_id   uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name      text not null check (char_length(btrim(name)) between 1 and 20),
  color     text not null,
  is_host   boolean not null default false,
  score     int not null default 0,
  joined_at timestamptz not null default now(),
  unique (room_id, user_id)   -- un utente = un giocatore per stanza
);

create index if not exists players_room_id_idx on public.players (room_id);

-- FK circolare rooms.host_id -> players.id, aggiunta dopo la creazione di players
do $$ begin
  alter table public.rooms
    add constraint rooms_host_id_fkey
    foreign key (host_id) references public.players(id) on delete set null;
exception when duplicate_object then null; end $$;

-- rounds -----------------------------------------------------------------------
-- Niente unique su (room_id, round_number): rigiocando nella stessa stanza la
-- numerazione riparte da 1, e lo storico dei round precedenti resta consultabile.
-- Il round corrente è sempre quello con created_at più recente.
create table if not exists public.rounds (
  id           uuid primary key default gen_random_uuid(),
  room_id      uuid not null references public.rooms(id) on delete cascade,
  game_type    text not null,
  round_number int  not null,
  content      jsonb not null default '{}'::jsonb,
  status       public.round_status not null default 'waiting_votes',
  created_at   timestamptz not null default now()
);

create index if not exists rounds_room_created_idx
  on public.rounds (room_id, created_at desc);

-- votes ------------------------------------------------------------------------
create table if not exists public.votes (
  id         uuid primary key default gen_random_uuid(),
  round_id   uuid not null references public.rounds(id) on delete cascade,
  player_id  uuid not null references public.players(id) on delete cascade,
  value      jsonb not null,
  created_at timestamptz not null default now(),
  unique (round_id, player_id)   -- un voto solo per round
);

create index if not exists votes_round_id_idx on public.votes (round_id);

-- -----------------------------------------------------------------------------
-- 3. Funzioni helper (security definer: leggono players ignorando la RLS,
--    così le policy non entrano in ricorsione infinita)
-- -----------------------------------------------------------------------------
create or replace function public.is_room_member(p_room uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.players
    where room_id = p_room and user_id = auth.uid()
  );
$$;

create or replace function public.is_room_host(p_room uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.players
    where room_id = p_room and user_id = auth.uid() and is_host
  );
$$;

-- -----------------------------------------------------------------------------
-- 4. Row Level Security
--    Modello: solo chi è dentro una stanza vede/scrive i dati di quella stanza.
--    L'ingresso avviene esclusivamente via RPC create_room/join_room, quindi
--    nessuna policy di SELECT pubblica su rooms (il codice stanza non è
--    enumerabile dall'esterno).
-- -----------------------------------------------------------------------------
alter table public.rooms   enable row level security;
alter table public.players enable row level security;
alter table public.rounds  enable row level security;
alter table public.votes   enable row level security;

-- rooms
drop policy if exists rooms_select_members on public.rooms;
create policy rooms_select_members on public.rooms
  for select to authenticated
  using (public.is_room_member(id));

drop policy if exists rooms_update_host on public.rooms;
create policy rooms_update_host on public.rooms
  for update to authenticated
  using (public.is_room_host(id))
  with check (public.is_room_host(id));

-- Privilegi per colonna: in Postgres un GRANT UPDATE sulla tabella copre tutte
-- le colonne e non è scalfito da un REVOKE per colonna. Va prima revocato
-- l'UPDATE sulla tabella, poi concesso solo sulle colonne modificabili.
-- Su rooms l'host può cambiare solo le impostazioni di partita: is_premium_ai
-- resta scrivibile unicamente dal server, altrimenti l'acquisto in-app sarebbe
-- aggirabile con una singola chiamata REST.
revoke update on public.rooms from anon, authenticated;
grant update (status, active_game, tone, rounds_total) on public.rooms to authenticated;

-- players
drop policy if exists players_select_members on public.players;
create policy players_select_members on public.players
  for select to authenticated
  using (public.is_room_member(room_id));

drop policy if exists players_update_self on public.players;
create policy players_update_self on public.players
  for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists players_delete_self on public.players;
create policy players_delete_self on public.players
  for delete to authenticated
  using (user_id = auth.uid());

-- il giocatore può cambiare solo nome e colore: il punteggio lo assegna il
-- server (RPC security definer)
revoke update on public.players from anon, authenticated;
grant update (name, color) on public.players to authenticated;

-- rounds
drop policy if exists rounds_select_members on public.rounds;
create policy rounds_select_members on public.rounds
  for select to authenticated
  using (public.is_room_member(room_id));

drop policy if exists rounds_insert_host on public.rounds;
create policy rounds_insert_host on public.rounds
  for insert to authenticated
  with check (public.is_room_host(room_id));

drop policy if exists rounds_update_host on public.rounds;
create policy rounds_update_host on public.rounds
  for update to authenticated
  using (public.is_room_host(room_id))
  with check (public.is_room_host(room_id));

-- l'host fa avanzare il round (waiting_votes -> revealed), non può riscrivere
-- room_id, game_type o round_number di un round già creato
revoke update on public.rounds from anon, authenticated;
grant update (status, content) on public.rounds to authenticated;

-- votes
drop policy if exists votes_select_members on public.votes;
create policy votes_select_members on public.votes
  for select to authenticated
  using (
    exists (
      select 1 from public.rounds r
      where r.id = votes.round_id and public.is_room_member(r.room_id)
    )
  );

-- si può votare solo per sé stessi, e solo su un round ancora aperto
drop policy if exists votes_insert_self on public.votes;
create policy votes_insert_self on public.votes
  for insert to authenticated
  with check (
    exists (
      select 1 from public.players p
      where p.id = votes.player_id and p.user_id = auth.uid()
    )
    and exists (
      select 1 from public.rounds r
      where r.id = votes.round_id and r.status = 'waiting_votes'
    )
  );

-- -----------------------------------------------------------------------------
-- 5. RPC: creazione stanza e ingresso
-- -----------------------------------------------------------------------------

-- Codice di 4 caratteri, alfabeto senza caratteri ambigui (niente O/0, I/1)
-- perché il codice viene letto ad alta voce.
create or replace function public.gen_room_code()
returns text
language plpgsql
volatile
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text := '';
  i int;
begin
  for i in 1..4 loop
    result := result || substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1);
  end loop;
  return result;
end;
$$;

create or replace function public.create_room(
  p_name  text,
  p_color text
)
returns table (room_id uuid, room_code text, player_id uuid)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code   text;
  v_room   uuid;
  v_player uuid;
  attempts int := 0;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED';
  end if;

  -- riprova finché non pesca un codice libero
  loop
    attempts := attempts + 1;
    v_code := public.gen_room_code();
    exit when not exists (select 1 from public.rooms where code = v_code);
    if attempts > 20 then
      raise exception 'CODE_GENERATION_FAILED';
    end if;
  end loop;

  insert into public.rooms (code) values (v_code) returning id into v_room;

  insert into public.players (room_id, user_id, name, color, is_host)
  values (v_room, auth.uid(), btrim(p_name), p_color, true)
  returning id into v_player;

  update public.rooms set host_id = v_player where id = v_room;

  return query select v_room, v_code, v_player;
end;
$$;

create or replace function public.join_room(
  p_code  text,
  p_name  text,
  p_color text
)
returns table (room_id uuid, room_code text, player_id uuid)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room     public.rooms%rowtype;
  v_player   uuid;
  v_count    int;
begin
  if auth.uid() is null then
    raise exception 'AUTH_REQUIRED';
  end if;

  -- NB: i parametri di OUT (room_id, room_code, player_id) hanno lo stesso nome
  -- di alcune colonne, quindi ogni riferimento va qualificato con l'alias di
  -- tabella, altrimenti Postgres solleva 42702 (column reference is ambiguous).
  select r.* into v_room from public.rooms r where r.code = upper(btrim(p_code));
  if not found then
    raise exception 'ROOM_NOT_FOUND';
  end if;
  if v_room.status = 'finished' then
    raise exception 'ROOM_FINISHED';
  end if;

  -- rientro dopo un riavvio dell'app: stesso utente, stessa stanza
  select p.id into v_player
  from public.players p
  where p.room_id = v_room.id and p.user_id = auth.uid();

  if v_player is not null then
    update public.players as p
      set name = btrim(p_name), color = p_color
      where p.id = v_player;
    return query select v_room.id, v_room.code, v_player;
    return;
  end if;

  select count(*) into v_count from public.players p where p.room_id = v_room.id;
  if v_count >= 10 then
    raise exception 'ROOM_FULL';
  end if;

  insert into public.players (room_id, user_id, name, color, is_host)
  values (v_room.id, auth.uid(), btrim(p_name), p_color, false)
  returning id into v_player;

  return query select v_room.id, v_room.code, v_player;
end;
$$;

revoke all on function public.create_room(text, text) from public, anon;
revoke all on function public.join_room(text, text, text) from public, anon;
grant execute on function public.create_room(text, text) to authenticated;
grant execute on function public.join_room(text, text, text) to authenticated;

-- -----------------------------------------------------------------------------
-- 6. Realtime
--    replica identity full serve perché la RLS possa essere valutata anche
--    sugli eventi UPDATE/DELETE inviati ai client.
-- -----------------------------------------------------------------------------
alter table public.rooms   replica identity full;
alter table public.players replica identity full;
alter table public.rounds  replica identity full;
alter table public.votes   replica identity full;

do $$
declare
  t text;
begin
  foreach t in array array['rooms', 'players', 'rounds', 'votes'] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
