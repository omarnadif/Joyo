import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/player.dart';
import '../../room/data/models/room.dart';
import '../content/game_content.dart';
import '../engine/round_game.dart';
import '../widgets/player_chip.dart';

/// Chi lo potrebbe fare: una domanda sul gruppo, ognuno vota una persona
/// presente nella stanza. Vince chi raccoglie più voti.
class ChiLoPotrebbeFareScreen extends ConsumerWidget {
  const ChiLoPotrebbeFareScreen({required this.room, super.key});

  static const String gameId = 'chi_lo_potrebbe_fare';
  static const Color accent = JoyoColors.sky;

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('chi.name'),
      buildContent: (ctx) async {
        final entries = GameContent.chiLoPotrebbeFare(locale);
        final allowed = ctx.room.mode.indexesFor(entries, (e) => e.tone);
        // Se la lingua non ha domande nei toni ammessi si pesca da tutto il
        // mazzo, per non lasciare il pool vuoto e far fallire la pesca.
        final candidates = allowed.isEmpty
            ? [for (var i = 0; i < entries.length; i++) i]
            : allowed;
        final fresh = candidates
            .where((i) => !ctx.usedIndexes.contains(i))
            .toList();
        final pool = fresh.isEmpty ? candidates : fresh;
        final index = pool[Random().nextInt(pool.length)];
        return {'text': entries[index].text, 'i': index};
      },
      votingBuilder: (context, state) => _Voting(state: state, t: t),
      resultBuilder: (context, state) => _Result(state: state, t: t),
    );
  }
}

class _Voting extends StatelessWidget {
  const _Voting({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final chosen = state.myValue?['player_id'] as String?;

    return Column(
      children: [
        RoundCountdown(state: state),
        const SizedBox(height: 18),
        RiseIn(
          child: Text(
            GameContent.chiLoPotrebbeFareText(t.locale, state.content),
            textAlign: TextAlign.center,
            style: text.headlineMedium?.copyWith(height: 1.25),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: state.players.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final player = state.players[i];
              final selected = chosen == player.id;
              return _PlayerOption(
                player: player,
                selected: selected,
                dimmed: chosen != null && !selected,
                label: player.id == state.me?.id
                    ? '${player.name} (${t('common.you')})'
                    : player.name,
                onTap: state.hasVoted
                    ? null
                    : () => state.vote({'player_id': player.id}),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlayerOption extends StatelessWidget {
  const _PlayerOption({
    required this.player,
    required this.selected,
    required this.dimmed,
    required this.label,
    required this.onTap,
  });

  final Player player;
  final bool selected;
  final bool dimmed;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = JoyoColors.avatar(player.color);

    return Opacity(
      opacity: dimmed ? 0.4 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.18)
                : JoyoColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              PlayerAvatar(player: player),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: text.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final counts = <String, int>{};
    for (final vote in state.votes) {
      final id = vote.value['player_id'] as String?;
      if (id != null) counts[id] = (counts[id] ?? 0) + 1;
    }
    final total = state.votes.length;
    final ranking = state.players.toList()
      ..sort((a, b) => (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0));
    final topVotes = ranking.isEmpty ? 0 : counts[ranking.first.id] ?? 0;
    final winners = ranking.where(
      (p) => (counts[p.id] ?? 0) == topVotes && topVotes > 0,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            GameContent.chiLoPotrebbeFareText(t.locale, state.content),
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(height: 1.3),
          ),
          const SizedBox(height: 20),
          if (topVotes == 0)
            Text(
              t('chi.no_votes'),
              textAlign: TextAlign.center,
              style: text.titleMedium?.copyWith(
                color: JoyoColors.textSecondary,
              ),
            )
          else
            Column(
              children: [
                Eyebrow(winners.length > 1 ? t('chi.tie') : t('chi.decided')),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final winner in winners)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PlayerAvatar(player: winner, size: 64),
                          const SizedBox(height: 8),
                          Text(winner.name, style: text.titleMedium),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 24),
          for (final player in ranking)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Row(
                player: player,
                votes: counts[player.id] ?? 0,
                total: total,
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.player, required this.votes, required this.total});

  final Player player;
  final int votes;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = JoyoColors.avatar(player.color);
    final fraction = total == 0 ? 0.0 : votes / total;
    final percent = total == 0 ? 0 : (votes * 100 / total).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(player.name, style: text.bodyMedium)),
            Text(
              '$votes · $percent%',
              style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 12,
            child: Stack(
              children: [
                Container(color: JoyoColors.surface),
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
