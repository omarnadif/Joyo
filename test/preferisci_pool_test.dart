import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/content/content_de.dart';
import 'package:joyo/content/content_en.dart';
import 'package:joyo/content/content_es.dart';
import 'package:joyo/content/content_fr.dart';
import 'package:joyo/content/ita/content_it_preferisci.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/content/content_tone.dart';

List<({String a, String b})> _pairs(AppLocale locale) => switch (locale) {
  AppLocale.it => ContentItPreferisci.preferisciPairs,
  AppLocale.en => ContentEn.preferisciPairs,
  AppLocale.es => ContentEs.preferisciPairs,
  AppLocale.fr => ContentFr.preferisciPairs,
  AppLocale.de => ContentDe.preferisciPairs,
};

void main() {
  test('ogni lingua ha abbastanza coppie per una serata', () {
    // L'italiano è la lingua di riferimento e ha il pool più ampio; le altre
    // devono comunque bastare a coprire una partita lunga senza ripetersi.
    final minimums = {
      AppLocale.it: 100,
      AppLocale.en: 40,
      AppLocale.es: 40,
      AppLocale.fr: 40,
      AppLocale.de: 40,
    };

    for (final entry in minimums.entries) {
      expect(
        _pairs(entry.key).length,
        greaterThanOrEqualTo(entry.value),
        reason: entry.key.label,
      );
    }
  });

  for (final locale in AppLocale.values) {
    test('${locale.label}: nessuna coppia duplicata o incoerente', () {
      // `preferisciEntries` include anche il mazzo Hot: i vincoli valgono per tutti.
      final pairs = GameContent.preferisciEntries(locale);
      final keys = pairs.map((p) => '${p.a}|${p.b}').toList();
      expect(keys.toSet().length, keys.length, reason: 'coppie duplicate');

      for (final pair in pairs) {
        expect(pair.a.trim(), isNotEmpty);
        expect(pair.b.trim(), isNotEmpty);
        expect(pair.a, isNot(pair.b));
        // Nessun limite di lunghezza: le card mandano il testo a capo, non lo
        // troncano, quindi un tetto costringerebbe solo ad accorciare le frasi.
      }
    });
  }

  test('il mazzo Hot italiano esiste e ha solo toni mix/hot', () {
    expect(ContentItPreferisci.preferisciHot.length, greaterThanOrEqualTo(20));
    for (final pair in ContentItPreferisci.preferisciHot) {
      expect(
        pair.tone == ContentTone.mix || pair.tone == ContentTone.hot,
        isTrue,
        reason: '${pair.a} | ${pair.b}',
      );
    }
  });
}
