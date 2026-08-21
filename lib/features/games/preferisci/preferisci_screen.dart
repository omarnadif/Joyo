import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/player.dart';
import '../../room/data/models/room.dart';
import '../engine/pool_picker.dart';
import '../engine/round_game.dart';
import '../widgets/player_chip.dart';
import 'preferisci_pool.dart';

/// Preferisci: due opzioni, ognuno sceglie, alla fine si vede come si è
/// diviso il gruppo. Nessun punteggio: è puramente conversazionale.
class PreferisciScreen extends ConsumerWidget {
  const PreferisciScreen({required this.room, super.key});

  static const String gameId = 'preferisci';
  static const Color accent = JoyoColors.lime;

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('preferisci.name'),
      buildContent: (ctx) async {
        final pairs = PreferisciPool.pairs(locale);
        final index = pickPoolIndex(ctx.usedIndexes, pairs.length);
        return {'a': pairs[index].a, 'b': pairs[index].b, 'i': index};
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
    final choice = state.myValue?['choice'] as String?;

    return Column(
      children: [
        RoundCountdown(state: state),
        const SizedBox(height: 18),
        Eyebrow(t('preferisci.prompt')),
        const SizedBox(height: 14),
        // Le card si adattano al testo con un'altezza minima generosa: con
        // due parole non devono diventare due muri vuoti alti mezzo schermo.
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RiseIn(
                    child: _OptionCard(
                      label: state.content['a'] as String? ?? '—',
                      color: JoyoColors.lime,
                      selected: choice == 'a',
                      dimmed: choice == 'b',
                      onTap: state.hasVoted
                          ? null
                          : () => state.vote({'choice': 'a'}),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    t('preferisci.or'),
                    style: text.labelSmall?.copyWith(
                      color: JoyoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  RiseIn(
                    delayMs: 90,
                    child: _OptionCard(
                      label: state.content['b'] as String? ?? '—',
                      color: JoyoColors.coral,
                      selected: choice == 'b',
                      dimmed: choice == 'a',
                      onTap: state.hasVoted
                          ? null
                          : () => state.vote({'choice': 'b'}),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.color,
    required this.selected,
    required this.dimmed,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: dimmed ? 0.35 : 1,
      child: GlowCard(
        accent: color,
        glow: selected ? 1.8 : 0.5,
        borderWidth: selected ? 2.5 : 1.5,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 96),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: text.headlineMedium?.copyWith(
                height: 1.15,
                color: selected ? color : JoyoColors.textPrimary,
              ),
            ),
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
    final votersA = state.votersWhere((v) => v.value['choice'] == 'a');
    final votersB = state.votersWhere((v) => v.value['choice'] == 'b');
    final total = votersA.length + votersB.length;
    final fractionA = total == 0 ? 0.5 : votersA.length / total;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Eyebrow(
              total == 0 ? t('preferisci.no_votes') : t('preferisci.split'),
            ),
          ),
          const SizedBox(height: 18),
          _Side(
            label: state.content['a'] as String? ?? '—',
            color: JoyoColors.lime,
            voters: votersA,
            total: total,
          ),
          const SizedBox(height: 12),
          _SplitBar(fractionA: fractionA),
          const SizedBox(height: 12),
          _Side(
            label: state.content['b'] as String? ?? '—',
            color: JoyoColors.coral,
            voters: votersB,
            total: total,
          ),
        ],
      ),
    );
  }
}

/// La barra cresce da metà verso il risultato: si vede lo squilibrio nascere.
class _SplitBar extends StatelessWidget {
  const _SplitBar({required this.fractionA});

  final double fractionA;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: fractionA),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 20,
          child: Stack(
            children: [
              Container(color: JoyoColors.coral),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(color: JoyoColors.lime),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.label,
    required this.color,
    required this.voters,
    required this.total,
  });

  final String label;
  final Color color;
  final List<Player> voters;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final percent = total == 0 ? 0 : (voters.length * 100 / total).round();

    return GlowCard(
      accent: color,
      glow: voters.length * 2 > total ? 1.4 : 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: text.titleMedium)),
              const SizedBox(width: 12),
              Text(
                '${voters.length}',
                style: text.headlineMedium?.copyWith(color: color),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '$percent%',
                  style: text.labelSmall?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (voters.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final p in voters) PlayerChip(player: p)],
            ),
          ],
        ],
      ),
    );
  }
}
