-- =============================================================================
-- Joyo — Impostore: l'autovoto non deve fruttare punti.
--
-- Nella prima versione i +2 andavano a chiunque avesse votato l'impostore,
-- impostore compreso: votando sé stesso si prendeva il bonus di chi lo
-- smaschera. Nell'app non è possibile (la propria riga non è votabile) ma
-- l'API sì, quindi la regola va applicata dove conta.
-- =============================================================================

create or replace function public.resolve_impostore(p_round uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_round     public.rounds%rowtype;
  v_impostor  uuid;
  v_word      text;
  v_max       int;
  v_impvotes  int;
  v_caught    boolean;
  v_guess     text;
  v_guess_ok  boolean := false;
  v_voter     record;
begin
  select r.* into v_round from public.rounds r where r.id = p_round;
  if not found then
    raise exception 'ROUND_NOT_FOUND';
  end if;
  if not public.is_room_host(v_round.room_id) then
    raise exception 'NOT_HOST';
  end if;
  if v_round.status <> 'waiting_votes' then
    return;
  end if;

  select s.player_id into v_impostor
  from public.round_secrets s
  where s.round_id = p_round and (s.payload->>'impostor')::boolean
  limit 1;

  select s.payload->>'word' into v_word
  from public.round_secrets s
  where s.round_id = p_round and s.payload ? 'word'
  limit 1;

  -- l'autovoto dell'impostore non conta né per smascherarlo né per i punti
  select count(*) into v_impvotes
  from public.votes v
  where v.round_id = p_round
    and v.value->>'suspect' = v_impostor::text
    and v.player_id <> v_impostor;

  select coalesce(max(c), 0) into v_max from (
    select count(*) as c
    from public.votes v
    where v.round_id = p_round
      and v.value->>'suspect' is not null
      and v.player_id <> v_impostor
    group by v.value->>'suspect'
  ) t;

  v_caught := v_impvotes > 0 and v_impvotes = v_max;

  select v.value->>'guess' into v_guess
  from public.votes v
  where v.round_id = p_round and v.player_id = v_impostor;

  if v_word is not null and v_guess is not null then
    v_guess_ok := lower(btrim(v_guess)) = lower(btrim(v_word));
  end if;

  if v_caught then
    for v_voter in
      select v.player_id
      from public.votes v
      where v.round_id = p_round
        and v.value->>'suspect' = v_impostor::text
        and v.player_id <> v_impostor
    loop
      update public.players p set score = p.score + 2 where p.id = v_voter.player_id;
    end loop;
    if v_guess_ok then
      update public.players p set score = p.score + 3 where p.id = v_impostor;
    end if;
  else
    update public.players p set score = p.score + 5 where p.id = v_impostor;
  end if;

  update public.rounds r
     set content = r.content || jsonb_build_object(
           'word', v_word,
           'impostor', v_impostor,
           'caught', v_caught,
           'guess', v_guess,
           'guess_ok', v_guess_ok
         ),
         status = 'revealed'
   where r.id = p_round;
end;
$$;
