# Joyo — Checklist pre-rilascio

Legenda: ✅ fatto · ⬜ da fare · ⚠️ importante/bloccante

Stato app: `version 1.0.0+1` · Android `com.mmih.joyo` · cartella `ios/` presente.

---

## 1. Backend & sicurezza monetizzazione

- ✅ Migrazioni DB applicate (0015–0019): shop, gate premium, entitlements, crediti per-utente.
- ✅ Gate server-side: `mode`/`rounds` scrivibili solo via RPC; Mix/Hot e round >10 protetti.
- ✅ Edge Function deployate e attive: `verify-subscription`, `unlock-premium`, `generate-content`.
- ⚠️⬜ **Verifica ricevuta REALE**: sia `verify-subscription` che `unlock-premium` hanno `const verified = true` (stub). Con lo stub un client modificato può falsificare un abbonamento.
  - Creare un **service account Google** (Play Console → API access) con permesso su Android Publisher.
  - In `verify-subscription`: chiamare `purchases.subscriptionsv2.get` per confermare token+prodotto e leggere la scadenza vera (`expiryTimeMillis`) invece dei 30 giorni fissi.
  - Salvare la chiave come secret: `supabase secrets set GOOGLE_SERVICE_ACCOUNT=...`.
- ⬜ Job/logica di **scadenza & rinnovo** abbonamenti (RTDN – Real-time Developer Notifications di Google) per aggiornare `entitlements.expires_at` a rinnovo/cancellazione. In alternativa il client riverifica al lancio.

## 2. Google Play Console

- ⬜ Account sviluppatore Google Play (25$ una tantum), se non già attivo.
- ⚠️⬜ Creare i prodotti **in-app subscriptions**:
  - `joyo_no_ads` — €1,99/mese
  - `joyo_premium` — €3,99/mese
  - (opzionale `joyo_premium_ai_room` se si riattiva l'AI)
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
- ⚠️⬜ **In release** passare gli unit id reali:
  ```
  flutter build appbundle \
    --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-2109864769102110/6211893933 \
    --dart-define=ADMOB_REWARDED_ID=ca-app-pub-2109864769102110/7209175637
  ```
- ⚠️⬜ **Consenso GDPR / UMP** (obbligatorio in UE, e il mercato è IT/FR/ES/DE): integrare Google **User Messaging Platform** (`ConsentInformation`/`ConsentForm` di `google_mobile_ads`) e mostrare il form prima di caricare gli annunci. **Ora manca del tutto.**
- ⬜ Collegare l'app AdMob alla scheda Play Store (dentro AdMob) per il fill pieno.
- ⬜ Pubblicare **app-ads.txt** sul dominio dello sviluppatore.
- ⬜ iOS `Info.plist`: `GADApplicationIdentifier` con l'App ID iOS (se pubblichi iOS) + SKAdNetwork ids.

## 5. Build & configurazione app

- ⚠️⬜ **Firma di release** Android: keystore + `signingConfig` (ora la release usa probabilmente la firma di debug).
- ⬜ Verificare che `DEV_UNLOCK_PREMIUM` **non** sia passato nelle build di release (di default è `false`, ok se non lo si passa).
- ⬜ Build con `--dart-define-from-file=env.json` (SUPABASE_URL/ANON_KEY) + gli unit id AdMob.
- ⬜ Bumpare `version` a ogni submit (`1.0.0+1` → `+2`…).
- ⬜ Icona app e splash definitivi.

## 6. Legale

- ⚠️⬜ **Privacy policy** pubblica (URL): obbligatoria con IAP + annunci + dati utente. Da linkare nello store e (consigliato) in app.
- ⬜ Termini di servizio (consigliato).
- ⬜ Verifica età / disclaimer contenuti adulti (modalità Hot).

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
3. ⚠️ Consenso UMP/GDPR per gli annunci (§4) — obbligatorio in UE.
4. ⚠️ Privacy policy (§6) — richiesta da Google/Apple.
5. ⚠️ Firma di release Android (§5).
