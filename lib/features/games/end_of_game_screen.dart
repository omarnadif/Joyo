import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/confetti.dart';
import '../../core/ui/joyo_ui.dart';
import '../premium/ads/ads_service.dart';
import '../premium/entitlements.dart';
import '../premium/shop_screen.dart';
import '../room/data/models/player.dart';
import '../room/data/models/room.dart';
import '../room/state/room_providers.dart';
import 'game_catalog.dart';
import 'widgets/game_scaffold.dart';
import 'widgets/player_chip.dart';

/// Podio di fine partita: i giochi senza punteggio non producono una classifica,
/// quindi in quel caso mostro solo chi ha giocato senza inventare vincitori.
class EndOfGameScreen extends ConsumerWidget {
  const EndOfGameScreen({required this.room, super.key});

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final isHost = ref.watch(isHostProvider(room.id));
    final players = [
      ...ref.watch(playersProvider(room.id)).value ?? const <Player>[],
    ]..sort((a, b) => b.score.compareTo(a.score));
    final game = GameCatalog.byId(room.activeGame);
    final hasScores = players.any((p) => p.score != 0);

    final podium = players.take(3).toList();
    final others = players.skip(3).toList();

    return GameScaffold(
      title: t('podium.title'),
      accent: game?.color ?? JoyoColors.lime,
      subtitle: game == null ? null : t(game.nameKey),
      overlay: hasScores ? const Confetti() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 8),
                Text(
                  '🎉',
                  textAlign: TextAlign.center,
                  style: text.displayMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  hasScores && podium.isNotEmpty
                      ? t('podium.winner', {'name': podium.first.name})
                      : t('game.finished'),
                  textAlign: TextAlign.center,
                  style: text.headlineMedium,
                ),
                const SizedBox(height: 24),

                if (hasScores) ...[
                  _Podium(players: podium, t: t),
                  const SizedBox(height: 28),
                  for (var i = 0; i < others.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RankRow(position: i + 4, player: others[i]),
                    ),
                ] else ...[
                  Text(
                    t('podium.no_scores'),
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: JoyoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final player in players) PlayerChip(player: player),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!ref.watch(hasPremiumProvider)) ...[
            const SizedBox(height: 12),
            Text(
              t('endgame.promo'),
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
            ),
            const SizedBox(height: 10),
            JoyoGhostButton(
              label: t('endgame.shop_cta'),
              onPressed: () => openShop(context),
            ),
          ],
          const SizedBox(height: 12),
          if (isHost)
            JoyoButton(
              label: t('game.back_to_lobby'),
              // L'interstiziale compare solo a partita finita, mai durante il
              // gioco. Il repository va letto prima dell'attesa perché durante
              // l'interstiziale il widget può uscire dall'albero e `ref` non
              // sarebbe più utilizzabile.
              onPressed: () async {
                final noAds = ref.read(noAdsProvider);
                final ads = ref.read(adsServiceProvider);
                final repo = ref.read(roomRepositoryProvider);
                if (!noAds) await ads.showInterstitial();
                await repo.backToLobby(room.id);
              },
            )
          else
            Text(
              t('game.host_only'),
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

/// I primi tre, con i gradini di altezza diversa.
class _Podium extends StatelessWidget {
  const _Podium({required this.players, required this.t});

  final List<Player> players;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return const SizedBox.shrink();

    final first = players.first;
    final second = players.length > 1 ? players[1] : null;
    final third = players.length > 2 ? players[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: second == null
              ? const SizedBox.shrink()
              : _Step(
                  player: second,
                  position: 2,
                  height: 90,
                  color: JoyoColors.violet,
                  t: t,
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _Step(
            player: first,
            position: 1,
            height: 130,
            color: JoyoColors.lime,
            t: t,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: third == null
              ? const SizedBox.shrink()
              : _Step(
                  player: third,
                  position: 3,
                  height: 66,
                  color: JoyoColors.amber,
                  t: t,
                ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.player,
    required this.position,
    required this.height,
    required this.color,
    required this.t,
  });

  final Player player;
  final int position;
  final double height;
  final Color color;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerAvatar(player: player, size: position == 1 ? 60 : 48),
        const SizedBox(height: 6),
        Text(
          player.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleMedium,
        ),
        Text(
          t.n('podium.points', player.score),
          style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500 + position * 120),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => SizedBox(
            height: height * value,
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: height,
              child: child,
            ),
          ),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.32),
                  color.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(color: color, width: 2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 26,
                  spreadRadius: -8,
                ),
              ],
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '$position',
              style: text.headlineMedium?.copyWith(color: color),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.position, required this.player});

  final int position;
  final Player player;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: JoyoColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '$position',
              style: text.titleMedium?.copyWith(
                color: JoyoColors.textSecondary,
              ),
            ),
          ),
          PlayerAvatar(player: player, size: 34),
          const SizedBox(width: 12),
          Expanded(child: Text(player.name, style: text.titleMedium)),
          Text(
            '${player.score}',
            style: text.titleMedium?.copyWith(color: JoyoColors.lime),
          ),
        ],
      ),
    );
  }
}
