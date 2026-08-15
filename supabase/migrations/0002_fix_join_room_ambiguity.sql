-- =============================================================================
-- Joyo — fix: join_room falliva con 42702 "column reference room_id is ambiguous".
--
-- I parametri di OUT della funzione (room_id, room_code, player_id) hanno lo
-- stesso nome di colonne di players/rooms: ogni riferimento va qualificato con
-- l'alias di tabella. Su un database creato da zero con 0001_init.sql aggiornato
-- questa migrazione è già inclusa, ma rilanciarla non fa danni.
-- =============================================================================

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

revoke all on function public.join_room(text, text, text) from public, anon;
grant execute on function public.join_room(text, text, text) to authenticated;
