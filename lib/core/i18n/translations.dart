import 'package:joyo/content/de/content_de_app.dart';
import 'package:joyo/content/en/content_en_app.dart';
import 'package:joyo/content/es/content_es_app.dart';
import 'package:joyo/content/fr/content_fr_app.dart';
import 'package:joyo/content/ita/content_it_app.dart';
import 'app_locale.dart';

/// I testi di interfaccia vivono, come i contenuti dei giochi, dentro il file
/// della loro lingua (mappa `ui`): per l'italiano è `content_it_app.dart`,
/// per le altre lingue `content_xx.dart`. Qui si sceglie solo la lingua
/// giusta: il resto dell'app non conosce la struttura dei dati, parla solo
/// con `AppTexts`.
class AppTexts {
  const AppTexts._();

  static Map<String, String> of(AppLocale locale) => switch (locale) {
    AppLocale.it => ContentItApp.ui,
    AppLocale.en => ContentEnApp.ui,
    AppLocale.es => ContentEsApp.ui,
    AppLocale.fr => ContentFrApp.ui,
    AppLocale.de => ContentDeApp.ui,
  };

  /// Ripiego comune quando una chiave manca nella lingua scelta.
  static Map<String, String> get fallback => ContentEnApp.ui;
}
