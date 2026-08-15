-- =============================================================================
-- Joyo — fix di sicurezza: privilegi di UPDATE per colonna.
--
-- In 0001 avevo scritto `revoke update (colonna) ... from authenticated`, che in
-- Postgres non ha effetto: se il ruolo possiede il privilegio UPDATE sull'intera
-- tabella (come fa authenticated per default su Supabase), il revoke per colonna
-- non lo scalfisce. Risultato: un giocatore poteva impostarsi score = 9999 e
-- l'host poteva accendersi is_premium_ai da solo, aggirando l'acquisto in-app.
--
-- La forma corretta è: revoke dell'UPDATE sulla tabella, poi grant sulle sole
-- colonne che il client può davvero modificare.
-- =============================================================================

-- players: il giocatore cambia solo nome e colore; score lo scrive il server
revoke update on public.players from anon, authenticated;
grant  update (name, color) on public.players to authenticated;

-- rooms: l'host cambia solo le impostazioni di partita.
-- is_premium_ai, code, host_id restano scrivibili solo dal server.
revoke update on public.rooms from anon, authenticated;
grant  update (status, active_game, tone, rounds_total) on public.rooms to authenticated;

-- rounds: l'host fa avanzare il round, ma non riscrive a cosa si sta giocando
revoke update on public.rounds from anon, authenticated;
grant  update (status, content) on public.rounds to authenticated;

-- votes: un voto non si modifica dopo averlo espresso
revoke update on public.votes from anon, authenticated;
