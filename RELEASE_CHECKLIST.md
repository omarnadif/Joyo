# Joyo — Checklist pre-rilascio

Legenda: ✅ fatto · ⬜ da fare · ⚠️ importante/bloccante

Stato app: `version 1.0.0+1` · bundle id `com.blueinhope.joyo` su Android e iOS (rinominato da `com.mmih.joyo` il 2026-08-31, prima di ogni pubblicazione — non più cambiabile dopo).

> ⚠️ Nel working tree ci sono file non committati: `age_gate.dart` (nuovo) e `room_settings_card.dart` — l'age gate segnato ✅ in §6 esiste solo in locale finché non viene committato.

---

## 1. Backend & sicurezza monetizzazione

- ✅ Migrazioni DB applicate (0015–0019): shop, gate premium, entitlements, crediti per-utente.
- ✅ Gate server-side: `mode`/`rounds` scrivibili solo via RPC; Mix/Hot e round >10 protetti.
- ✅ Edge Function deployata e attiva: `verify-subscription` (le funzioni AI `unlock-premium` e `generate-content` sono state rimosse — da eliminare anche dal progetto Supabase se ancora deployate).
- ⚠️⬜ **Verifica ricevuta REALE**: `verify-subscription` ha `const verified = true` (stub). Con lo stub un client modificato può falsificare un abbonamento.
  - Creare un **service account Google** (Play Console → API access) con permesso su Android Publisher.
  - In `verify-subscription`: chiamare `purchases.subscriptionsv2.get` per confermare token+prodotto e leggere la scadenza vera (`expiryTimeMillis`) invece dei 30 giorni fissi.
  - Salvare la chiave come secret: `supabase secrets set GOOGLE_SERVICE_ACCOUNT=...`.
- ✅ **Rate limit sui crediti da annuncio** (migration 0020, applicata il 2026-08-29): `grant_mode_unlock` ora impone 15s minimi fra due annunci, max 30/giorno e max 10 partite in banca — il loop "crediti gratis" via RPC non conviene più. Upgrade futuro possibile: verifica SSV di AdMob (callback server-side firmata da Google) per la prova crittografica che l'annuncio sia stato visto.
- ⬜ Job/logica di **scadenza & rinnovo** abbonamenti (RTDN – Real-time Developer Notifications di Google) per aggiornare `entitlements.expires_at` a rinnovo/cancellazione. In alternativa il client riverifica al lancio.

## 2. Google Play Console

- ⬜ Account sviluppatore Google Play (25$ una tantum), se non già attivo.
- ⚠️⬜ Creare i prodotti **in-app subscriptions**:
  - `joyo_no_ads` — €1,99/mese
  - `joyo_premium` — €3,99/mese
- ⬜ Scheda store: titolo, descrizione breve/lunga (idealmente IT/EN/ES/FR/DE), icona, feature graphic, screenshot.
- ⬜ **Data safety form**: dichiarare i dati raccolti (Supabase: nome/colore/avatar; AdMob: identificatori pubblicità).
- ⚠️⬜ **Dichiarazione trader UE (DSA)**: obbligatoria perché l'app monetizza; indirizzo/email/telefono diventano pubblici sulla scheda. Senza, Google blocca la distribuzione in UE.
- ⬜ URL privacy policy nella scheda: https://omarnadif.github.io/joyo-legal/
- ⚠️⬜ **Content rating**: questionario IARC. Con i contenuti "Hot" espliciti la classificazione sarà alta (probabile 18+/Mature). Da compilare onestamente.
- ⬜ Target API level conforme al minimo richiesto da Google (usa `flutter.targetSdkVersion` aggiornato).
- ⬜ Pubblicare su **testing track** (internal → closed) prima della produzione.

## 3. Apple App Store

- ✅ Apple Developer Program attivo (2026-08-31, Apple ID gestion.blueinhope@gmail.com, Individual).
- ✅ Identifier `com.blueinhope.joyo` registrato + app "Joyo" creata su App Store Connect (SKU `joyo-001`).
- ✅ **Pipeline senza Mac**: Codemagic → TestFlight (`codemagic.yaml`; integrazione ASC `joyo-asc` con key ZC46MKLX66; variabili sicure `ENV_JSON` e `CERTIFICATE_PRIVATE_KEY` nel gruppo `joyo_env`).
- ✅ **Prima build verde** (2026-08-29, build #10): IPA firmato e caricato su App Store Connect (app id 6806622931), elaborazione completata.
- ⬜ **Test information su ASC**: l'invio automatico a TestFlight beta review fallisce finché mancano Feedback Email + contatto beta review → https://appstoreconnect.apple.com/apps/6806622931/testflight/test-info
- ✅ Export compliance: `ITSAppUsesNonExemptEncryption=false` in Info.plist (solo HTTPS standard).
- ⬜ Gruppo tester esterno con **link pubblico TestFlight** per l'iPhone (prima build esterna passa dalla beta review Apple, ~24-48h).
- ⬜ Creare le **subscription** auto-renewable `joyo_no_ads`, `joyo_premium` in ASC (+ accettare il Paid Applications Agreement in Accordi, tasse e banche — serve conto bancario).
- ⬜ Verifica ricevuta iOS (App Store Server API) nella Edge Function, oltre a quella Google.
- ✅ **ATT**: `NSUserTrackingUsageDescription` in Info.plist; il prompt lo gestisce il form UMP dove serve.
- ✅ Pulsante "Ripristina acquisti" presente (richiesto da Apple).
- ⬜ Scheda store: privacy labels, rating 17+, URL privacy policy, dichiarazione trader UE (DSA).

## 4. Pubblicità (AdMob)

- ✅ AdMob App ID reale nel `AndroidManifest.xml`.
- ✅ Unit id (interstitial `.../6211893933`, rewarded `.../7209175637`) noti; in dev restano gli id di test.
- ✅ **Unit id reali in release**: sono in `env.json` (gitignorato), quindi il solito
  `flutter build appbundle --dart-define-from-file=env.json` basta. Doppia rete:
  in debug/profile girano SEMPRE gli id di test (anche con env.json pieno), e una
  release senza id veri si blocca sulla schermata "configurazione mancante".
- ✅ **Consenso GDPR / UMP**: integrato in `ads_service_mobile.dart` (form mostrato prima di caricare gli annunci, gate su `canRequestAds`, riapertura da "opzioni privacy"). Va configurato anche il messaggio UMP nella console AdMob (Privacy e messaggi → GDPR) perché il form appaia davvero.
- ⬜ Collegare le app AdMob alle schede store pubblicate (dentro AdMob) per il fill pieno.
- ⬜ Pubblicare **app-ads.txt** sul dominio dello sviluppatore.
- ✅ iOS: app AdMob creata (App ID `~9659546328` nell'`Info.plist`) + 50 SKAdNetwork ids + unit id iOS (interstitial `/5071338127`, rewarded `/5608620670`) in `env.ios.json` (gitignorato, replicato nel secret `ENV_JSON` su Codemagic).

## 5. Build & configurazione app

- ✅ **Firma di release** Android: keystore in `android/upload-keystore.jks` + password in `android/key.properties` (entrambi fuori da git — **vanno salvati in un backup esterno**). La build di release fallisce con errore chiaro se mancano.
- ⬜ Verificare che `DEV_UNLOCK_PREMIUM` **non** sia passato nelle build di release (di default è `false`, ok se non lo si passa).
- ⬜ Build Android con `--dart-define-from-file=env.json`; iOS usa `env.ios.json` (via secret ENV_JSON su Codemagic) — i due file differiscono solo per gli unit id AdMob.
- ⬜ Bumpare `version` a ogni submit (`1.0.0+1` → `+2`…).
- ⬜ Icona app e splash definitivi.

## 6. Legale

- ✅ **Privacy policy** pubblica in 5 lingue: https://omarnadif.github.io/joyo-legal/ (repo `omarnadif/joyo-legal`), linkata in app nello shop. Da incollare nei campi privacy di Play Console / App Store Connect quando si crea la scheda.
- ⬜ Termini di servizio (consigliato).
- ✅ Verifica età: dialog 18+ alla prima selezione di Mix/Hot (`age_gate.dart`, conferma memorizzata per dispositivo), testi nelle 5 lingue.

## 7. Test finale (device reale)

- ⬜ Tester con licenza Play/App Store: comprare `joyo_no_ads` e `joyo_premium`.
- ⬜ Verificare: niente annunci con abbonamento, Mix/Hot e round >10 sbloccati con premium.
- ⬜ Verificare "3 video → 1 partita" (sblocco, consumo a start, ripetibile).
- ⬜ Verificare **Ripristina acquisti** dopo reinstallazione.
- ⬜ Verificare interstitial (fine partita + ogni 3 round) e rewarded.
- ⬜ Test multi-dispositivo/multi-lingua (1:1 dei contenuti, disclaimer Bluff con lingue miste).

---

### Bloccanti veri prima del "vai live"
1. ⚠️ Verifica ricevuta reale (§1) — altrimenti abbonamenti falsificabili.
2. ⚠️ Prodotti/subscription su Play Console **e** App Store Connect (§2, §3) — altrimenti non si compra nulla.
3. ⚠️ Dichiarazione trader UE su entrambe le console (§2, §3) — senza, niente distribuzione in Europa.
4. ⚠️ Messaggio UMP/GDPR da configurare nella console AdMob (Privacy e messaggi → GDPR) — il codice in app c'è, ma senza il messaggio pubblicato in console il form non appare e in EEA gli annunci restano spenti.
5. ✅ Consenso UMP/GDPR in app (§4).
6. ✅ Privacy policy (§6) — pubblicata e linkata in app; da incollare nelle console store.
7. ✅ Firma di release Android (§5) — fatta il 2026-08-29.

### Prossimi 3 passi concreti (aggiornato 2026-08-31)
1. Verificare l'esito della prima build Codemagic → TestFlight (email a gestion.blueinhope@gmail.com).
2. Committare age gate (`age_gate.dart` + `room_settings_card.dart`).
3. Configurare il messaggio GDPR nella console AdMob (Privacy e messaggi) per entrambe le app.
