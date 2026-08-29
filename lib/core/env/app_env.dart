import 'package:flutter/foundation.dart';

/// Configurazione da compile time: le chiavi si passano con
/// `--dart-define-from-file=env.json` (vedi `env.example.json`), mai nel codice.
class AppEnv {
  const AppEnv._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// Id AdMob. Se restano vuoti si usano gli id di test di Google.
  static const String admobInterstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
  );
  static const String admobRewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
  );

  /// Abbonamento mensile "niente pubblicità".
  static const String noAdsProductId = String.fromEnvironment(
    'NO_ADS_PRODUCT_ID',
    defaultValue: 'joyo_no_ads',
  );

  /// Abbonamento mensile "premium completo": modalità, round e niente pubblicità.
  static const String premiumSubProductId = String.fromEnvironment(
    'PREMIUM_SUB_PRODUCT_ID',
    defaultValue: 'joyo_premium',
  );

  /// Sblocca le schermate premium in sviluppo (`--dart-define=DEV_UNLOCK_PREMIUM=true`);
  /// vale solo sul client, i gate lato server restano attivi.
  static const bool devUnlockPremium = bool.fromEnvironment(
    'DEV_UNLOCK_PREMIUM',
  );

  /// In release su telefono gli unit id AdMob veri sono obbligatori: senza,
  /// l'app girerebbe in silenzio con gli annunci di test di Google (zero
  /// ricavi). Meglio la schermata "configurazione mancante" al primo avvio.
  static bool get _adIdsRequired =>
      kReleaseMode &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      (!_adIdsRequired ||
          (admobInterstitialId.isNotEmpty && admobRewardedId.isNotEmpty));

  /// Elenco delle variabili mancanti, per il messaggio di errore in app.
  static List<String> get missingKeys => <String>[
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
    if (_adIdsRequired && admobInterstitialId.isEmpty) 'ADMOB_INTERSTITIAL_ID',
    if (_adIdsRequired && admobRewardedId.isEmpty) 'ADMOB_REWARDED_ID',
  ];
}
