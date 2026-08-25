import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/room.dart';
import '../content/game_content.dart';
import '../engine/round_game.dart';

/// Non ho mai: ognuno dichiara in silenzio se l'ha fatto e il risultato è solo
/// il conteggio anonimo, ed è questo a rendere giocabile il tono Hot.
class NonHoMaiScreen extends ConsumerWidget {
  const NonHoMaiScreen({required this.room, super.key});

  static const String gameId = 'non_ho_mai';
  static const Color accent = JoyoColors.coral;

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('non_ho_mai.name'),
      buildContent: (ctx) async {
        final entries = GameContent.nonHoMai(locale);
        final allowed = ctx.room.mode.indexesFor(entries, (e) => e.tone);
        // Se la lingua non ha frasi nei toni ammessi si pesca da tutto il
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
    final done = state.myValue?['done'] as bool?;

    return Column(
      children: [
        RoundCountdown(state: state),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: RiseIn(
                child: Column(
                  children: [
                    Eyebrow(t('non_ho_mai.prompt'), color: JoyoColors.coral),
                    const SizedBox(height: 14),
                    Text(
                      GameContent.nonHoMaiText(t.locale, state.content),
                      textAlign: TextAlign.center,
                      style: text.headlineLarge?.copyWith(height: 1.25),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _AnswerCard(
                label: t('non_ho_mai.done'),
                color: JoyoColors.coral,
                icon: Icons.local_fire_department_rounded,
                selected: done == true,
                dimmed: done == false,
                onTap: state.hasVoted ? null : () => state.vote({'done': true}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnswerCard(
                label: t('non_ho_mai.never'),
                color: JoyoColors.aqua,
                icon: Icons.shield_moon_rounded,
                selected: done == false,
                dimmed: done == true,
                onTap: state.hasVoted
                    ? null
                    : () => state.vote({'done': false}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          t('non_ho_mai.anonymous'),
          textAlign: TextAlign.center,
          style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
        ),
      ],
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.label,
    required this.color,
    required this.icon,
    required this.selected,
    required this.dimmed,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: dimmed ? 0.35 : 1,
      child: GlowCard(
        accent: color,
        glow: selected ? 1.9 : 0.5,
        borderWidth: selected ? 2.5 : 1.5,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: color),
            ),
          ],
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
    final yes = state.votes.where((v) => v.value['done'] == true).length;
    final total = state.votes.length;
    final fraction = total == 0 ? 0.0 : yes / total;

    return SingleChildScrollView(
      child: Column(
        children: [
          Eyebrow(t('non_ho_mai.prompt'), color: JoyoColors.coral),
          const SizedBox(height: 10),
          Text(
            GameContent.nonHoMaiText(t.locale, state.content),
            textAlign: TextAlign.center,
            style: text.titleLarge?.copyWith(height: 1.3),
          ),
          const SizedBox(height: 30),
          if (total == 0 || yes == 0)
            Text(
              t('non_ho_mai.nobody'),
              style: text.headlineMedium?.copyWith(color: JoyoColors.aqua),
            )
          else
            _Counter(yes: yes, total: total, t: t),
          const SizedBox(height: 26),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 20,
              child: Stack(
                children: [
                  Container(color: JoyoColors.surfaceHigh),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: fraction),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => FractionallySizedBox(
                      widthFactor: value,
                      child: Container(color: JoyoColors.coral),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            t('non_ho_mai.guess_who'),
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Il numero sale da zero per dare un piccolo momento invece di comparire e basta.
class _Counter extends StatelessWidget {
  const _Counter({required this.yes, required this.total, required this.t});

  final int yes;
  final int total;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: yes.toDouble()),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Text(
        t('non_ho_mai.count', {'n': '${value.round()}', 'total': '$total'}),
        style: Theme.of(
          context,
        ).textTheme.displayMedium?.copyWith(color: JoyoColors.coral),
      ),
    );
  }
}
