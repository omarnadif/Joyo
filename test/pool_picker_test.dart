import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/features/games/content_tone.dart';
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
    test('soft esclude piccante e cattivo', () {
      expect(ContentTone.allows(ContentTone.soft, ContentTone.soft), isTrue);
      expect(
        ContentTone.allows(ContentTone.soft, ContentTone.piccante),
        isFalse,
      );
      expect(
        ContentTone.allows(ContentTone.soft, ContentTone.cattivo),
        isFalse,
      );
    });

    test('piccante include soft ma non cattivo', () {
      expect(
        ContentTone.allows(ContentTone.piccante, ContentTone.soft),
        isTrue,
      );
      expect(
        ContentTone.allows(ContentTone.piccante, ContentTone.piccante),
        isTrue,
      );
      expect(
        ContentTone.allows(ContentTone.piccante, ContentTone.cattivo),
        isFalse,
      );
    });

    test('cattivo include tutto', () {
      for (final tone in ContentTone.all) {
        expect(ContentTone.allows(ContentTone.cattivo, tone), isTrue);
      }
    });
  });

  group('modalità', () {
    // Le modalità non seguono la regola cumulativa dei toni: Hot è una scelta
    // netta, non "tutto quello che c'è sopra il soft".
    test('Normale solo soft, Mix soft e piccante, Hot solo cattivo', () {
      expect(GameMode.normale.tones, {ContentTone.soft});
      expect(GameMode.mix.tones, {ContentTone.soft, ContentTone.piccante});
      expect(GameMode.hot.tones, {ContentTone.cattivo});
    });

    test('Hot non fa passare né soft né piccante', () {
      expect(GameMode.hot.allows(ContentTone.soft), isFalse);
      expect(GameMode.hot.allows(ContentTone.piccante), isFalse);
      expect(GameMode.hot.allows(ContentTone.cattivo), isTrue);
    });
  });
}
