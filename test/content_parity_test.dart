import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/features/games/content_tone.dart';
import 'package:joyo/features/games/preferisci/preferisci_pool.dart';

/// L'italiano è la lingua di riferimento: le altre quattro devono avere le
/// stesse quantità, gioco per gioco e tono per tono. Senza questo test una
/// lingua può restare indietro per mesi senza che nessuno se ne accorga,
/// perché l'app compila e gira benissimo anche con un pool dimezzato.
void main() {
  int perTone(List<({String text, String tone})> pool, String tone) =>
      pool.where((e) => e.tone == tone).length;

  for (final locale in AppLocale.values) {
    test('${locale.label}: stesse quantità dell\'italiano', () {
      final nonHoMai = GameContent.nonHoMai(locale);
      expect(nonHoMai.length, 455, reason: 'Non ho mai');
      expect(perTone(nonHoMai, ContentTone.soft), 155);
      expect(perTone(nonHoMai, ContentTone.piccante), 150);
      expect(perTone(nonHoMai, ContentTone.cattivo), 150);

      final chiLo = GameContent.chiLoPotrebbeFare(locale);
      expect(chiLo.length, 460, reason: 'Chi lo potrebbe fare');
      expect(perTone(chiLo, ContentTone.soft), 160);
      expect(perTone(chiLo, ContentTone.piccante), 150);
      expect(perTone(chiLo, ContentTone.cattivo), 150);

      final preferisci = PreferisciPool.entries(locale);
      expect(preferisci.length, 473, reason: 'Preferisci');
      expect(PreferisciPool.pairs(locale).length, 173, reason: 'Preferisci');

      for (final tone in ContentTone.all) {
        expect(
          GameContent.obblighi(locale, tone).length,
          150,
          reason: 'obblighi $tone',
        );
        expect(
          GameContent.verita(locale, tone).length,
          150,
          reason: 'verità $tone',
        );
      }

      expect(GameContent.bluffFakes(locale).length, 150, reason: 'Bluff Story');
      expect(
        GameContent.impostoreWords(locale).length,
        150,
        reason: 'Impostore',
      );
    });

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
