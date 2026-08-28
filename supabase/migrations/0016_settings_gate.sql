-- =============================================================================
-- Joyo — gate premium lato server per modalità e round.
--
-- Fino a ora mode/tone/rounds_total erano scrivibili direttamente dal client
-- (grant UPDATE + policy rooms_update_host). Bastava una chiamata REST per
-- mettersi Hot o 20 round senza sbloccare nulla: il lucchetto era solo UI.
--
-- Qui la scrittura di queste tre colonne passa da una RPC security-definer che
-- verifica host e permessi. Restano scrivibili dal client solo status e
-- active_game, che servono al flusso di gioco (setActiveGame, backToLobby).
--
-- "Premium" della stanza = acquisto AI (is_premium_ai) oppure sblocco da shop
-- (mode_unlock_progress >= 3). In futuro anche l'abbonamento accenderà il flag.
-- Sblocca sia Mix/Hot sia i round oltre 10.
-- =============================================================================

-- Togli mode/tone/rounds_total dalle colonne scrivibili dal client.
revoke update on public.rooms from anon, authenticated;
grant  update (status, active_game) on public.rooms to authenticated;

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

  v_premium := v_room.is_premium_ai or v_room.mode_unlock_progress >= 3;

  if p_mode is not null then
    if p_mode not in ('normale', 'mix', 'hot') then
      raise exception 'BAD_MODE';
    end if;
    if p_mode in ('mix', 'hot') and not v_premium then
      raise exception 'LOCKED';
    end if;
    update public.rooms
       set mode = p_mode,
           -- il tono segue la modalità (normale→normal, mix→mix, hot→hot):
           -- è ciò che i giochi leggono da rooms.tone.
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

revoke all on function public.update_room_settings(uuid, text, int)
  from public, anon;
grant execute on function public.update_room_settings(uuid, text, int)
  to authenticated;
