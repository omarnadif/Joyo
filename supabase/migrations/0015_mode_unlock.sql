-- =============================================================================
-- Joyo — shop sblocco modalità (Mix / Hot).
--
-- Le modalità Mix e Hot sono premium. Oltre all'abbonamento, l'host può
-- sbloccarle per la stanza guardando 3 annunci con premio: ogni annuncio
-- avanza un contatore, a quota 3 le modalità restano sbloccate per la sessione.
--
-- Come ai_credits e is_premium_ai, mode_unlock_progress NON è fra le colonne
-- scrivibili dal client: lo tocca solo la RPC qui sotto (security definer),
-- altrimenti basterebbe una chiamata REST per sbloccare senza guardare nulla.
-- =============================================================================

alter table public.rooms
  add column if not exists mode_unlock_progress int not null default 0
  check (mode_unlock_progress >= 0 and mode_unlock_progress <= 3);

-- Avanza di uno il contatore dopo un annuncio con premio visto dall'host.
-- Ritorna il nuovo valore (capato a 3). Solo l'host della stanza può chiamarla.
create or replace function public.grant_mode_unlock(p_room uuid)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  v_progress int;
begin
  if not public.is_room_host(p_room) then
    raise exception 'NOT_HOST';
  end if;

  update public.rooms
     set mode_unlock_progress = least(mode_unlock_progress + 1, 3)
   where id = p_room
  returning mode_unlock_progress into v_progress;

  if v_progress is null then
    raise exception 'ROOM_NOT_FOUND';
  end if;

  return v_progress;
end;
$$;

revoke all on function public.grant_mode_unlock(uuid) from public, anon;
grant execute on function public.grant_mode_unlock(uuid) to authenticated;
