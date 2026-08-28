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

  /// Prodotto in-app per sbloccare l'AI in una stanza.
  static const String premiumProductId = String.fromEnvironment(
    'PREMIUM_PRODUCT_ID',
    defaultValue: 'joyo_premium_ai_room',
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
  /// vale solo sul client, il server rifiuta comunque le generazioni AI non pagate.
  static const bool devUnlockPremium = bool.fromEnvironment(
    'DEV_UNLOCK_PREMIUM',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Elenco delle variabili mancanti, per il messaggio di errore in app.
  static List<String> get missingKeys => <String>[
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
  ];
}
