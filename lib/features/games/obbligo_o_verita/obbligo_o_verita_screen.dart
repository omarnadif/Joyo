import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/room.dart';
import '../content/game_content.dart';
import '../engine/pool_picker.dart';
import '../engine/round_game.dart';
import '../widgets/player_chip.dart';
import 'bottle_wheel.dart';

/// Obbligo o Verità: host, giocatore estratto e le due sfide sono decisi una
/// volta sola dentro il round, così ogni telefono mostra lo stesso esito senza
/// altri giri sul server.
class ObbligoOVeritaScreen extends ConsumerWidget {
  const ObbligoOVeritaScreen({required this.room, super.key});

  static const String gameId = 'obbligo_o_verita';
  static const Color accent = JoyoColors.aqua;

  /// L'estratto non ha un timer stretto: questo serve solo a non bloccare la
  /// partita se il suo telefono sparisce.
  static const Duration turnWindow = Duration(seconds: 120);

  /// Offset che separa gli indici delle verità da quelli degli obblighi nel
  /// registro "già usciti".
  static const int veritaOffset = 1000;

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('obbligo.name'),
      votingWindow: turnWindow,
      showVoteCounter: false,
      shouldClose: (state) {
        final target = state.content['target'] as String?;
        return target != null &&
            state.votes.any((vote) => vote.playerId == target);
      },
      buildContent: (ctx) async {
        final random = Random();
        final tone = ctx.room.mode.primaryTone;
        final obblighi = GameContent.obblighi(locale, tone);
        final verita = GameContent.verita(locale, tone);

        final obbligoIndex = pickPoolIndex(
          ctx.usedIndexes,
          obblighi.length,
          random,
        );
        final veritaIndex = pickPoolIndex(
          {
            for (final used in ctx.usedIndexes)
              if (used >= veritaOffset) used - veritaOffset,
          },
          verita.length,
          random,
        );

        final target = ctx.players.isEmpty
            ? null
            : ctx.players[random.nextInt(ctx.players.length)].id;

        return {
          'target': target,
          'obbligo': obblighi[obbligoIndex],
          'verita': verita[veritaIndex],
          'i': obbligoIndex,
          'i2': veritaOffset + veritaIndex,
          // stesso numero di giri su tutti i telefoni
          'turns': 4 + random.nextInt(2),
        };
      },
      votingBuilder: (context, state) => _Turn(state: state, t: t),
      resultBuilder: (context, state) => _Result(state: state, t: t),
    );
  }
}

class _Turn extends StatefulWidget {
  const _Turn({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  State<_Turn> createState() => _TurnState();
}

class _TurnState extends State<_Turn> {
  // RoundGame monta la schermata sotto una chiave legata all'id del round,
  // quindi al cambio round riparte un elemento nuovo con _spinDone = false.
  bool _spinDone = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final t = widget.t;
    final text = Theme.of(context).textTheme;

    final targetId = state.content['target'] as String?;
    final target = targetId == null ? null : state.playerById(targetId);
    final isMyTurn = target != null && target.id == state.me?.id;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: BottleWheel(
              players: state.players,
              targetId: targetId,
              turns: (state.content['turns'] as num?)?.toInt() ?? 4,
              onFinished: () {
                if (mounted) setState(() => _spinDone = true);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!_spinDone)
          Text(
            t('obbligo.spinning'),
            style: text.titleMedium?.copyWith(color: JoyoColors.textSecondary),
          )
        else if (target == null)
          Text(t('common.loading'), style: text.titleMedium)
        else ...[
          Text(
            isMyTurn
                ? t('obbligo.your_turn')
                : t('obbligo.turn_of', {'name': target.name}),
            style: text.headlineMedium,
          ),
          const SizedBox(height: 16),
          if (isMyTurn)
            Row(
              children: [
                Expanded(
                  child: _ChoiceButton(
                    label: t('obbligo.dare'),
                    color: JoyoColors.coral,
                    onTap: state.hasVoted
                        ? null
                        : () => state.vote({'kind': 'obbligo'}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ChoiceButton(
                    label: t('obbligo.truth'),
                    color: JoyoColors.aqua,
                    onTap: state.hasVoted
                        ? null
                        : () => state.vote({'kind': 'verita'}),
                  ),
                ),
              ],
            )
          else
            Text(
              t('obbligo.choosing'),
              style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
            ),
        ],
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: color),
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
    final targetId = state.content['target'] as String?;
    final target = targetId == null ? null : state.playerById(targetId);
    final choice =
        state.votes
                .where((v) => v.playerId == targetId)
                .firstOrNull
                ?.value['kind']
            as String?;

    if (choice == null) {
      return Center(
        child: Text(
          target == null
              ? t('common.loading')
              : t('obbligo.no_choice', {'name': target.name}),
          textAlign: TextAlign.center,
          style: text.titleMedium?.copyWith(color: JoyoColors.textSecondary),
        ),
      );
    }

    final isObbligo = choice == 'obbligo';
    final color = isObbligo ? JoyoColors.coral : JoyoColors.aqua;
    // La frase esce nella lingua di questo telefono: l'host ha trasmesso solo
    // l'indice del pool e il tono è quello della stanza, uguale per tutti.
    final tone = state.room.mode.primaryTone;
    final task = isObbligo
        ? GameContent.obbligoText(t.locale, tone, state.content)
        : GameContent.veritaText(
            t.locale,
            tone,
            state.content,
            ObbligoOVeritaScreen.veritaOffset,
          );

    return SingleChildScrollView(
      child: Column(
        children: [
          if (target != null) ...[
            PlayerAvatar(player: target, size: 64),
            const SizedBox(height: 10),
            Text(target.name, style: text.titleLarge),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              isObbligo ? t('obbligo.dare') : t('obbligo.truth'),
              style: text.labelLarge?.copyWith(color: color),
            ),
          ),
          const SizedBox(height: 22),
          GlowCard(
            accent: color,
            glow: 1.6,
            padding: const EdgeInsets.all(24),
            child: Text(
              task,
              textAlign: TextAlign.center,
              style: text.headlineMedium?.copyWith(height: 1.3),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            t('obbligo.when_done'),
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
