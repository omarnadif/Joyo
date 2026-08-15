# Joyo

Party game multiplayer in tempo reale: ogni giocatore usa il proprio telefono,
uno crea la stanza, gli altri entrano con un codice di 4 caratteri.

**Stack:** Flutter (Android → iOS) · Supabase (Postgres + Realtime + Auth anonima)
· Edge Function con GPT-4o-mini per i contenuti premium · Google Play Billing · AdMob.

---

## Setup

### 1. Progetto Supabase

1. Crea un progetto su [supabase.com](https://supabase.com).
2. **Authentication → Sign In / Providers → Anonymous sign-ins: attivo.**
3. **SQL Editor** → incolla ed esegui `supabase/migrations/0001_init.sql`.
4. **Settings → API**: copia *Project URL* e *anon / publishable key*.

### 2. Chiavi in locale

```bash
cp env.example.json env.json   # su Windows: copy env.example.json env.json
```

Incolla URL e chiave in `env.json`. Il file è in `.gitignore`: non finisce mai nel repo.

### 3. Avvio

```bash
flutter run --dart-define-from-file=env.json                 # device predefinito
flutter run --dart-define-from-file=env.json -d chrome       # per testare in più finestre
flutter emulators --launch Pixel_8_Pro_API_36                # emulatore Android
```

Senza `--dart-define-from-file` l'app parte comunque e mostra la schermata con le
istruzioni di configurazione, invece di crashare.

---

## Struttura

```
lib/
  main.dart                        bootstrap + Supabase.initialize
  app.dart                         MaterialApp e tema
  core/
    env/app_env.dart               chiavi da --dart-define
    theme/                         palette e tema (Space Grotesk + Sora)
    supabase/supabase_providers.dart   client, sessione anonima, health check
  features/
    diagnostics/                   schermata di verifica della Fase 1
supabase/
  migrations/0001_init.sql         schema, RLS, RPC, realtime
```

## Modello dati

| Tabella   | Ruolo |
|-----------|-------|
| `rooms`   | stanza: codice, host, stato, gioco attivo, flag premium AI, tono, n. round |
| `players` | giocatori della stanza: nome, colore, host, punteggio |
| `rounds`  | round di gioco: tipo, numero, contenuto (jsonb), stato |
| `votes`   | voto di un giocatore su un round (jsonb, un voto per round) |

Realtime attivo su tutte e quattro le tabelle.

### Sicurezza

- Ogni client fa `signInAnonymously()`; `players.user_id` lega la riga all'utente.
- RLS: si vedono solo i dati delle stanze di cui si fa parte.
- Entrare in una stanza passa dalle RPC `create_room` / `join_room`
  (`security definer`): i codici stanza non sono enumerabili dall'esterno.
- `players.score` e `rooms.is_premium_ai` non sono scrivibili dal client:
  li aggiorna solo il server (RPC / Edge Function).

---

## Stato di sviluppo

- [x] **Fase 1** — Fondazione: progetto, tema, Supabase, schema, auth anonima
- [ ] **Fase 2** — Lobby realtime
- [ ] **Fase 3** — Preferisci
- [ ] **Fase 4** — Non ho mai
- [ ] **Fase 5** — Chi lo potrebbe fare
- [ ] **Fase 6** — Obbligo o Verità
- [ ] **Fase 7** — Bluff Story
- [ ] **Fase 8** — Podio e punteggi
- [ ] **Fase 9** — Premium AI
- [ ] **Fase 10** — AdMob
- [ ] **Fase 11** — Impostore
