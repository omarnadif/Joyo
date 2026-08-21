/// Configurazione letta a compile time.
///
/// Le chiavi non stanno mai nel codice: si passano con
/// `flutter run --dart-define-from-file=env.json` (vedi `env.example.json`).
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

  /// Sblocca il premium senza acquisto, per provare l'app durante lo sviluppo.
  ///
  /// Si attiva solo con `--dart-define=DEV_UNLOCK_PREMIUM=true`: è spento in
  /// qualsiasi build che non lo chieda esplicitamente.
  ///
  /// Vale solo qui sul telefono: il server continua a rifiutare le generazioni
  /// AI a chi non ha pagato, ed è giusto così — è l'unica cosa che protegge la
  /// funzione a pagamento. Con questo interruttore si vedono le schermate
  /// premium e i giochi provano davvero a chiamare l'AI; se la Edge Function
  /// non è pubblicata o rifiuta, si torna ai pool fissi senza errori.
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
