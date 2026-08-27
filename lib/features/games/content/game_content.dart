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

/// Contenuti dei giochi nella lingua del gruppo.
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

  // Se il tono manca nella lingua, ripiega sull'italiano invece di un pool vuoto.
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

  static List<({String a, String b, String tone})> preferisciEntries(
    AppLocale locale,
  ) {
    final p = _preferisci(locale);
    return [
      for (final c in p.pairs) (a: c.a, b: c.b, tone: ContentTone.normal),
      ...p.hot,
    ];
  }

  // Indice del pool salvato dall'host; null se assente o generato dall'AI (< 0).
  static int? _poolIndex(Map<String, dynamic> content, [String key = 'i']) {
    final raw = (content[key] as num?)?.toInt();
    return (raw == null || raw < 0) ? null : raw;
  }

  // Solo il pool `normal` è allineato 1:1 tra le lingue: mix/hot NON si
  // localizzano per indice, o il gruppo voterebbe frasi diverse.
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

  // La verità usa `i2`, sfalsato di [veritaOffset] rispetto all'indice del pool.
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
