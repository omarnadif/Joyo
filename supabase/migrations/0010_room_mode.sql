-- =============================================================================
-- Joyo — modalità della stanza: normale, mix, hot.
--
-- Sostituisce la scelta del "tono" con qualcosa che si capisce al volo prima
-- di iniziare a giocare. La modalità decide due cose:
--   * quanto sono spinti i contenuti pescati;
--   * se il gioco resta lo stesso per tutta la partita (normale, hot) oppure
--     cambia a ogni round (mix).
--
-- La colonna tone resta perché i contenuti sono ancora catalogati per tono:
-- è la modalità a dire quali toni sono ammessi.
-- =============================================================================

alter table public.rooms
  add column if not exists mode text not null default 'normale'
  check (mode in ('normale', 'mix', 'hot'));

-- il grant va riscritto per intero, aggiungendo mode alle colonne modificabili
revoke update on public.rooms from anon, authenticated;
grant  update (status, active_game, tone, rounds_total, mode)
  on public.rooms to authenticated;
