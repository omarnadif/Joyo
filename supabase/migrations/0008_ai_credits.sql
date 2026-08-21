-- =============================================================================
-- Joyo — crediti AI della stanza.
--
-- Servono a due cose:
--   * l'acquisto in-app accende is_premium_ai per tutta la sessione;
--   * l'annuncio con premio regala un singolo contenuto generato dall'AI.
--
-- Come is_premium_ai, ai_credits non è fra le colonne scrivibili dal client:
-- lo tocca solo il server, altrimenti basterebbe una chiamata REST per avere
-- l'AI gratis.
-- =============================================================================

alter table public.rooms
  add column if not exists ai_credits int not null default 0
  check (ai_credits >= 0);

-- l'elenco delle colonne aggiornabili va riscritto per intero: un nuovo grant
-- non sostituisce il precedente, e ai_credits non deve entrarci
revoke update on public.rooms from anon, authenticated;
grant  update (status, active_game, tone, rounds_total) on public.rooms to authenticated;
