import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../room/data/models/room.dart';
import '../room/state/room_providers.dart';
import 'bluff_story/bluff_story_screen.dart';
import 'chi_lo_potrebbe_fare/chi_lo_potrebbe_fare_screen.dart';
import 'end_of_game_screen.dart';
import 'game_catalog.dart';
import 'impostore/impostore_screen.dart';
import 'non_ho_mai/non_ho_mai_screen.dart';
import 'obbligo_o_verita/obbligo_o_verita_screen.dart';
import 'preferisci/preferisci_screen.dart';
import 'widgets/game_scaffold.dart';

/// Smistamento verso la schermata del gioco attivo, in base a `rooms`.
class GameStageScreen extends ConsumerWidget {
  const GameStageScreen({required this.room, super.key});

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (room.status == RoomStatus.finished) {
      return EndOfGameScreen(room: room);
    }

    return switch (room.activeGame) {
      PreferisciScreen.gameId => PreferisciScreen(room: room),
      NonHoMaiScreen.gameId => NonHoMaiScreen(room: room),
      ChiLoPotrebbeFareScreen.gameId => ChiLoPotrebbeFareScreen(room: room),
      ObbligoOVeritaScreen.gameId => ObbligoOVeritaScreen(room: room),
      BluffStoryScreen.gameId => BluffStoryScreen(room: room),
      ImpostoreScreen.gameId => ImpostoreScreen(room: room),
      _ => _ComingSoon(room: room),
    };
  }
}

/// Rete di sicurezza: se un giorno arriva un gioco nuovo e un telefono ha una
/// versione vecchia dell'app, meglio una schermata chiara di un crash.
class _ComingSoon extends ConsumerWidget {
  const _ComingSoon({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final game = GameCatalog.byId(room.activeGame);
    final players = ref.watch(playersProvider(room.id)).value ?? const [];

    return GameScaffold(
      title: game == null ? 'Joyo' : t(game.nameKey),
      accent: game?.color ?? JoyoColors.violet,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              game?.icon ?? Icons.hourglass_empty_rounded,
              size: 56,
              color: game?.color ?? JoyoColors.violet,
            ),
            const SizedBox(height: 20),
            Text(
              t('game.coming_soon'),
              textAlign: TextAlign.center,
              style: text.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '${players.length}',
              style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
