-- =============================================================================
-- Joyo — lo sblocco da shop vale una sola partita.
--
-- I 3 annunci dello shop (mode_unlock_progress = 3) sbloccano Mix/Hot per UNA
-- partita, non per la vita della stanza: qui l'avvio partita consuma il
-- contatore azzerandolo. Per la partita successiva servono altri 3 annunci.
--
-- L'acquisto premium (is_premium_ai) invece persiste e non viene consumato.
-- start_game ora valida anche la modalità: se è premium e la stanza non è
-- sbloccata rifiuta (chiude il replay di Hot senza guardare gli annunci).
-- =============================================================================

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

  select r.mode, r.is_premium_ai or r.mode_unlock_progress >= 3
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
         -- consuma lo sblocco da shop: vale solo per questa partita
         mode_unlock_progress = 0
   where r.id = p_room;
end;
$$;

revoke all on function public.start_game(uuid, text) from public, anon;
grant execute on function public.start_game(uuid, text) to authenticated;
