-- =============================================================================
-- Joyo — schema_migrations non raggiungibile dai ruoli dell'app.
--
-- tool/migrate.dart creava la tabella senza RLS né revoke: su Supabase i ruoli
-- anon/authenticated hanno privilegi di default sullo schema public, quindi
-- con la sola chiave pubblica si potevano leggere e CANCELLARE le righe.
-- Cancellare la riga di 0004 avrebbe fatto rieseguire al prossimo deploy un
-- `delete from rooms`. Il tool si connette come postgres (owner) e non è
-- toccato dalla RLS.
-- =============================================================================

create table if not exists public.schema_migrations (
  name       text primary key,
  applied_at timestamptz not null default now()
);

alter table public.schema_migrations enable row level security;
revoke all on table public.schema_migrations from public, anon, authenticated;
