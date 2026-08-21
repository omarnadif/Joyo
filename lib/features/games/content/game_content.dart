import '../../../core/i18n/app_locale.dart';
import '../bluff_story/bluff_story_pool.dart';
import '../chi_lo_potrebbe_fare/chi_lo_potrebbe_fare_pool.dart';
import '../impostore/impostore_words.dart';
import '../non_ho_mai/non_ho_mai_pool.dart';
import '../obbligo_o_verita/obbligo_o_verita_pool.dart';
import 'content_de.dart';
import 'content_en.dart';
import 'content_es.dart';
import 'content_fr.dart';

/// Punto unico da cui i giochi prendono i contenuti nella lingua del gruppo.
///
/// L'italiano è la lingua di partenza e ha i pool più ampi; le altre quattro
/// hanno un mazzo più corto ma completo per tutti i giochi e tutti i toni.
/// Ampliarle significa aggiungere righe a `content_xx.dart`, senza toccare il
/// resto dell'app.
class GameContent {
  const GameContent._();

  static List<({String text, String tone})> nonHoMai(AppLocale locale) =>
      switch (locale) {
        AppLocale.it => NonHoMaiPool.entries,
        AppLocale.en => ContentEn.nonHoMai,
        AppLocale.es => ContentEs.nonHoMai,
        AppLocale.fr => ContentFr.nonHoMai,
        AppLocale.de => ContentDe.nonHoMai,
      };

  static List<({String text, String tone})> chiLoPotrebbeFare(
    AppLocale locale,
  ) => switch (locale) {
    AppLocale.it => ChiLoPotrebbeFarePool.entries,
    AppLocale.en => ContentEn.chiLoPotrebbeFare,
    AppLocale.es => ContentEs.chiLoPotrebbeFare,
    AppLocale.fr => ContentFr.chiLoPotrebbeFare,
    AppLocale.de => ContentDe.chiLoPotrebbeFare,
  };

  static List<String> obblighi(AppLocale locale, String tone) =>
      switch (locale) {
        AppLocale.it => ObbligoOVeritaPool.obblighi(tone),
        AppLocale.en => ContentEn.obblighi[tone] ?? const [],
        AppLocale.es => ContentEs.obblighi[tone] ?? const [],
        AppLocale.fr => ContentFr.obblighi[tone] ?? const [],
        AppLocale.de => ContentDe.obblighi[tone] ?? const [],
      };

  static List<String> verita(AppLocale locale, String tone) => switch (locale) {
    AppLocale.it => ObbligoOVeritaPool.verita(tone),
    AppLocale.en => ContentEn.verita[tone] ?? const [],
    AppLocale.es => ContentEs.verita[tone] ?? const [],
    AppLocale.fr => ContentFr.verita[tone] ?? const [],
    AppLocale.de => ContentDe.verita[tone] ?? const [],
  };

  static List<String> bluffFakes(AppLocale locale) => switch (locale) {
    AppLocale.it => BluffStoryPool.fakes,
    AppLocale.en => ContentEn.bluffFakes,
    AppLocale.es => ContentEs.bluffFakes,
    AppLocale.fr => ContentFr.bluffFakes,
    AppLocale.de => ContentDe.bluffFakes,
  };

  static List<String> impostoreWords(AppLocale locale) => switch (locale) {
    AppLocale.it => ImpostoreWords.words,
    AppLocale.en => ContentEn.impostoreWords,
    AppLocale.es => ContentEs.impostoreWords,
    AppLocale.fr => ContentFr.impostoreWords,
    AppLocale.de => ContentDe.impostoreWords,
  };
}
