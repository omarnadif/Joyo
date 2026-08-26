import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/content/content_it.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/features/games/game_mode.dart';
import 'package:joyo/content/content_tone.dart';

/// I pool sono il contenuto gratuito dell'app: se si svuotano o si ripetono,
/// il gioco smette di funzionare pur compilando benissimo.
void main() {
  void checkList(String name, List<String> items, int minimum) {
    test('$name: almeno $minimum voci, nessun duplicato, niente vuoti', () {
      expect(items.length, greaterThanOrEqualTo(minimum), reason: name);
      expect(
        items.toSet().length,
        items.length,
        reason: '$name contiene duplicati',
      );
      for (final item in items) {
        expect(item.trim(), isNotEmpty, reason: '$name ha una voce vuota');
        expect(
          item.length,
          lessThanOrEqualTo(180),
          reason: 'troppo lunga per stare in una card: $item',
        );
      }
    });
  }

  group('Preferisci', () {
    checkList('coppie italiane (a)', [
      for (final p in ContentIt.preferisciPairs) p.a,
    ], 100);
  });

  group('Non ho mai', () {
    checkList('frasi', [for (final e in ContentIt.nonHoMai) e.text], 150);

    test('sono presenti entrambi i toni previsti', () {
      final tones = ContentIt.nonHoMai.map((e) => e.tone).toSet();
      expect(tones, contains(ContentTone.normal));
      expect(tones, contains(ContentTone.mix));
    });

    test('una stanza normal non vede mai contenuti mix', () {
      final allowed = ContentTone.indexesFor(
        ContentIt.nonHoMai,
        ContentTone.normal,
        (e) => e.tone,
      );
      expect(allowed, isNotEmpty);
      for (final index in allowed) {
        expect(ContentIt.nonHoMai[index].tone, ContentTone.normal);
      }
    });

    test('una stanza mix vede anche i contenuti normal', () {
      final allowed = ContentTone.indexesFor(
        ContentIt.nonHoMai,
        ContentTone.mix,
        (e) => e.tone,
      );
      expect(allowed.length, greaterThan(0));
      expect(
        allowed.length,
        greaterThan(
          ContentTone.indexesFor(
            ContentIt.nonHoMai,
            ContentTone.normal,
            (e) => e.tone,
          ).length,
        ),
      );
    });
  });

  group('Chi lo potrebbe fare', () {
    checkList('domande', [
      for (final e in ContentIt.chiLoPotrebbeFare) e.text,
    ], 150);

    test('sono tutte domande', () {
      for (final entry in ContentIt.chiLoPotrebbeFare) {
        expect(entry.text.endsWith('?'), isTrue, reason: entry.text);
      }
    });
  });

  group('Obbligo o Verità', () {
    for (final tone in ContentTone.all) {
      checkList('obblighi $tone', GameContent.obblighi(AppLocale.it, tone), 100);
      checkList('verità $tone', GameContent.verita(AppLocale.it, tone), 100);
    }

    test('i tre toni hanno mazzi diversi', () {
      final normal = GameContent.obblighi(AppLocale.it, ContentTone.normal).toSet();
      final hot = GameContent.obblighi(AppLocale.it, ContentTone.hot).toSet();
      expect(normal.intersection(hot), isEmpty);
    });
  });

  group('Bluff Story', () {
    checkList('bugie generiche', ContentIt.bluffFakes, 100);
  });

  group('tutte le lingue', () {
    // Una lingua senza contenuti per un gioco lo rende ingiocabile: qui si
    // vede subito, invece che a partita iniziata.
    for (final locale in AppLocale.values) {
      test('${locale.label}: ogni gioco ha contenuti', () {
        expect(
          GameContent.nonHoMai(locale).length,
          greaterThanOrEqualTo(30),
          reason: 'Non ho mai',
        );
        expect(
          GameContent.chiLoPotrebbeFare(locale).length,
          greaterThanOrEqualTo(30),
          reason: 'Chi lo potrebbe fare',
        );
        expect(
          GameContent.bluffFakes(locale).length,
          greaterThanOrEqualTo(25),
          reason: 'Bluff Story',
        );
        expect(
          GameContent.impostoreWords(locale).length,
          greaterThanOrEqualTo(40),
          reason: 'Impostore',
        );
        for (final tone in ContentTone.all) {
          expect(
            GameContent.obblighi(locale, tone).length,
            greaterThanOrEqualTo(15),
            reason: 'obblighi $tone',
          );
          expect(
            GameContent.verita(locale, tone).length,
            greaterThanOrEqualTo(15),
            reason: 'verità $tone',
          );
        }
      });

      test('${locale.label}: ogni modalità ha contenuti pescabili', () {
        for (final mode in GameMode.values) {
          expect(
            mode.indexesFor(GameContent.nonHoMai(locale), (e) => e.tone),
            isNotEmpty,
            reason: 'Non ho mai in ${mode.id}',
          );
          expect(
            mode.indexesFor(
              GameContent.chiLoPotrebbeFare(locale),
              (e) => e.tone,
            ),
            isNotEmpty,
            reason: 'Chi lo potrebbe fare in ${mode.id}',
          );
          expect(
            GameContent.obblighi(locale, mode.primaryTone),
            isNotEmpty,
            reason: 'obblighi in ${mode.id}',
          );
        }
      });
    }
  });

  group('quota per modalità (italiano)', () {
    // L'italiano è la lingua di riferimento: ogni modalità deve poter
    // pescare almeno 150 contenuti per gioco, così nemmeno una partita
    // lunghissima ricicla le stesse domande.
    test('ogni modalità pesca almeno 150 contenuti per gioco', () {
      for (final mode in GameMode.values) {
        expect(
          mode
              .indexesFor(GameContent.nonHoMai(AppLocale.it), (e) => e.tone)
              .length,
          greaterThanOrEqualTo(150),
          reason: 'Non ho mai in ${mode.id}',
        );
        expect(
          mode
              .indexesFor(
                GameContent.chiLoPotrebbeFare(AppLocale.it),
                (e) => e.tone,
              )
              .length,
          greaterThanOrEqualTo(150),
          reason: 'Chi lo potrebbe fare in ${mode.id}',
        );
        expect(
          mode
              .indexesFor(
                GameContent.preferisciEntries(AppLocale.it),
                (e) => e.tone,
              )
              .length,
          greaterThanOrEqualTo(150),
          reason: 'Preferisci in ${mode.id}',
        );
        expect(
          GameContent.obblighi(AppLocale.it, mode.primaryTone).length +
              GameContent.verita(AppLocale.it, mode.primaryTone).length,
          greaterThanOrEqualTo(150),
          reason: 'Obbligo o Verità in ${mode.id}',
        );
      }
    });
  });

  group('Impostore', () {
    checkList('parole segrete', ContentIt.impostoreWords, 50);

    test('sono parole brevi, dicibili in un giro di tavolo', () {
      for (final word in ContentIt.impostoreWords) {
        expect(word.length, lessThanOrEqualTo(20), reason: word);
      }
    });
  });
}
