import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/content_tone.dart';
import 'package:joyo/features/games/preferisci/preferisci_pool.dart';

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
        PreferisciPool.pairs(entry.key).length,
        greaterThanOrEqualTo(entry.value),
        reason: entry.key.label,
      );
    }
  });

  for (final locale in AppLocale.values) {
    test('${locale.label}: nessuna coppia duplicata o incoerente', () {
      // `entries` include anche il mazzo Hot: i vincoli valgono per tutti.
      final pairs = PreferisciPool.entries(locale);
      final keys = pairs.map((p) => '${p.a}|${p.b}').toList();
      expect(keys.toSet().length, keys.length, reason: 'coppie duplicate');

      for (final pair in pairs) {
        expect(pair.a.trim(), isNotEmpty);
        expect(pair.b.trim(), isNotEmpty);
        expect(pair.a, isNot(pair.b));
        expect(pair.a.length, lessThanOrEqualTo(46), reason: pair.a);
        expect(pair.b.length, lessThanOrEqualTo(46), reason: pair.b);
      }
    });
  }

  test('il mazzo Hot italiano esiste e ha solo toni piccante/cattivo', () {
    expect(PreferisciPool.hotIt.length, greaterThanOrEqualTo(20));
    for (final pair in PreferisciPool.hotIt) {
      expect(
        pair.tone == ContentTone.piccante || pair.tone == ContentTone.cattivo,
        isTrue,
        reason: '${pair.a} | ${pair.b}',
      );
    }
  });
}
