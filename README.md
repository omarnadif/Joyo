# Joyo

Party game multiplayer in tempo reale: ogni giocatore usa il proprio telefono,
uno crea la stanza, gli altri entrano con un codice di 6 caratteri.

**Stack:** Flutter (Android → iOS) · Supabase (Postgres + Realtime + Auth anonima)
· Edge Function con GPT-4o-mini per i contenuti premium · Google Play Billing · AdMob.

---

## Setup

### 1. Progetto Supabase

1. Crea un progetto su [supabase.com](https://supabase.com).
2. **Authentication → Sign In / Providers → Anonymous sign-ins: attivo**
   (è l'unica impostazione che non si può fare via SQL).
3. **Settings → Database → Connection string → Session pooler**: copia l'URI,
   sostituisci la password e salvalo in `supabase/.db_url` (una riga, fuori da git).
4. Applica lo schema:
   ```bash
   dart run tool/migrate.dart            # applica le migrazioni mancanti
   dart run tool/migrate.dart --status   # mostra cosa manca, senza scrivere
   ```
   Le migrazioni stanno in `supabase/migrations/` e vengono eseguite una sola
   volta ciascuna (registro nella tabella `schema_migrations`).
5. **Settings → API**: copia *Project URL* e *anon / publishable key*.

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

### Da Android Studio

Nel progetto ci sono quattro configurazioni pronte in `.run/`, che compaiono nel
menu accanto al tasto Play:

| Configurazione | A cosa serve |
|---|---|
| **Joyo** | avvio normale sul device scelto nel menu a tendina |
| **Joyo emulatori** | come la prima, ma con l'esecuzione in parallelo: si preme Play su un emulatore, si cambia device nel menu e si preme Play di nuovo — un'istanza per emulatore, per provare il multiplayer |
| **Joyo web 8123** | Chrome su porta fissa, per aprire una seconda finestra in incognito come secondo giocatore |
| **Joyo premium dev** | come la prima, ma con il premium sbloccato per le prove |

Tutte passano già `--dart-define-from-file=env.json`: premendo Play con una
configurazione creata a mano l'app mostrerebbe la schermata "configurazione
mancante".

### Emulatori da terminale

```bash
flutter emulators                          # elenca gli AVD (es. Pixel_10)
flutter emulators --launch Pixel_10        # avvia l'emulatore
flutter devices                            # id runtime (es. emulator-5554)
flutter run -d emulator-5554 --dart-define-from-file=env.json
```

Con due emulatori accesi basta ripetere `flutter run` con il secondo id
(`emulator-5556`) in un altro terminale.

---

## Verifiche automatiche

Test unitari (contenuti, estrazione, logica pura):

```bash
flutter test
```

Verifiche end-to-end contro il database vero, con più giocatori simulati:

```bash
dart run tool/realtime_check.dart  <URL> <ANON_KEY>   # lobby: entrata, uscita, chiusura stanza
dart run tool/game_check.dart      <URL> <ANON_KEY>   # round, voti, reveal, permessi
dart run tool/bluff_check.dart     <URL> <ANON_KEY>   # punteggi e anti-cheat
dart run tool/impostore_check.dart <URL> <ANON_KEY>   # segreti per giocatore e punteggi
dart run tool/rate_limit_check.dart <URL> <ANON_KEY>  # rate limit crediti da annuncio
```

Servono a distinguere subito un problema di interfaccia da uno di backend.

---

## Struttura

```
lib/
  main.dart                    bootstrap + Supabase.initialize
  app.dart                     MaterialApp, tema, colonna in stile telefono
  core/
    env/                       chiavi da --dart-define
    i18n/                      lingue e stringhe dell'interfaccia
    theme/                     palette e tipografia (Space Grotesk + Sora)
    ui/                        aurora di sfondo, card luminose, pulsanti
    supabase/                  client, sessione anonima, health check
  features/
    onboarding/                presentazione iniziale e scelta lingua
    home/                      home con i due bottoni e la griglia dei giochi
    diagnostics/               health check (long-press sul marchio) e schermata "configurazione mancante"
    room/                      lobby, impostazioni, ingresso/uscita, stato stanza
    games/
      engine/                  motore comune ai round: voto, timer, punti
      preferisci/  non_ho_mai/  chi_lo_potrebbe_fare/
      obbligo_o_verita/  bluff_story/  impostore/
      end_of_game_screen.dart  podio finale
    premium/                   acquisto in-app, abbonamenti, annunci
supabase/
  migrations/                  schema, RLS, RPC (applicate da tool/migrate.dart)
  functions/                   Edge Function: verify-subscription
tool/                          migrazioni e verifiche end-to-end
```

## Modello dati

| Tabella         | Ruolo |
|-----------------|-------|
| `rooms`         | stanza: codice, host, stato, gioco attivo, tono, round |
| `players`       | giocatori: nome, colore, host, punteggio |
| `rounds`        | round: tipo, numero, contenuto (jsonb), stato |
| `votes`         | risposta di un giocatore a un round (jsonb, una per round) |
| `round_secrets` | informazioni visibili a un solo giocatore (Impostore) |

Realtime attivo su tutte.

### Sicurezza

- Ogni client fa `signInAnonymously()`; `players.user_id` lega la riga all'utente.
- RLS: si vedono solo i dati delle stanze di cui si fa parte, e di `round_secrets`
  solo la propria riga.
- Ingresso via RPC `create_room` / `join_room`: i codici stanza non sono enumerabili.
- Il client può scrivere **solo** queste colonne:
  `players.name/color`, `rooms.status/active_game/tone/rounds_total`,
  `rounds.status/content` (solo host). Punteggi e diritti premium li scrive
  esclusivamente il server.
- I punti dei giochi a punteggio passano da `award_points` (idempotente) e da
  `resolve_impostore`, che calcola tutto lato server: l'host non deve mai vedere
  la parola segreta, potrebbe essere lui l'impostore.

---

## I giochi

| Gioco | Contenuti italiani | Punti |
|---|---|---|
| Preferisci | 112 coppie di opzioni | no |
| Non ho mai | 160 frasi | no |
| Chi lo potrebbe fare | 152 domande | no |
| Obbligo o Verità | 100 obblighi + 100 verità per ognuno dei 3 toni | no |
| Bluff Story | 130 bugie generiche | sì |
| Impostore | 120 parole segrete | sì |

## Lingue

L'interfaccia è tradotta per intero in **italiano, inglese, spagnolo, francese
e tedesco** (`lib/core/i18n/translations.dart`, una riga per concetto con le
cinque lingue affiancate).

I **contenuti di gioco** sono in `lib/features/games/content/`: l'italiano è la
lingua di riferimento con i pool più ampi, le altre quattro hanno un mazzo più
corto ma completo per ogni gioco e ogni modalità (circa 60 coppie Preferisci,
60 frasi per gioco, 20+20 obblighi e verità per tono, 30 bugie, 60 parole).
Ampliarle significa aggiungere righe a `content_xx.dart`, senza toccare altro.

La lingua dei **contenuti** è quella dell'host, perché è il suo telefono a
creare i round; l'interfaccia resta invece nella lingua scelta da ciascuno.

## Modalità

| Modalità | Contenuti | Giochi |
|---|---|---|
| **Normale** | solo soft | resta quello scelto |
| **Mix** | soft + piccante | cambia a ogni round |
| **Hot** | piccante + cattivo | resta quello scelto |

Modalità e numero di round si scelgono in lobby, prima di iniziare.

---

### Provare il premium senza pagare

```bash
flutter run --dart-define-from-file=env.json --dart-define=DEV_UNLOCK_PREMIUM=true
```

Sblocca le schermate premium **solo su quel telefono**: i gate lato server
restano attivi. La card in lobby mostra l'etichetta `DEV` per non confonderlo
con un acquisto vero.

Va tolto dalle build da pubblicare: senza il `--dart-define` è spento.

## Monetizzazione — cosa manca prima del rilascio

Il codice è completo, ma queste parti richiedono account e credenziali esterne:

1. **Edge Function** — va pubblicata una volta:
   ```bash
   supabase login
   supabase link --project-ref <ref>
   supabase functions deploy verify-subscription
   ```
2. **Verifica della ricevuta Google Play** — in `verify-subscription/index.ts`
   c'è il punto marcato con lo stub `const verified = true`. Senza la verifica
   vera un client modificato può sbloccare il premium senza pagare.
3. **Prodotti in-app** — vanno creati su Play Console con id `joyo_no_ads` e
   `joyo_premium` (o altri, passati con `--dart-define=NO_ADS_PRODUCT_ID=...`
   e `PREMIUM_SUB_PRODUCT_ID=...`).
4. **AdMob** — gli unit id veri stanno in `env.json` (`ADMOB_INTERSTITIAL_ID`,
   `ADMOB_REWARDED_ID`) e valgono solo in release: in debug/profile girano
   sempre gli id di test di Google. Una release senza id veri non parte
   (schermata "configurazione mancante").

---

## Stato di sviluppo

- [x] **Fase 1** — Fondazione: progetto, tema, Supabase, schema, auth anonima
- [x] **Fase 2** — Lobby realtime
- [x] **Fase 3** — Preferisci
- [x] **Fase 4** — Non ho mai
- [x] **Fase 5** — Chi lo potrebbe fare
- [x] **Fase 6** — Obbligo o Verità (bottiglia sincronizzata)
- [x] **Fase 7** — Bluff Story
- [x] **Fase 8** — Podio e punteggi
- [x] **Fase 9** — Acquisti in-app e abbonamenti (la generazione AI è stata rimossa)
- [x] **Fase 10** — AdMob (interstitial + rewarded)
- [x] **Fase 11** — Impostore
