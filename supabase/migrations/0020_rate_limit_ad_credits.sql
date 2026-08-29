-- =============================================================================
-- Joyo — rate limit su grant_mode_unlock.
--
-- La RPC era chiamabile in loop da qualunque utente autenticato: con la
-- publishable key estratta dall'APK si coniavano partite premium illimitate
-- senza guardare alcun annuncio. Non potendo (ancora) verificare l'annuncio
-- con la SSV di AdMob, si rende l'abuso inutile: i crediti non possono
-- arrivare più in fretta di quanto farebbe un utente che gli annunci li
-- guarda davvero.
--
--   * intervallo minimo fra due grant: 15 secondi (un rewarded dura di più);
--   * tetto giornaliero: 30 annunci (= 10 partite premium, oltre l'uso reale);
--   * tetto alle partite in banca: 10 (si continua a giocare, non ad accumulare).
--
-- Errori: TOO_FAST (ritenta più tardi), DAILY_LIMIT (torna domani),
-- BANK_FULL (spendi le partite che hai). Il client li mostra come "riprova".
-- =============================================================================

alter table public.user_premium_credits
  add column if not exists last_ad_at timestamptz,
  add column if not exists ads_today  int  not null default 0 check (ads_today >= 0),
  add column if not exists ads_day    date not null default (now()::date);

create or replace function public.grant_mode_unlock()
returns table (ad_progress int, games int)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_row public.user_premium_credits%rowtype;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED';
  end if;

  insert into public.user_premium_credits (user_id)
  values (v_uid)
  on conflict (user_id) do nothing;

  -- Lock della riga: due chiamate simultanee dello stesso utente si mettono
  -- in fila e la seconda vede il last_ad_at aggiornato dalla prima.
  select * into v_row
    from public.user_premium_credits
   where user_id = v_uid
   for update;

  if v_row.last_ad_at is not null
     and now() - v_row.last_ad_at < interval '15 seconds' then
    raise exception 'TOO_FAST';
  end if;

  -- Il contatore giornaliero riparte a mezzanotte (UTC).
  if v_row.ads_day <> now()::date then
    v_row.ads_today := 0;
  end if;
  if v_row.ads_today >= 30 then
    raise exception 'DAILY_LIMIT';
  end if;

  if v_row.games >= 10 then
    raise exception 'BANK_FULL';
  end if;

  return query
  update public.user_premium_credits u
     set games       = u.games + ((u.ad_progress + 1) / 3),
         ad_progress = (u.ad_progress + 1) % 3,
         last_ad_at  = now(),
         ads_today   = v_row.ads_today + 1,
         ads_day     = now()::date,
         updated_at  = now()
   where u.user_id = v_uid
  returning u.ad_progress, u.games;
end;
$$;

revoke all on function public.grant_mode_unlock() from public, anon;
grant execute on function public.grant_mode_unlock() to authenticated;
