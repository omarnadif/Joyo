import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/bluff_story/bluff_story_pool.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/features/games/game_mode.dart';
import 'package:joyo/features/games/chi_lo_potrebbe_fare/chi_lo_potrebbe_fare_pool.dart';
import 'package:joyo/features/games/content_tone.dart';
import 'package:joyo/features/games/impostore/impostore_words.dart';
import 'package:joyo/features/games/non_ho_mai/non_ho_mai_pool.dart';
import 'package:joyo/features/games/obbligo_o_verita/obbligo_o_verita_pool.dart';
import 'package:joyo/features/games/preferisci/preferisci_pool.dart';

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
      for (final p in PreferisciPool.it) p.a,
    ], 100);
  });

  group('Non ho mai', () {
    checkList('frasi', [for (final e in NonHoMaiPool.entries) e.text], 150);

    test('sono presenti entrambi i toni previsti', () {
      final tones = NonHoMaiPool.entries.map((e) => e.tone).toSet();
      expect(tones, contains(ContentTone.soft));
      expect(tones, contains(ContentTone.piccante));
    });

    test('una stanza soft non vede mai contenuti piccanti', () {
      final allowed = ContentTone.indexesFor(
        NonHoMaiPool.entries,
        ContentTone.soft,
        (e) => e.tone,
      );
      expect(allowed, isNotEmpty);
      for (final index in allowed) {
        expect(NonHoMaiPool.entries[index].tone, ContentTone.soft);
      }
    });

    test('una stanza piccante vede anche i contenuti soft', () {
      final allowed = ContentTone.indexesFor(
        NonHoMaiPool.entries,
        ContentTone.piccante,
        (e) => e.tone,
      );
      expect(allowed.length, greaterThan(0));
      expect(
        allowed.length,
        greaterThan(
          ContentTone.indexesFor(
            NonHoMaiPool.entries,
            ContentTone.soft,
            (e) => e.tone,
          ).length,
        ),
      );
    });
  });

  group('Chi lo potrebbe fare', () {
    checkList('domande', [
      for (final e in ChiLoPotrebbeFarePool.entries) e.text,
    ], 150);

    test('sono tutte domande', () {
      for (final entry in ChiLoPotrebbeFarePool.entries) {
        expect(entry.text.endsWith('?'), isTrue, reason: entry.text);
      }
    });
  });

  group('Obbligo o Verità', () {
    for (final tone in ContentTone.all) {
      checkList('obblighi $tone', ObbligoOVeritaPool.obblighi(tone), 100);
      checkList('verità $tone', ObbligoOVeritaPool.verita(tone), 100);
    }

    test('i tre toni hanno mazzi diversi', () {
      final soft = ObbligoOVeritaPool.obblighi(ContentTone.soft).toSet();
      final cattivo = ObbligoOVeritaPool.obblighi(ContentTone.cattivo).toSet();
      expect(soft.intersection(cattivo), isEmpty);
    });
  });

  group('Bluff Story', () {
    checkList('bugie generiche', BluffStoryPool.fakes, 100);
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
              .indexesFor(PreferisciPool.entries(AppLocale.it), (e) => e.tone)
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
    checkList('parole segrete', ImpostoreWords.words, 50);

    test('sono parole brevi, dicibili in un giro di tavolo', () {
      for (final word in ImpostoreWords.words) {
        expect(word.length, lessThanOrEqualTo(20), reason: word);
      }
    });
  });
}
