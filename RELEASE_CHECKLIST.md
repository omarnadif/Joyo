# Joyo — Checklist pre-rilascio

Legenda: ✅ fatto · ⬜ da fare · ⚠️ importante/bloccante

Stato app: `version 1.0.0+1` · Android `com.blueinhope.joyo` · cartella `ios/` presente.

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
- ⚠️⬜ **Content rating**: questionario IARC. Con i contenuti "Hot" espliciti la classificazione sarà alta (probabile 18+/Mature). Da compilare onestamente.
- ⬜ Target API level conforme al minimo richiesto da Google (usa `flutter.targetSdkVersion` aggiornato).
- ⬜ Pubblicare su **testing track** (internal → closed) prima della produzione.

## 3. Apple App Store (solo se pubblichi anche iOS)

- ⬜ Apple Developer Program (99$/anno).
- ⬜ App Store Connect: creare l'app + le **subscription** equivalenti (auto-renewable) `joyo_no_ads`, `joyo_premium`.
- ⬜ Verifica ricevuta iOS (App Store Server API) nella Edge Function, oltre a quella Google.
- ⚠️⬜ **App Tracking Transparency (ATT)**: prompt richiesto per usare l'IDFA con annunci personalizzati; aggiungere `NSUserTrackingUsageDescription` e la richiesta.
- ⬜ Pulsante "Ripristina acquisti" già presente ✅ (richiesto da Apple).

## 4. Pubblicità (AdMob)

- ✅ AdMob App ID reale nel `AndroidManifest.xml`.
- ✅ Unit id (interstitial `.../6211893933`, rewarded `.../7209175637`) noti; in dev restano gli id di test.
- ✅ **Unit id reali in release**: sono in `env.json` (gitignorato), quindi il solito
  `flutter build appbundle --dart-define-from-file=env.json` basta. Doppia rete:
  in debug/profile girano SEMPRE gli id di test (anche con env.json pieno), e una
  release senza id veri si blocca sulla schermata "configurazione mancante".
- ✅ **Consenso GDPR / UMP**: integrato in `ads_service_mobile.dart` (form mostrato prima di caricare gli annunci, gate su `canRequestAds`, riapertura da "opzioni privacy"). Va configurato anche il messaggio UMP nella console AdMob (Privacy e messaggi → GDPR) perché il form appaia davvero.
- ⬜ Collegare l'app AdMob alla scheda Play Store (dentro AdMob) per il fill pieno.
- ⬜ Pubblicare **app-ads.txt** sul dominio dello sviluppatore.
- ⬜ iOS `Info.plist`: `GADApplicationIdentifier` con l'App ID iOS (se pubblichi iOS) + SKAdNetwork ids.

## 5. Build & configurazione app

- ✅ **Firma di release** Android: keystore in `android/upload-keystore.jks` + password in `android/key.properties` (entrambi fuori da git — **vanno salvati in un backup esterno**). La build di release fallisce con errore chiaro se mancano.
- ⬜ Verificare che `DEV_UNLOCK_PREMIUM` **non** sia passato nelle build di release (di default è `false`, ok se non lo si passa).
- ⬜ Build con `--dart-define-from-file=env.json` (SUPABASE_URL/ANON_KEY) + gli unit id AdMob.
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
2. ⚠️ Prodotti su Play Console (§2) — altrimenti non si compra nulla.
3. ✅ Consenso UMP/GDPR per gli annunci (§4) — in app; resta la configurazione del messaggio in console AdMob.
4. ✅ Privacy policy (§6) — pubblicata e linkata in app; da incollare nelle console store.
5. ✅ Firma di release Android (§5) — fatta il 2026-08-29.
