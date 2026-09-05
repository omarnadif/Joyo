-- =============================================================================
-- Joyo — rooms.status scrivibile solo dal server.
--
-- start_game (0019) consuma un credito partita solo quando la stanza NON è già
-- 'in_game'. Ma 0016 lasciava all'host il grant UPDATE su rooms.status: con una
-- chiamata REST poteva mettere la stanza 'in_game' da solo e poi chiamare
-- start_game senza consumare nulla → Mix/Hot gratis, senza abbonamento né
-- annunci.
--
-- Da qui in poi lo stato cambia solo tramite RPC (start_game, finish_game,
-- back_to_lobby). L'host conserva il grant su active_game (cambio gioco in
-- modalità Mix a partita in corso), che non incide sui crediti.
-- =============================================================================

revoke update on public.rooms from anon, authenticated;
grant  update (active_game) on public.rooms to authenticated;

-- Fine partita: si va al podio. Solo l'host.
create or replace function public.finish_game(p_room uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;
  update public.rooms r
     set status = 'finished'
   where r.id = p_room;
  if not found then
    raise exception 'ROOM_NOT_FOUND';
  end if;
end;
$$;

-- Tutti in lobby, gioco azzerato. Solo l'host.
create or replace function public.back_to_lobby(p_room uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;
  update public.rooms r
     set status = 'lobby', active_game = null
   where r.id = p_room;
  if not found then
    raise exception 'ROOM_NOT_FOUND';
  end if;
end;
$$;

revoke all on function public.finish_game(uuid) from public, anon;
grant execute on function public.finish_game(uuid) to authenticated;
revoke all on function public.back_to_lobby(uuid) from public, anon;
grant execute on function public.back_to_lobby(uuid) to authenticated;
