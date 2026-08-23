import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Un gioco del catalogo. `id` è il valore scritto in `rooms.active_game`.
///
/// Nome e sottotitolo sono chiavi di traduzione, non testo: il catalogo deve
/// funzionare in tutte e cinque le lingue.
class GameDefinition {
  const GameDefinition({
    required this.id,
    required this.nameKey,
    required this.taglineKey,
    required this.color,
    required this.icon,
    this.implemented = false,
  });

  final String id;
  final String nameKey;
  final String taglineKey;
  final Color color;
  final IconData icon;
  final bool implemented;
}

class GameCatalog {
  const GameCatalog._();

  static const List<GameDefinition> all = <GameDefinition>[
    GameDefinition(
      id: 'preferisci',
      nameKey: 'preferisci.name',
      taglineKey: 'preferisci.tagline',
      color: JoyoColors.lime,
      icon: Icons.swap_horiz_rounded,
      implemented: true,
    ),
    GameDefinition(
      id: 'non_ho_mai',
      nameKey: 'non_ho_mai.name',
      taglineKey: 'non_ho_mai.tagline',
      color: JoyoColors.coral,
      icon: Icons.local_bar_rounded,
      implemented: true,
    ),
    GameDefinition(
      id: 'chi_lo_potrebbe_fare',
      nameKey: 'chi.name',
      taglineKey: 'chi.tagline',
      color: JoyoColors.sky,
      icon: Icons.groups_rounded,
      implemented: true,
    ),
    GameDefinition(
      id: 'obbligo_o_verita',
      nameKey: 'obbligo.name',
      taglineKey: 'obbligo.tagline',
      color: JoyoColors.aqua,
      icon: Icons.rotate_right_rounded,
      implemented: true,
    ),
    GameDefinition(
      id: 'bluff_story',
      nameKey: 'bluff.name',
      taglineKey: 'bluff.tagline',
      color: JoyoColors.amber,
      icon: Icons.auto_stories_rounded,
      implemented: true,
    ),
    GameDefinition(
      id: 'impostore',
      nameKey: 'impostore.name',
      taglineKey: 'impostore.tagline',
      color: JoyoColors.magenta,
      icon: Icons.visibility_off_rounded,
      implemented: true,
    ),
  ];

  static List<GameDefinition> get playable => [
    for (final game in all)
      if (game.implemented) game,
  ];

  /// Un gioco a caso diverso da quello in corso: è la modalità Mix.
  static GameDefinition randomPlayable({String? exclude}) {
    final pool = [
      for (final game in playable)
        if (game.id != exclude) game,
    ];
    final list = pool.isEmpty ? playable : pool;
    return list[Random().nextInt(list.length)];
  }

  static GameDefinition? byId(String? id) {
    if (id == null) return null;
    for (final game in all) {
      if (game.id == id) return game;
    }
    return null;
  }
}
