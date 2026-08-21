-- =============================================================================
-- Joyo — avvio partita come operazione unica lato server.
--
-- Serve perché rigiocando nella stessa stanza restavano i round della partita
-- precedente: il client avrebbe mostrato per un attimo l'ultimo round vecchio
-- invece di ripartire da zero. E perché azzerare i punteggi è una scrittura su
-- players.score, che il client non può fare (e non deve poter fare).
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
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  delete from public.rounds r where r.room_id = p_room;
  update public.players p set score = 0 where p.room_id = p_room;
  update public.rooms r
     set status = 'in_game', active_game = p_game
   where r.id = p_room;
end;
$$;

revoke all on function public.start_game(uuid, text) from public, anon;
grant execute on function public.start_game(uuid, text) to authenticated;
