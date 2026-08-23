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
/// L'italiano è la lingua di partenza; le altre quattro hanno la parità
/// completa (stesse quantità per ogni gioco e tono, tradotte 1:1 dai pool
/// italiani). Ampliarle significa aggiungere righe a `content_xx.dart`,
/// senza toccare il resto dell'app.
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

  // Se a una lingua manca il mazzo di un tono si ripiega su quello italiano:
  // una domanda nella lingua sbagliata è meglio di un pool vuoto, che
  // manderebbe in errore la pesca dell'indice.
  static List<String> obblighi(AppLocale locale, String tone) =>
      switch (locale) {
        AppLocale.it => ObbligoOVeritaPool.obblighi(tone),
        AppLocale.en => ContentEn.obblighi[tone],
        AppLocale.es => ContentEs.obblighi[tone],
        AppLocale.fr => ContentFr.obblighi[tone],
        AppLocale.de => ContentDe.obblighi[tone],
      } ??
      ObbligoOVeritaPool.obblighi(tone);

  static List<String> verita(AppLocale locale, String tone) =>
      switch (locale) {
        AppLocale.it => ObbligoOVeritaPool.verita(tone),
        AppLocale.en => ContentEn.verita[tone],
        AppLocale.es => ContentEs.verita[tone],
        AppLocale.fr => ContentFr.verita[tone],
        AppLocale.de => ContentDe.verita[tone],
      } ??
      ObbligoOVeritaPool.verita(tone);

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
