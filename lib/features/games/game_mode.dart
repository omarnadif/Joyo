import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'content_tone.dart';

/// Come si gioca la serata: la modalità decide quanto sono spinti i contenuti
/// e se il gioco resta lo stesso o cambia a ogni round.
enum GameMode {
  normale('normale', JoyoColors.aqua, Icons.wb_sunny_rounded),
  mix('mix', JoyoColors.violet, Icons.shuffle_rounded),
  hot('hot', JoyoColors.coral, Icons.local_fire_department_rounded);

  const GameMode(this.id, this.color, this.icon);

  final String id;
  final Color color;
  final IconData icon;

  static GameMode fromId(String? id) => switch (id) {
    'mix' => GameMode.mix,
    'hot' => GameMode.hot,
    _ => GameMode.normale,
  };

  /// I giochi cambiano a ogni round solo in Mix.
  bool get rotatesGames => this == GameMode.mix;

  /// Toni ammessi: Hot pesca solo dal mazzo cattivo (chi la sceglie vuole solo
  /// i più spinti), le altre modalità sono cumulative così il tono sale senza vuoti.
  Set<String> get tones => switch (this) {
    GameMode.normale => const {ContentTone.soft},
    GameMode.mix => const {ContentTone.soft, ContentTone.piccante},
    GameMode.hot => const {ContentTone.cattivo},
  };

  bool allows(String tone) => tones.contains(tone);

  /// Il tono da usare quando un gioco ha un mazzo per tono, come Obbligo o
  /// Verità: si prende il più alto fra quelli ammessi.
  String get primaryTone => switch (this) {
    GameMode.normale => ContentTone.soft,
    GameMode.mix => ContentTone.piccante,
    GameMode.hot => ContentTone.cattivo,
  };

  /// Indici utilizzabili di una lista catalogata per tono.
  List<int> indexesFor<T>(List<T> items, String Function(T item) toneOf) => [
    for (var i = 0; i < items.length; i++)
      if (allows(toneOf(items[i]))) i,
  ];
}
