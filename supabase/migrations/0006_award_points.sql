-- =============================================================================
-- Joyo — assegnazione punti lato server.
--
-- players.score non è scrivibile dal client (protezione anti-cheat), quindi i
-- punti dei giochi a punteggio passano da qui. La funzione è idempotente: i
-- punti si assegnano solo finché il round è ancora aperto, e subito dopo il
-- round viene messo a 'revealed'. Una seconda chiamata non fa nulla.
-- =============================================================================

create or replace function public.award_points(
  p_round  uuid,
  p_awards jsonb
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_round  public.rounds%rowtype;
  v_player text;
  v_points numeric;
begin
  select r.* into v_round from public.rounds r where r.id = p_round;
  if not found then
    raise exception 'ROUND_NOT_FOUND';
  end if;
  if not public.is_room_host(v_round.room_id) then
    raise exception 'NOT_HOST';
  end if;
  if v_round.status <> 'waiting_votes' then
    return;   -- già assegnati
  end if;

  for v_player, v_points in
    select key, value::numeric from jsonb_each_text(p_awards)
  loop
    update public.players p
       set score = p.score + v_points::int
     where p.id = v_player::uuid
       and p.room_id = v_round.room_id;
  end loop;
end;
$$;

revoke all on function public.award_points(uuid, jsonb) from public, anon;
grant execute on function public.award_points(uuid, jsonb) to authenticated;
