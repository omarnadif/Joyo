-- =============================================================================
-- Joyo — sblocco modalità PER UTENTE (non più per stanza).
--
-- Prima i 3 annunci sbloccavano la singola stanza (serviva essere host in una
-- stanza). Ora si possono guardare da qualunque punto, anche dallo shop in
-- home: 3 annunci = 1 "partita premium" in banca, spesa all'avvio di una
-- partita Mix/Hot (o con round >10) quando non si ha l'abbonamento.
--
--   ad_progress: annunci visti verso la prossima partita (0..2)
--   games:       partite premium in banca (>=0), consumate a start_game
--
-- Solo le RPC security-definer scrivono la tabella; il client legge le proprie
-- righe (RLS) ma non può aggiungersi crediti.
-- =============================================================================

create table if not exists public.user_premium_credits (
  user_id     uuid not null primary key references auth.users(id) on delete cascade,
  ad_progress int  not null default 0 check (ad_progress >= 0 and ad_progress < 3),
  games       int  not null default 0 check (games >= 0),
  updated_at  timestamptz not null default now()
);

alter table public.user_premium_credits enable row level security;

drop policy if exists upc_select_own on public.user_premium_credits;
create policy upc_select_own on public.user_premium_credits
  for select to authenticated
  using (user_id = auth.uid());

grant select on public.user_premium_credits to authenticated;
revoke insert, update, delete on public.user_premium_credits from anon, authenticated;

-- Annuncio con premio visto: avanza il progresso; ogni 3 → +1 partita in banca.
-- Ritorna lo stato aggiornato (ad_progress, games).
create or replace function public.grant_mode_unlock()
returns table (ad_progress int, games int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED';
  end if;

  insert into public.user_premium_credits (user_id)
  values (v_uid)
  on conflict (user_id) do nothing;

  return query
  update public.user_premium_credits u
     set games       = u.games + ((u.ad_progress + 1) / 3),
         ad_progress = (u.ad_progress + 1) % 3,
         updated_at  = now()
   where u.user_id = v_uid
  returning u.ad_progress, u.games;
end;
$$;

revoke all on function public.grant_mode_unlock() from public, anon;
grant execute on function public.grant_mode_unlock() to authenticated;

-- Vero se l'utente ha almeno una partita premium in banca.
create or replace function public.has_game_credit(p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.user_premium_credits u
     where u.user_id = p_user and u.games > 0
  );
$$;

revoke all on function public.has_game_credit(uuid) from public, anon;
grant execute on function public.has_game_credit(uuid) to authenticated;

-- Rimpiazza la vecchia grant_mode_unlock(uuid) legata alla stanza.
drop function if exists public.grant_mode_unlock(uuid);

-- --- gate aggiornato: il credito partita vale come premium per la selezione ---

create or replace function public.update_room_settings(
  p_room   uuid,
  p_mode   text default null,
  p_rounds int  default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room    public.rooms%rowtype;
  v_premium boolean;
begin
  select * into v_room from public.rooms where id = p_room;
  if not found then
    raise exception 'ROOM_NOT_FOUND';
  end if;
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  v_premium := v_room.is_premium_ai
            or public.has_premium(auth.uid())
            or public.has_game_credit(auth.uid());

  if p_mode is not null then
    if p_mode not in ('normale', 'mix', 'hot') then
      raise exception 'BAD_MODE';
    end if;
    if p_mode in ('mix', 'hot') and not v_premium then
      raise exception 'LOCKED';
    end if;
    update public.rooms
       set mode = p_mode,
           tone = case p_mode when 'normale' then 'normal' else p_mode end
     where id = p_room;
  end if;

  if p_rounds is not null then
    if p_rounds not in (5, 10, 15, 20) then
      raise exception 'BAD_ROUNDS';
    end if;
    if p_rounds > 10 and not v_premium then
      raise exception 'LOCKED';
    end if;
    update public.rooms set rounds_total = p_rounds where id = p_room;
  end if;
end;
$$;

-- start_game: se la partita usa una feature premium e l'host non è abbonato,
-- consuma una partita in banca; senza credito → LOCKED.
create or replace function public.start_game(
  p_room uuid,
  p_game text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_room         public.rooms%rowtype;
  v_uid          uuid := auth.uid();
  v_sub          boolean;
  v_uses_premium boolean;
begin
  select * into v_room from public.rooms where id = p_room;
  if not found then
    raise exception 'ROOM_NOT_FOUND';
  end if;
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  v_sub := v_room.is_premium_ai or public.has_premium(v_uid);
  v_uses_premium := v_room.mode in ('mix', 'hot') or v_room.rounds_total > 10;

  -- Consuma una partita in banca solo alla transizione verso una nuova partita
  -- premium, e solo se non si è abbonati.
  if v_uses_premium and not v_sub and v_room.status <> 'in_game' then
    update public.user_premium_credits u
       set games = u.games - 1, updated_at = now()
     where u.user_id = v_uid and u.games > 0;
    if not found then
      raise exception 'LOCKED';
    end if;
  end if;

  delete from public.rounds r where r.room_id = p_room;
  update public.players p set score = 0 where p.room_id = p_room;
  update public.rooms r
     set status = 'in_game', active_game = p_game
   where r.id = p_room;
end;
$$;

revoke all on function public.update_room_settings(uuid, text, int) from public, anon;
grant execute on function public.update_room_settings(uuid, text, int) to authenticated;
revoke all on function public.start_game(uuid, text) from public, anon;
grant execute on function public.start_game(uuid, text) to authenticated;
