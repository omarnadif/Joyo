import 'package:joyo/content/content_de.dart';
import 'package:joyo/content/content_en.dart';
import 'package:joyo/content/content_es.dart';
import 'package:joyo/content/content_fr.dart';
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
    AppLocale.en => ContentEn.ui,
    AppLocale.es => ContentEs.ui,
    AppLocale.fr => ContentFr.ui,
    AppLocale.de => ContentDe.ui,
  };

  /// Ripiego comune quando una chiave manca nella lingua scelta.
  static Map<String, String> get fallback => ContentEn.ui;
}
