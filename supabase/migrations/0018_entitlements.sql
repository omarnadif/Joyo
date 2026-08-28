-- =============================================================================
-- Joyo — abbonamenti per utente (entitlements).
--
-- Due prodotti, legati all'account (non alla stanza), con scadenza:
--   * joyo_no_ads   (€1.99/mese) — niente pubblicità;
--   * joyo_premium  (€3.99/mese) — premium completo: Mix/Hot, round >10 e
--     niente pubblicità.
--
-- La riga la scrive solo la Edge Function verify-subscription (verifica la
-- ricevuta col service role): il client può SOLO leggere le proprie, mai
-- crearle o modificarle, altrimenti l'abbonamento sarebbe gratis via REST.
--
-- Il gate premium delle stanze (update_room_settings, start_game) ora guarda
-- anche l'entitlement dell'host: un abbonato premium sblocca Mix/Hot e i round
-- in qualsiasi stanza ospiti, senza toccare flag per-stanza.
-- =============================================================================

create table if not exists public.entitlements (
  user_id    uuid        not null references auth.users(id) on delete cascade,
  product    text        not null check (product in ('joyo_no_ads', 'joyo_premium')),
  expires_at timestamptz not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, product)
);

alter table public.entitlements enable row level security;

-- Il client legge solo le proprie righe. Nessuna policy di scrittura: insert e
-- update passano dal service role (Edge Function), che ignora la RLS.
drop policy if exists entitlements_select_own on public.entitlements;
create policy entitlements_select_own on public.entitlements
  for select to authenticated
  using (user_id = auth.uid());

grant select on public.entitlements to authenticated;

-- Vero se l'utente ha un abbonamento premium attivo (non scaduto).
create or replace function public.has_premium(p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.entitlements e
     where e.user_id = p_user
       and e.product = 'joyo_premium'
       and e.expires_at > now()
  );
$$;

revoke all on function public.has_premium(uuid) from public, anon;
grant execute on function public.has_premium(uuid) to authenticated;

-- --- gate: aggiunge l'entitlement premium dell'host ai segnali già esistenti ---

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
            or v_room.mode_unlock_progress >= 3
            or public.has_premium(auth.uid());

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
  v_mode    text;
  v_premium boolean;
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  select r.mode,
         r.is_premium_ai or r.mode_unlock_progress >= 3 or public.has_premium(auth.uid())
    into v_mode, v_premium
    from public.rooms r
   where r.id = p_room;

  if v_mode in ('mix', 'hot') and not v_premium then
    raise exception 'LOCKED';
  end if;

  delete from public.rounds r where r.room_id = p_room;
  update public.players p set score = 0 where p.room_id = p_room;
  update public.rooms r
     set status = 'in_game',
         active_game = p_game,
         -- consuma solo lo sblocco da shop; l'abbonamento premium resta
         mode_unlock_progress = 0
   where r.id = p_room;
end;
$$;

revoke all on function public.update_room_settings(uuid, text, int) from public, anon;
grant execute on function public.update_room_settings(uuid, text, int) to authenticated;
revoke all on function public.start_game(uuid, text) from public, anon;
grant execute on function public.start_game(uuid, text) to authenticated;
