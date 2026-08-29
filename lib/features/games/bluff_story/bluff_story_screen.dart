import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/app_locale.dart';
import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/player.dart';
import '../../room/data/models/room.dart';
import '../../room/state/room_providers.dart';
import '../content/game_content.dart';
import '../data/game_models.dart';
import '../engine/pool_picker.dart';
import '../engine/round_game.dart';
import '../widgets/player_chip.dart';

/// Bluff Story: a turno un giocatore scrive un fatto vero su di sé, il gioco
/// aggiunge due bugie plausibili e gli altri indovinano quale sia il vero.
///
/// Punti: 2 a chi indovina, 1 al narratore per ogni persona che ha ingannato.
class BluffStoryScreen extends ConsumerStatefulWidget {
  const BluffStoryScreen({required this.room, super.key});

  static const String gameId = 'bluff_story';
  static const Color accent = JoyoColors.amber;
  static const Duration turnWindow = Duration(seconds: 120);

  final Room room;

  @override
  ConsumerState<BluffStoryScreen> createState() => _BluffStoryScreenState();
}

class _BluffStoryScreenState extends ConsumerState<BluffStoryScreen> {
  /// Avviso lingue miste già mostrato: una volta sola per apertura del gioco.
  bool _multilangWarned = false;

  /// Con lingue diverse al tavolo la verità (testo libero) stona rispetto alle
  /// bugie tradotte: meglio dirlo subito, appena si apre il gioco.
  void _maybeWarnMultilang(List<Player> players, Translator t) {
    if (_multilangWarned || players.length < 2) return;
    final locales = players.map((p) => p.locale).toSet();
    if (locales.length < 2) return;
    _multilangWarned = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: JoyoColors.surfaceHigh,
          title: Text(t('bluff.multilang_title')),
          content: Text(t('bluff.multilang_body')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t('common.continue')),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);
    final players = ref.watch(playersProvider(room.id)).value;
    if (players != null) _maybeWarnMultilang(players, t);

    return RoundGame(
      room: room,
      gameId: BluffStoryScreen.gameId,
      accent: BluffStoryScreen.accent,
      title: t('bluff.name'),
      votingWindow: BluffStoryScreen.turnWindow,
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
        };
      },
      votingBuilder: (context, state) => _Playing(state: state, t: t),
      resultBuilder: (context, state) => _Result(state: state, t: t),
    );
  }
}

/// Il testo vero, scritto dal narratore (arriva come suo "voto").
String? _truthOf(RoundGameState state) {
  final teller = state.content['teller'] as String?;
  if (teller == null) return null;
  final vote = state.votes.where((v) => v.playerId == teller).firstOrNull;
  final truth = vote?.value['truth'] as String?;
  return (truth != null && truth.trim().isNotEmpty) ? truth.trim() : null;
}

/// Hash stabile su tutte le piattaforme: String.hashCode non lo è e qui
/// l'ordine delle tre frasi deve venire identico su ogni telefono.
int _stableHash(String value) {
  var hash = 7;
  for (final unit in value.codeUnits) {
    hash = (hash * 31 + unit) & 0x1fffffff;
  }
  return hash;
}

/// L'ordine delle tre affermazioni, identico su ogni telefono.
///
/// Si calcola sulle CHIAVI (truth/fake1/fake2), non sui testi: le bugie del
/// pool escono a ogni telefono nella propria lingua, e un ordine basato sul
/// testo divergerebbe tra i telefoni facendo puntare i voti alla frase sbagliata.
List<String> _orderedKeys(RoundGameState state) =>
    <String>['truth', 'fake1', 'fake2']..sort(
      (a, b) => _stableHash(
        state.round.id + a,
      ).compareTo(_stableHash(state.round.id + b)),
    );

/// Posizione della verità nell'ordine comune (per i punti, non serve la lingua).
int _truthIndex(RoundGameState state) => _orderedKeys(state).indexOf('truth');

/// Testo di un'affermazione nella lingua di chi guarda: le bugie del pool si
/// localizzano per indice (i pool sono allineati 1:1 tra le lingue). La verità
/// è testo libero del narratore.
String _statementText(
  RoundGameState state,
  AppLocale locale,
  String key,
  String truth,
) {
  if (key == 'truth') return truth;
  final fallback = state.content[key] as String? ?? '';
  final pool = GameContent.bluffFakes(locale);
  final i = (state.content[key == 'fake1' ? 'i' : 'i2'] as num?)?.toInt();
  return (i != null && i >= 0 && i < pool.length) ? pool[i] : fallback;
}

/// Le tre affermazioni nell'ordine in cui le vede tutto il gruppo.
List<({String key, String text})> _statements(
  RoundGameState state,
  AppLocale locale,
  String truth,
) => [
  for (final key in _orderedKeys(state))
    (key: key, text: _statementText(state, locale, key, truth)),
];

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

  final truthIndex = _truthIndex(state);
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

class _Playing extends StatelessWidget {
  const _Playing({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  Widget build(BuildContext context) {
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

    final statements = _statements(state, t.locale, truth);
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
                text: statement.text,
                highlighted: statement.key == 'truth',
                label: statement.key == 'truth' ? t('bluff.your_truth') : null,
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
                    text: statements[i].text,
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
    if (value.length < 30) {
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

    final statements = _statements(state, t.locale, truth);
    final truthIndex = _truthIndex(state);
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
              text: statements[i].text,
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
