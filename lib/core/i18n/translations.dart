import 'package:joyo/content/content_de.dart';
import 'package:joyo/content/content_en.dart';
import 'package:joyo/content/content_es.dart';
import 'package:joyo/content/content_fr.dart';
import 'package:joyo/content/content_it.dart';
import 'app_locale.dart';

/// I testi di interfaccia vivono, come i contenuti dei giochi, dentro il file
/// della loro lingua (`content_xx.dart`, mappa `ui`). Qui si sceglie solo la
/// lingua giusta: il resto dell'app non conosce la struttura dei dati, parla
/// solo con `AppTexts`.
class AppTexts {
  const AppTexts._();

  static Map<String, String> of(AppLocale locale) => switch (locale) {
    AppLocale.it => ContentIt.ui,
    AppLocale.en => ContentEn.ui,
    AppLocale.es => ContentEs.ui,
    AppLocale.fr => ContentFr.ui,
    AppLocale.de => ContentDe.ui,
  };

  /// Ripiego comune quando una chiave manca nella lingua scelta.
  static Map<String, String> get fallback => ContentEn.ui;
}
