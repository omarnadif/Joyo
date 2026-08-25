import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/features/games/content_tone.dart';
import 'package:joyo/features/games/preferisci/preferisci_pool.dart';

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
        PreferisciPool.entries(locale).length,
        PreferisciPool.entries(ref).length,
        reason: 'Preferisci',
      );
      expect(
        PreferisciPool.pairs(locale).length,
        PreferisciPool.pairs(ref).length,
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
  // Stato attuale: il blocco `soft` è allineato ovunque; le sezioni piccante e
  // cattivo di alcune lingue sono ancora contenuti autonomi (non traduzioni 1:1
  // in pari ordine). Finché non sono riallineate, la localizzazione per indice è
  // sicura solo sul soft: qui verifichiamo quella garanzia, così un futuro
  // disallineamento del soft non passa inosservato.
  List<int> softIndexes(List<({String text, String tone})> pool) =>
      [for (var i = 0; i < pool.length; i++) if (pool[i].tone == ContentTone.soft) i];
  List<int> preferisciSoftIndexes(AppLocale locale) => [
    for (var i = 0; i < PreferisciPool.entries(locale).length; i++)
      if (PreferisciPool.entries(locale)[i].tone == ContentTone.soft) i,
  ];

  for (final locale in AppLocale.values) {
    if (locale == ref) continue;
    test('${locale.label}: blocco soft allineato all\'italiano', () {
      expect(
        softIndexes(GameContent.nonHoMai(locale)),
        softIndexes(GameContent.nonHoMai(ref)),
        reason: 'Non ho mai: soft disallineato',
      );
      expect(
        softIndexes(GameContent.chiLoPotrebbeFare(locale)),
        softIndexes(GameContent.chiLoPotrebbeFare(ref)),
        reason: 'Chi lo potrebbe fare: soft disallineato',
      );
      expect(
        preferisciSoftIndexes(locale),
        preferisciSoftIndexes(ref),
        reason: 'Preferisci: soft disallineato',
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
