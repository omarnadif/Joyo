import '../../../core/i18n/app_locale.dart';
import 'package:joyo/content/content_tone.dart';

import 'package:joyo/content/ita/content_it_bluff.dart';
import 'package:joyo/content/ita/content_it_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/ita/content_it_impostore.dart';
import 'package:joyo/content/ita/content_it_non_ho_mai.dart';
import 'package:joyo/content/ita/content_it_obbligo_o_verita.dart';
import 'package:joyo/content/ita/content_it_preferisci.dart';

import 'package:joyo/content/en/content_en_bluff.dart';
import 'package:joyo/content/en/content_en_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/en/content_en_impostore.dart';
import 'package:joyo/content/en/content_en_non_ho_mai.dart';
import 'package:joyo/content/en/content_en_obbligo_o_verita.dart';
import 'package:joyo/content/en/content_en_preferisci.dart';

import 'package:joyo/content/es/content_es_bluff.dart';
import 'package:joyo/content/es/content_es_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/es/content_es_impostore.dart';
import 'package:joyo/content/es/content_es_non_ho_mai.dart';
import 'package:joyo/content/es/content_es_obbligo_o_verita.dart';
import 'package:joyo/content/es/content_es_preferisci.dart';

import 'package:joyo/content/fr/content_fr_bluff.dart';
import 'package:joyo/content/fr/content_fr_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/fr/content_fr_impostore.dart';
import 'package:joyo/content/fr/content_fr_non_ho_mai.dart';
import 'package:joyo/content/fr/content_fr_obbligo_o_verita.dart';
import 'package:joyo/content/fr/content_fr_preferisci.dart';

import 'package:joyo/content/de/content_de_bluff.dart';
import 'package:joyo/content/de/content_de_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/de/content_de_impostore.dart';
import 'package:joyo/content/de/content_de_non_ho_mai.dart';
import 'package:joyo/content/de/content_de_obbligo_o_verita.dart';
import 'package:joyo/content/de/content_de_preferisci.dart';

/// Punto unico da cui i giochi prendono i contenuti nella lingua del gruppo.
///
/// Ogni lingua vive, come l'italiano, in file divisi per gioco dentro
/// `content/<lingua>/` (`content_en_non_ho_mai.dart`, `content_fr_preferisci.dart`,
/// ecc.), con una classe per gioco. I pool sono tradotti 1:1 dai pool italiani,
/// nello stesso ordine e con lo stesso tono a ogni indice: ampliarli significa
/// aggiungere righe al file del gioco corrispondente, senza toccare il resto
/// dell'app.
class GameContent {
  const GameContent._();

  static List<({String text, String tone})> nonHoMai(AppLocale locale) =>
      switch (locale) {
        AppLocale.it => ContentItNonHoMai.nonHoMai,
        AppLocale.en => ContentEnNonHoMai.nonHoMai,
        AppLocale.es => ContentEsNonHoMai.nonHoMai,
        AppLocale.fr => ContentFrNonHoMai.nonHoMai,
        AppLocale.de => ContentDeNonHoMai.nonHoMai,
      };

  static List<({String text, String tone})> chiLoPotrebbeFare(
    AppLocale locale,
  ) => switch (locale) {
    AppLocale.it => ContentItChiLoPotrebbeFare.chiLoPotrebbeFare,
    AppLocale.en => ContentEnChiLoPotrebbeFare.chiLoPotrebbeFare,
    AppLocale.es => ContentEsChiLoPotrebbeFare.chiLoPotrebbeFare,
    AppLocale.fr => ContentFrChiLoPotrebbeFare.chiLoPotrebbeFare,
    AppLocale.de => ContentDeChiLoPotrebbeFare.chiLoPotrebbeFare,
  };

  // Se a una lingua manca il mazzo di un tono si ripiega su quello italiano:
  // una domanda nella lingua sbagliata è meglio di un pool vuoto, che
  // manderebbe in errore la pesca dell'indice.
  static List<String> obblighi(AppLocale locale, String tone) =>
      switch (locale) {
        AppLocale.it => ContentItObbligoOVerita.obblighi[tone],
        AppLocale.en => ContentEnObbligoOVerita.obblighi[tone],
        AppLocale.es => ContentEsObbligoOVerita.obblighi[tone],
        AppLocale.fr => ContentFrObbligoOVerita.obblighi[tone],
        AppLocale.de => ContentDeObbligoOVerita.obblighi[tone],
      } ??
      ContentItObbligoOVerita.obblighi[tone] ??
      const <String>[];

  static List<String> verita(AppLocale locale, String tone) =>
      switch (locale) {
        AppLocale.it => ContentItObbligoOVerita.verita[tone],
        AppLocale.en => ContentEnObbligoOVerita.verita[tone],
        AppLocale.es => ContentEsObbligoOVerita.verita[tone],
        AppLocale.fr => ContentFrObbligoOVerita.verita[tone],
        AppLocale.de => ContentDeObbligoOVerita.verita[tone],
      } ??
      ContentItObbligoOVerita.verita[tone] ??
      const <String>[];

  static List<String> bluffFakes(AppLocale locale) => switch (locale) {
    AppLocale.it => ContentItBluff.bluffFakes,
    AppLocale.en => ContentEnBluff.bluffFakes,
    AppLocale.es => ContentEsBluff.bluffFakes,
    AppLocale.fr => ContentFrBluff.bluffFakes,
    AppLocale.de => ContentDeBluff.bluffFakes,
  };

  static List<String> impostoreWords(AppLocale locale) => switch (locale) {
    AppLocale.it => ContentItImpostore.impostoreWords,
    AppLocale.en => ContentEnImpostore.impostoreWords,
    AppLocale.es => ContentEsImpostore.impostoreWords,
    AppLocale.fr => ContentFrImpostore.impostoreWords,
    AppLocale.de => ContentDeImpostore.impostoreWords,
  };

  static ({
    List<({String a, String b})> pairs,
    List<({String a, String b, String tone})> hot,
  })
  _preferisci(AppLocale locale) => switch (locale) {
    AppLocale.it => (
      pairs: ContentItPreferisci.preferisciPairs,
      hot: ContentItPreferisci.preferisciHot,
    ),
    AppLocale.en => (
      pairs: ContentEnPreferisci.preferisciPairs,
      hot: ContentEnPreferisci.preferisciHot,
    ),
    AppLocale.es => (
      pairs: ContentEsPreferisci.preferisciPairs,
      hot: ContentEsPreferisci.preferisciHot,
    ),
    AppLocale.fr => (
      pairs: ContentFrPreferisci.preferisciPairs,
      hot: ContentFrPreferisci.preferisciHot,
    ),
    AppLocale.de => (
      pairs: ContentDePreferisci.preferisciPairs,
      hot: ContentDePreferisci.preferisciHot,
    ),
  };

  /// Coppie di "Preferisci" nella lingua del gruppo, col tono per il filtro
  /// della modalità: il mazzo base è tutto normal, in Mix/Hot entrano le audaci.
  static List<({String a, String b, String tone})> preferisciEntries(
    AppLocale locale,
  ) {
    final p = _preferisci(locale);
    return [
      for (final c in p.pairs) (a: c.a, b: c.b, tone: ContentTone.normal),
      ...p.hot,
    ];
  }

  // ---------------------------------------------------------------------------
  // Localizzazione del round nella lingua di CHI guarda, non di chi l'ha creato.
  //
  // L'host, creando il round, ci mette dentro l'indice del pool (`i`, e `i2`
  // per la verità di Obbligo o verità). Dove i pool sono tradotti 1:1 in pari
  // ordine, la stessa frase sta alla stessa posizione in tutte le lingue: ogni
  // telefono pesca la propria traduzione dallo stesso indice e un gruppo con
  // lingue diverse gioca sulla stessa frase, ognuno leggendola nella sua.
  //
  // ATTENZIONE: oggi solo il blocco `normal` (modalità Normale) è allineato 1:1
  // fra tutte le lingue. Le sezioni mix/hot sono ancora banche di
  // domande scritte per lingua, con contenuti diversi allo stesso indice: lì
  // NON si può localizzare per indice, altrimenti il gruppo voterebbe frasi
  // diverse. Finché non sono riallineate, localizziamo solo le voci `normal` e
  // per il resto restiamo sul testo trasmesso dall'host (che tutti vedono
  // uguale). Impostore e Bluff Story hanno pool allineati e si localizzano
  // sempre. Il test `content_parity_test` presidia l'allineamento del normal.
  //
  // Fallback sul testo dell'host anche quando l'indice manca, è fuori pool o il
  // contenuto è generato dall'AI (`i == -1`).
  // ---------------------------------------------------------------------------

  static int? _poolIndex(Map<String, dynamic> content, [String key = 'i']) {
    final raw = (content[key] as num?)?.toInt();
    return (raw == null || raw < 0) ? null : raw;
  }

  // Gli indici `normal` coincidono in tutte le lingue (lo garantisce il test di
  // parità): se la voce locale a quell'indice è normal, è la traduzione 1:1
  // dell'italiano e si può mostrare; altrimenti siamo nella zona non allineata.
  static bool _normalAligned(String tone) => tone == ContentTone.normal;

  static String nonHoMaiText(AppLocale locale, Map<String, dynamic> content) {
    final pool = nonHoMai(locale);
    final i = _poolIndex(content);
    return (i != null && i < pool.length && _normalAligned(pool[i].tone))
        ? pool[i].text
        : content['text'] as String? ?? '—';
  }

  static String chiLoPotrebbeFareText(
    AppLocale locale,
    Map<String, dynamic> content,
  ) {
    final pool = chiLoPotrebbeFare(locale);
    final i = _poolIndex(content);
    return (i != null && i < pool.length && _normalAligned(pool[i].tone))
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
    return (i != null && i < pool.length && _normalAligned(tone))
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
    return (i != null && i >= 0 && i < pool.length && _normalAligned(tone))
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
    final pool = preferisciEntries(locale);
    final i = _poolIndex(content);
    if (i != null && i < pool.length && _normalAligned(pool[i].tone)) {
      return (a: pool[i].a, b: pool[i].b);
    }
    return (
      a: content['a'] as String? ?? '—',
      b: content['b'] as String? ?? '—',
    );
  }
}
