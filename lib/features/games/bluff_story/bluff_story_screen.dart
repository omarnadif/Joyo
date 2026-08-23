import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../premium/ai_content_repository.dart';
import '../../room/data/models/room.dart';
import '../content/game_content.dart';
import '../data/game_models.dart';
import '../engine/pool_picker.dart';
import '../engine/round_game.dart';
import '../widgets/player_chip.dart';

/// Bluff Story: a turno un giocatore scrive un fatto vero su di sé, il gioco
/// ci mette in mezzo due bugie plausibili e gli altri devono indovinare qual è
/// quello vero.
///
/// Punti: 2 a chi indovina, 1 al narratore per ogni persona che ha ingannato.
class BluffStoryScreen extends ConsumerWidget {
  const BluffStoryScreen({required this.room, super.key});

  static const String gameId = 'bluff_story';
  static const Color accent = JoyoColors.amber;
  static const Duration turnWindow = Duration(seconds: 120);

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('bluff.name'),
      votingWindow: turnWindow,
      showVoteCounter: false,
      shouldClose: _everyoneAnswered,
      awards: _awards,
      buildContent: (ctx) async {
        final random = Random();
        final fakes = GameContent.bluffFakes(locale);
        final first = pickPoolIndex(ctx.usedIndexes, fakes.length, random);
        final second = pickPoolIndex(
          {...ctx.usedIndexes, first},
          fakes.length,
          random,
        );
        // Il narratore ruota: al round 1 il primo entrato, poi a scalare.
        final teller = ctx.players.isEmpty
            ? null
            : ctx.players[(ctx.roundNumber - 1) % ctx.players.length].id;

        return {
          'teller': teller,
          'fake1': fakes[first],
          'fake2': fakes[second],
          'i': first,
          'i2': second,
          // Con l'AI le bugie vengono riscritte sul testo vero appena
          // arriva: finché la chiave manca, il round è "in preparazione".
          if (!ctx.room.canUseAi) 'ai': false,
        };
      },
      votingBuilder: (context, state) => _Playing(state: state, t: t),
      resultBuilder: (context, state) => _Result(state: state, t: t),
    );
  }
}

// --------------------------------------------------------------------- logica

/// Il testo vero, scritto dal narratore (arriva come suo "voto").
String? _truthOf(RoundGameState state) {
  final teller = state.content['teller'] as String?;
  if (teller == null) return null;
  final vote = state.votes.where((v) => v.playerId == teller).firstOrNull;
  final truth = vote?.value['truth'] as String?;
  return (truth != null && truth.trim().isNotEmpty) ? truth.trim() : null;
}

/// Hash stabile su tutte le piattaforme: String.hashCode non lo è, e qui
/// l'ordine delle tre frasi deve venire identico su ogni telefono.
int _stableHash(String value) {
  var hash = 7;
  for (final unit in value.codeUnits) {
    hash = (hash * 31 + unit) & 0x1fffffff;
  }
  return hash;
}

/// Le tre affermazioni nell'ordine in cui le vede tutto il gruppo.
List<String> _statements(RoundGameState state, String truth) {
  final items = <String>[
    truth,
    state.content['fake1'] as String? ?? '',
    state.content['fake2'] as String? ?? '',
  ];
  items.sort(
    (a, b) => _stableHash(
      state.round.id + a,
    ).compareTo(_stableHash(state.round.id + b)),
  );
  return items;
}

bool _everyoneAnswered(RoundGameState state) {
  final teller = state.content['teller'] as String?;
  if (teller == null) return true;
  if (_truthOf(state) == null) return false;

  final answered = state.votes
      .where((v) => v.value['pick'] != null)
      .map((v) => v.playerId)
      .toSet();
  final others = state.players.where((p) => p.id != teller);
  return others.isNotEmpty && others.every((p) => answered.contains(p.id));
}

Map<String, int> _awards(RoundGameState state) {
  final teller = state.content['teller'] as String?;
  final truth = _truthOf(state);
  if (teller == null || truth == null) return const {};

  final truthIndex = _statements(state, truth).indexOf(truth);
  final result = <String, int>{};
  var fooled = 0;

  for (final vote in state.votes) {
    if (vote.playerId == teller) continue;
    final pick = vote.value['pick'];
    if (pick is num && pick.toInt() == truthIndex) {
      result[vote.playerId] = 2;
    } else if (pick != null) {
      fooled++;
    }
  }
  if (fooled > 0) result[teller] = fooled;
  return result;
}

// ----------------------------------------------------------------------- gioco

class _Playing extends ConsumerStatefulWidget {
  const _Playing({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  ConsumerState<_Playing> createState() => _PlayingState();
}

class _PlayingState extends ConsumerState<_Playing> {
  String? _upgradingRoundId;

  /// L'host sostituisce le bugie del pool con due scritte dall'AI sul testo
  /// vero. Se l'AI non risponde, marca comunque il round come "deciso" così
  /// il gioco riparte con le bugie generiche.
  Future<void> _upgradeWithAi(RoundGameState state, String truth) async {
    if (_upgradingRoundId == state.round.id) return;
    _upgradingRoundId = state.round.id;

    try {
      final fakes = await ref
          .read(aiContentRepositoryProvider)
          .bluffStoryFakes(
            roomId: state.room.id,
            truth: truth,
            tone: state.room.tone,
          );

      await state.repository.updateContent(
        roundId: state.round.id,
        content: {
          ...state.content,
          if (fakes != null) 'fake1': fakes[0],
          if (fakes != null) 'fake2': fakes[1],
          'ai': fakes != null,
        },
      );
    } catch (_) {
      // Se la scrittura fallisce il round deve comunque partire con le bugie
      // del pool: senza, tutti resterebbero sullo spinner "AI al lavoro"
      // fino allo scadere del tempo. Il guard si riarma per poter riprovare.
      _upgradingRoundId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final t = widget.t;
    final text = Theme.of(context).textTheme;
    final tellerId = state.content['teller'] as String?;
    final teller = tellerId == null ? null : state.playerById(tellerId);
    final amTeller = tellerId != null && tellerId == state.me?.id;
    final truth = _truthOf(state);

    if (teller == null) {
      return Center(child: Text(t('common.loading')));
    }

    if (truth == null) {
      return amTeller
          ? _WriteTruth(state: state, t: t)
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlayerAvatar(player: teller, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    t('bluff.writing', {'name': teller.name}),
                    textAlign: TextAlign.center,
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(color: JoyoColors.amber),
                ],
              ),
            );
    }

    // Round con AI: finché le bugie su misura non sono pronte non si vota,
    // altrimenti chi ha già scelto si ritroverebbe opzioni diverse.
    if (!state.content.containsKey('ai')) {
      if (state.isHost) {
        Future.microtask(() {
          if (mounted) _upgradeWithAi(state, truth);
        });
      }
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: JoyoColors.amber),
            const SizedBox(height: 20),
            Text(t('bluff.ai_working'), style: text.titleMedium),
            const SizedBox(height: 6),
            Text(
              t('bluff.ai_working_sub', {'name': teller.name}),
              style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final statements = _statements(state, truth);
    final myPick = (state.myValue?['pick'] as num?)?.toInt();

    if (amTeller) {
      final answered = state.votes.where((v) => v.value['pick'] != null).length;
      return Column(
        children: [
          RoundCountdown(state: state),
          const SizedBox(height: 20),
          Text(t('bluff.in_play'), style: text.titleLarge),
          const SizedBox(height: 8),
          Text(
            t('bluff.dont_tell'),
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
          ),
          const SizedBox(height: 20),
          for (final statement in statements)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _StatementCard(
                text: statement,
                highlighted: statement == truth,
                label: statement == truth ? t('bluff.your_truth') : null,
              ),
            ),
          const Spacer(),
          Text(
            t('game.answered', {
              'n': '$answered',
              'total': '${state.players.length - 1}',
            }),
            style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
          ),
        ],
      );
    }

    return Column(
      children: [
        RoundCountdown(state: state),
        const SizedBox(height: 18),
        Text(
          t('bluff.which_true', {'name': teller.name}),
          textAlign: TextAlign.center,
          style: text.titleLarge,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < statements.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _StatementCard(
                    text: statements[i],
                    selected: myPick == i,
                    dimmed: myPick != null && myPick != i,
                    onTap: state.hasVoted
                        ? null
                        : () => state.vote({'pick': i}),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WriteTruth extends StatefulWidget {
  const _WriteTruth({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  State<_WriteTruth> createState() => _WriteTruthState();
}

class _WriteTruthState extends State<_WriteTruth> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final value = _controller.text.trim();
    if (value.length < 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.t('bluff.too_short'))));
      return;
    }
    setState(() => _sending = true);
    await widget.state.vote({'truth': value});
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = widget.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RoundCountdown(state: widget.state),
        const SizedBox(height: 20),
        Text(t('obbligo.your_turn'), style: text.headlineMedium),
        const SizedBox(height: 8),
        Text(
          t('bluff.your_turn_body'),
          style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          maxLines: 4,
          maxLength: 140,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: t('bluff.hint')),
        ),
        const Spacer(),
        JoyoButton(
          accent: JoyoColors.amber,
          busy: _sending,
          label: t('bluff.send'),
          onPressed: _sending ? null : _send,
        ),
      ],
    );
  }
}

class _StatementCard extends StatelessWidget {
  const _StatementCard({
    required this.text,
    this.selected = false,
    this.dimmed = false,
    this.highlighted = false,
    this.label,
    this.onTap,
  });

  final String text;
  final bool selected;
  final bool dimmed;
  final bool highlighted;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final accent = highlighted ? JoyoColors.lime : JoyoColors.amber;

    return Opacity(
      opacity: dimmed ? 0.45 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected || highlighted
                ? accent.withValues(alpha: 0.16)
                : JoyoColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected || highlighted ? accent : JoyoColors.surfaceHigh,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Text(
                  label!.toUpperCase(),
                  style: theme.labelLarge?.copyWith(
                    fontSize: 11,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(text, style: theme.bodyLarge?.copyWith(height: 1.35)),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- risultato

class _Result extends StatelessWidget {
  const _Result({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tellerId = state.content['teller'] as String?;
    final teller = tellerId == null ? null : state.playerById(tellerId);
    final truth = _truthOf(state);

    if (truth == null || teller == null) {
      return Center(
        child: Text(
          teller == null
              ? t('common.loading')
              : t('obbligo.no_choice', {'name': teller.name}),
          textAlign: TextAlign.center,
          style: text.titleMedium?.copyWith(color: JoyoColors.textSecondary),
        ),
      );
    }

    final statements = _statements(state, truth);
    final truthIndex = statements.indexOf(truth);
    final picks = <int, List<Vote>>{};
    for (final vote in state.votes) {
      final pick = vote.value['pick'];
      if (pick is num) {
        picks.putIfAbsent(pick.toInt(), () => []).add(vote);
      }
    }
    final right = picks[truthIndex] ?? const <Vote>[];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t('bluff.truth_of', {'name': teller.name}),
            textAlign: TextAlign.center,
            style: text.titleLarge,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < statements.length; i++) ...[
            _StatementCard(
              text: statements[i],
              highlighted: i == truthIndex,
              label: i == truthIndex ? t('bluff.true_label') : null,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final vote in picks[i] ?? const <Vote>[])
                  if (state.playerById(vote.playerId) case final player?)
                    PlayerChip(player: player),
              ],
            ),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: JoyoColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  right.isEmpty
                      ? t('bluff.nobody_guessed', {'name': teller.name})
                      : t.n('bluff.guessed', right.length),
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  t('bluff.scoring', {'name': teller.name}),
                  textAlign: TextAlign.center,
                  style: text.bodySmall?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
