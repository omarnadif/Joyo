-- =============================================================================
-- Joyo — award_points chiude anche il round.
--
-- In 0006 la funzione assegnava i punti ma lasciava il round 'waiting_votes':
-- era il client a metterlo 'revealed' con una seconda chiamata. Se la rete
-- cadeva in mezzo, il client ripeteva award_points su un round ancora aperto e
-- i punti raddoppiavano. Ora punti e reveal sono la stessa transazione: la
-- seconda chiamata trova il round chiuso e non fa nulla.
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
  -- Lock del round: due chiamate simultanee si mettono in fila e la seconda
  -- vede lo stato 'revealed' scritto dalla prima.
  select r.* into v_round from public.rounds r where r.id = p_round for update;
  if not found then
    raise exception 'ROUND_NOT_FOUND';
  end if;
  if not public.is_room_host(v_round.room_id) then
    raise exception 'NOT_HOST';
  end if;
  if v_round.status <> 'waiting_votes' then
    return;   -- già assegnati e svelati
  end if;

  for v_player, v_points in
    select key, value::numeric from jsonb_each_text(p_awards)
  loop
    update public.players p
       set score = p.score + v_points::int
     where p.id = v_player::uuid
       and p.room_id = v_round.room_id;
  end loop;

  update public.rounds r set status = 'revealed' where r.id = p_round;
end;
$$;
