import '../../../core/i18n/app_locale.dart';
import '../content_tone.dart';
import '../bluff_story/bluff_story_pool.dart';
import '../chi_lo_potrebbe_fare/chi_lo_potrebbe_fare_pool.dart';
import '../impostore/impostore_words.dart';
import '../non_ho_mai/non_ho_mai_pool.dart';
import '../obbligo_o_verita/obbligo_o_verita_pool.dart';
import '../preferisci/preferisci_pool.dart';
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

  // ---------------------------------------------------------------------------
  // Localizzazione del round nella lingua di CHI guarda, non di chi l'ha creato.
  //
  // L'host, creando il round, ci mette dentro l'indice del pool (`i`, e `i2`
  // per la verità di Obbligo o verità). Dove i pool sono tradotti 1:1 in pari
  // ordine, la stessa frase sta alla stessa posizione in tutte le lingue: ogni
  // telefono pesca la propria traduzione dallo stesso indice e un gruppo con
  // lingue diverse gioca sulla stessa frase, ognuno leggendola nella sua.
  //
  // ATTENZIONE: oggi solo il blocco `soft` (modalità Normale) è allineato 1:1
  // fra tutte le lingue. Le sezioni piccante/cattivo sono ancora banche di
  // domande scritte per lingua, con contenuti diversi allo stesso indice: lì
  // NON si può localizzare per indice, altrimenti il gruppo voterebbe frasi
  // diverse. Finché non sono riallineate, localizziamo solo le voci `soft` e
  // per il resto restiamo sul testo trasmesso dall'host (che tutti vedono
  // uguale). Impostore e Bluff Story hanno pool allineati e si localizzano
  // sempre. Il test `content_parity_test` presidia l'allineamento del soft.
  //
  // Fallback sul testo dell'host anche quando l'indice manca, è fuori pool o il
  // contenuto è generato dall'AI (`i == -1`).
  // ---------------------------------------------------------------------------

  static int? _poolIndex(Map<String, dynamic> content, [String key = 'i']) {
    final raw = (content[key] as num?)?.toInt();
    return (raw == null || raw < 0) ? null : raw;
  }

  // Gli indici `soft` coincidono in tutte le lingue (lo garantisce il test di
  // parità): se la voce locale a quell'indice è soft, è la traduzione 1:1
  // dell'italiano e si può mostrare; altrimenti siamo nella zona non allineata.
  static bool _softAligned(String tone) => tone == ContentTone.soft;

  static String nonHoMaiText(AppLocale locale, Map<String, dynamic> content) {
    final pool = nonHoMai(locale);
    final i = _poolIndex(content);
    return (i != null && i < pool.length && _softAligned(pool[i].tone))
        ? pool[i].text
        : content['text'] as String? ?? '—';
  }

  static String chiLoPotrebbeFareText(
    AppLocale locale,
    Map<String, dynamic> content,
  ) {
    final pool = chiLoPotrebbeFare(locale);
    final i = _poolIndex(content);
    return (i != null && i < pool.length && _softAligned(pool[i].tone))
        ? pool[i].text
        : content['text'] as String? ?? '—';
  }

  static String obbligoText(
    AppLocale locale,
    String tone,
    Map<String, dynamic> content,
  ) {
    final pool = obblighi(locale, tone);
    final i = _poolIndex(content);
    return (i != null && i < pool.length && _softAligned(tone))
        ? pool[i]
        : content['obbligo'] as String? ?? '—';
  }

  /// La verità usa `i2`, che è già sfalsato di [veritaOffset] rispetto
  /// all'indice reale del pool (serve all'host per non ripescare la stessa).
  static String veritaText(
    AppLocale locale,
    String tone,
    Map<String, dynamic> content,
    int veritaOffset,
  ) {
    final pool = verita(locale, tone);
    final raw = (content['i2'] as num?)?.toInt();
    final i = raw == null ? null : raw - veritaOffset;
    return (i != null && i >= 0 && i < pool.length && _softAligned(tone))
        ? pool[i]
        : content['verita'] as String? ?? '—';
  }

  static String impostoreWord(AppLocale locale, Map<String, dynamic> content) {
    final pool = impostoreWords(locale);
    final i = _poolIndex(content);
    return (i != null && i < pool.length)
        ? pool[i]
        : content['word'] as String? ?? '—';
  }

  static ({String a, String b}) preferisciPair(
    AppLocale locale,
    Map<String, dynamic> content,
  ) {
    final pool = PreferisciPool.entries(locale);
    final i = _poolIndex(content);
    if (i != null && i < pool.length && _softAligned(pool[i].tone)) {
      return (a: pool[i].a, b: pool[i].b);
    }
    return (a: content['a'] as String? ?? '—', b: content['b'] as String? ?? '—');
  }
}
