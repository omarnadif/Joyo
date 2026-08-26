import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/content/content_tone.dart';
import 'package:joyo/features/games/engine/pool_picker.dart';
import 'package:joyo/features/games/game_mode.dart';

void main() {
  test('non ripesca mai un contenuto già uscito, finché ce ne sono altri', () {
    final used = <int>{};
    for (var i = 0; i < 9; i++) {
      final pick = pickPoolIndex(used, 10, Random(i));
      expect(used.contains(pick), isFalse);
      used.add(pick);
    }
    expect(used.length, 9);
  });

  test('a pool esaurito ricomincia invece di bloccarsi', () {
    final used = {for (var i = 0; i < 10; i++) i};
    final pick = pickPoolIndex(used, 10, Random(1));
    expect(pick, inInclusiveRange(0, 9));
  });

  group('toni', () {
    test('normal esclude mix e hot', () {
      expect(ContentTone.allows(ContentTone.normal, ContentTone.normal), isTrue);
      expect(
        ContentTone.allows(ContentTone.normal, ContentTone.mix),
        isFalse,
      );
      expect(
        ContentTone.allows(ContentTone.normal, ContentTone.hot),
        isFalse,
      );
    });

    test('mix include normal ma non hot', () {
      expect(
        ContentTone.allows(ContentTone.mix, ContentTone.normal),
        isTrue,
      );
      expect(
        ContentTone.allows(ContentTone.mix, ContentTone.mix),
        isTrue,
      );
      expect(
        ContentTone.allows(ContentTone.mix, ContentTone.hot),
        isFalse,
      );
    });

    test('hot include tutto', () {
      for (final tone in ContentTone.all) {
        expect(ContentTone.allows(ContentTone.hot, tone), isTrue);
      }
    });
  });

  group('modalità', () {
    // Le modalità non seguono la regola cumulativa dei toni: Hot è una scelta
    // netta, non "tutto quello che c'è sopra il normal".
    test('Normale solo normal, Mix normal e mix, Hot solo hot', () {
      expect(GameMode.normale.tones, {ContentTone.normal});
      expect(GameMode.mix.tones, {ContentTone.normal, ContentTone.mix});
      expect(GameMode.hot.tones, {ContentTone.hot});
    });

    test('Hot non fa passare né normal né mix', () {
      expect(GameMode.hot.allows(ContentTone.normal), isFalse);
      expect(GameMode.hot.allows(ContentTone.mix), isFalse);
      expect(GameMode.hot.allows(ContentTone.hot), isTrue);
    });
  });
}
