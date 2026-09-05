-- =============================================================================
-- Joyo — entitlements conserva il token dello store per la riverifica.
--
-- La scadenza scritta all'acquisto non veniva mai aggiornata: dopo un rinnovo
-- l'abbonato risultava scaduto, dopo una disdetta restava premium fino alla
-- data scritta. Con il token (purchase token Play / ricevuta App Store) la
-- Edge Function verify-subscription può richiedere allo store lo stato attuale
-- ad ogni avvio dell'app (modalità refresh) e riallineare expires_at.
--
-- Il client continua a poter solo leggere le proprie righe; il token non gli
-- serve e non viene esposto: la select del client chiede solo product e
-- expires_at, e comunque il token da solo non dà alcun diritto.
-- =============================================================================

alter table public.entitlements
  add column if not exists platform        text check (platform in ('android', 'ios')),
  add column if not exists purchase_token  text,
  add column if not exists last_checked_at timestamptz;
