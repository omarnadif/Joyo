import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/content/de/content_de_preferisci.dart';
import 'package:joyo/content/en/content_en_preferisci.dart';
import 'package:joyo/content/es/content_es_preferisci.dart';
import 'package:joyo/content/fr/content_fr_preferisci.dart';
import 'package:joyo/content/ita/content_it_preferisci.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/content/content_tone.dart';

List<({String a, String b})> _preferisciPairs(AppLocale locale) =>
    switch (locale) {
      AppLocale.it => ContentItPreferisci.preferisciPairs,
      AppLocale.en => ContentEnPreferisci.preferisciPairs,
      AppLocale.es => ContentEsPreferisci.preferisciPairs,
      AppLocale.fr => ContentFrPreferisci.preferisciPairs,
      AppLocale.de => ContentDePreferisci.preferisciPairs,
    };

/// L'italiano è la lingua di riferimento: le altre quattro devono avere le
/// stesse quantità, gioco per gioco e tono per tono. Il confronto è dinamico
/// (contro l'italiano, non contro numeri fissi) così una lingua non può
/// restare indietro senza che il test se ne accorga, e i numeri non diventano
/// mai "stale" quando i pool crescono.
void main() {
  int perTone(List<({String text, String tone})> pool, String tone) =>
      pool.where((e) => e.tone == tone).length;

  const ref = AppLocale.it;

  for (final locale in AppLocale.values) {
    if (locale == ref) continue;

    test('${locale.label}: stesse quantità dell\'italiano', () {
      final nonHoMai = GameContent.nonHoMai(locale);
      expect(
        nonHoMai.length,
        GameContent.nonHoMai(ref).length,
        reason: 'Non ho mai',
      );
      for (final tone in ContentTone.all) {
        expect(
          perTone(nonHoMai, tone),
          perTone(GameContent.nonHoMai(ref), tone),
          reason: 'Non ho mai $tone',
        );
      }

      final chiLo = GameContent.chiLoPotrebbeFare(locale);
      expect(
        chiLo.length,
        GameContent.chiLoPotrebbeFare(ref).length,
        reason: 'Chi lo potrebbe fare',
      );
      for (final tone in ContentTone.all) {
        expect(
          perTone(chiLo, tone),
          perTone(GameContent.chiLoPotrebbeFare(ref), tone),
          reason: 'Chi lo potrebbe fare $tone',
        );
      }

      expect(
        GameContent.preferisciEntries(locale).length,
        GameContent.preferisciEntries(ref).length,
        reason: 'Preferisci',
      );
      expect(
        _preferisciPairs(locale).length,
        _preferisciPairs(ref).length,
        reason: 'Preferisci coppie',
      );

      for (final tone in ContentTone.all) {
        expect(
          GameContent.obblighi(locale, tone).length,
          GameContent.obblighi(ref, tone).length,
          reason: 'obblighi $tone',
        );
        expect(
          GameContent.verita(locale, tone).length,
          GameContent.verita(ref, tone).length,
          reason: 'verità $tone',
        );
      }

      expect(
        GameContent.bluffFakes(locale).length,
        GameContent.bluffFakes(ref).length,
        reason: 'Bluff Story',
      );
      expect(
        GameContent.impostoreWords(locale).length,
        GameContent.impostoreWords(ref).length,
        reason: 'Impostore',
      );
    });
  }

  // Allineamento posizionale: il cross-lingua nelle stanze si regge su questo.
  // L'host trasmette solo l'indice della frase; ogni telefono pesca la propria
  // traduzione allo stesso indice. Perché l'indice punti alla stessa frase in
  // ogni lingua, i pool tradotti devono avere lo stesso ORDINE, non solo le
  // stesse quantità.
  //
  // Stato attuale: il blocco `normal` è allineato ovunque; le sezioni mix e hot
  // di alcune lingue sono ancora contenuti autonomi (non traduzioni 1:1 in pari
  // ordine). Finché non sono riallineate, la localizzazione per indice è sicura
  // solo sul normal: qui verifichiamo quella garanzia, così un futuro
  // disallineamento del normal non passa inosservato.
  List<int> normalIndexes(List<({String text, String tone})> pool) =>
      [for (var i = 0; i < pool.length; i++) if (pool[i].tone == ContentTone.normal) i];
  List<int> preferisciNormalIndexes(AppLocale locale) {
    final entries = GameContent.preferisciEntries(locale);
    return [
      for (var i = 0; i < entries.length; i++)
        if (entries[i].tone == ContentTone.normal) i,
    ];
  }

  for (final locale in AppLocale.values) {
    if (locale == ref) continue;
    test('${locale.label}: blocco normal allineato all\'italiano', () {
      expect(
        normalIndexes(GameContent.nonHoMai(locale)),
        normalIndexes(GameContent.nonHoMai(ref)),
        reason: 'Non ho mai: normal disallineato',
      );
      expect(
        normalIndexes(GameContent.chiLoPotrebbeFare(locale)),
        normalIndexes(GameContent.chiLoPotrebbeFare(ref)),
        reason: 'Chi lo potrebbe fare: normal disallineato',
      );
      expect(
        preferisciNormalIndexes(locale),
        preferisciNormalIndexes(ref),
        reason: 'Preferisci: normal disallineato',
      );
    });
  }

  // Soglia minima: nessun tono deve restare mezzo vuoto, in nessuna lingua.
  test('ogni tono ha un pool pieno', () {
    for (final locale in AppLocale.values) {
      for (final tone in ContentTone.all) {
        expect(
          GameContent.obblighi(locale, tone).length,
          greaterThanOrEqualTo(150),
          reason: 'obblighi $tone ${locale.code}',
        );
        expect(
          GameContent.verita(locale, tone).length,
          greaterThanOrEqualTo(150),
          reason: 'verità $tone ${locale.code}',
        );
      }
    }
  });

  for (final locale in AppLocale.values) {
    test('${locale.label}: nessun contenuto duplicato', () {
      void noDuplicates(String name, List<String> items) {
        final duplicates = <String>{};
        final seen = <String>{};
        for (final item in items) {
          if (!seen.add(item)) duplicates.add(item);
        }
        expect(duplicates, isEmpty, reason: '$name in ${locale.code}');
      }

      noDuplicates('Non ho mai', [
        for (final e in GameContent.nonHoMai(locale)) e.text,
      ]);
      noDuplicates('Chi lo potrebbe fare', [
        for (final e in GameContent.chiLoPotrebbeFare(locale)) e.text,
      ]);
      noDuplicates('Bluff Story', GameContent.bluffFakes(locale));
      noDuplicates('Impostore', GameContent.impostoreWords(locale));
      for (final tone in ContentTone.all) {
        noDuplicates('obblighi $tone', GameContent.obblighi(locale, tone));
        noDuplicates('verità $tone', GameContent.verita(locale, tone));
      }
    });
  }
}
