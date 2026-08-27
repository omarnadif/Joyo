-- =============================================================================
-- Joyo — Avatar del giocatore nella stanza.
--
-- Finora ogni giocatore era solo un colore + iniziale del nome: con la stanza
-- piena diventava difficile riconoscersi a colpo d'occhio. Ora ognuno sceglie
-- anche un avatar illustrato (personas flat), pubblicato entrando nella stanza
-- e mostrato ovunque (lobby, chip, bottiglia, voti).
--
-- La colonna ha un default così le righe e i client vecchi continuano a
-- funzionare; le RPC di ingresso ora accettano p_avatar (con default, quindi
-- un client non aggiornato non si rompe).
-- =============================================================================

alter table public.players
  add column if not exists avatar text not null default 'tan_m';

-- il giocatore può cambiare anche il proprio avatar (come nome/colore)
grant update (avatar) on public.players to authenticated;

-- Le firme cambiano (nuovo parametro), quindi niente "create or replace":
-- si rimuovono le versioni a 3/4 argomenti e si creano le nuove.
drop function if exists public.create_room(text, text, text);
drop function if exists public.join_room(text, text, text, text);

create or replace function public.create_room(
  p_name   text,
  p_color  text,
  p_locale text default 'en',
  p_avatar text default 'tan_m'
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

  loop
    attempts := attempts + 1;
    v_code := public.gen_room_code();
    exit when not exists (select 1 from public.rooms where code = v_code);
    if attempts > 20 then
      raise exception 'CODE_GENERATION_FAILED';
    end if;
  end loop;

  insert into public.rooms (code) values (v_code) returning id into v_room;

  insert into public.players (room_id, user_id, name, color, is_host, locale, avatar)
  values (v_room, auth.uid(), btrim(p_name), p_color, true,
          coalesce(p_locale, 'en'), coalesce(p_avatar, 'tan_m'))
  returning id into v_player;

  update public.rooms set host_id = v_player where id = v_room;

  return query select v_room, v_code, v_player;
end;
$$;

create or replace function public.join_room(
  p_code   text,
  p_name   text,
  p_color  text,
  p_locale text default 'en',
  p_avatar text default 'tan_m'
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

  -- rientro dopo un riavvio dell'app: stesso utente, stessa stanza. Aggiorna
  -- anche avatar/lingua, che potrebbero essere cambiati da un ingresso all'altro.
  select p.id into v_player
  from public.players p
  where p.room_id = v_room.id and p.user_id = auth.uid();

  if v_player is not null then
    update public.players as p
      set name = btrim(p_name), color = p_color,
          locale = coalesce(p_locale, 'en'), avatar = coalesce(p_avatar, 'tan_m')
      where p.id = v_player;
    return query select v_room.id, v_room.code, v_player;
    return;
  end if;

  select count(*) into v_count from public.players p where p.room_id = v_room.id;
  if v_count >= 10 then
    raise exception 'ROOM_FULL';
  end if;

  insert into public.players (room_id, user_id, name, color, is_host, locale, avatar)
  values (v_room.id, auth.uid(), btrim(p_name), p_color, false,
          coalesce(p_locale, 'en'), coalesce(p_avatar, 'tan_m'))
  returning id into v_player;

  return query select v_room.id, v_room.code, v_player;
end;
$$;

revoke all on function public.create_room(text, text, text, text) from public, anon;
revoke all on function public.join_room(text, text, text, text, text) from public, anon;
grant execute on function public.create_room(text, text, text, text) to authenticated;
grant execute on function public.join_room(text, text, text, text, text) to authenticated;
