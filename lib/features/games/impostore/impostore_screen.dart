import 'dart:async';
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
import '../state/game_providers.dart';
import '../widgets/countdown_bar.dart';
import '../widgets/player_chip.dart';

/// Impostore: tutti ricevono la stessa parola segreta tranne uno, che deve
/// fingere di saperla.
///
/// La parola non passa mai dal telefono dell'host (potrebbe essere lui
/// l'impostore): round e punteggio li gestisce il server e ogni giocatore
/// legge solo la propria riga di segreto.
class ImpostoreScreen extends ConsumerWidget {
  const ImpostoreScreen({required this.room, super.key});

  static const String gameId = 'impostore';
  static const Color accent = JoyoColors.magenta;
  static const int discussionSeconds = 90;
  static const Duration voteWindow = Duration(minutes: 5);

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);

    return RoundGame(
      room: room,
      gameId: gameId,
      accent: accent,
      title: t('impostore.name'),
      votingWindow: voteWindow,
      showVoteCounter: false,
      roundCreator: (ctx) async {
        final words = GameContent.impostoreWords(locale);
        final index = pickPoolIndex(ctx.usedIndexes, words.length, Random());
        await ctx.repository.startImpostoreRound(
          roomId: ctx.room.id,
          roundNumber: ctx.roundNumber,
          word: words[index],
          wordIndex: index,
          discussionSeconds: discussionSeconds,
        );
      },
      onClose: (state) async =>
          state.repository.resolveImpostore(state.round.id),
      votingBuilder: (context, state) => _Playing(state: state, t: t),
      resultBuilder: (context, state) => _Result(state: state, t: t),
    );
  }
}

enum _Phase { secret, discussion, vote }

class _Playing extends ConsumerStatefulWidget {
  const _Playing({required this.state, required this.t});

  final RoundGameState state;
  final Translator t;

  @override
  ConsumerState<_Playing> createState() => _PlayingState();
}

class _PlayingState extends ConsumerState<_Playing> {
  Timer? _ticker;
  final _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _guessController.dispose();
    super.dispose();
  }

  _Phase _phase(RoundGameState state) {
    if (state.content['force_vote'] == true) return _Phase.vote;
    final elapsed = DateTime.now().toUtc().difference(state.round.createdAt);
    final secret = Duration(
      seconds: (state.content['secret_seconds'] as num?)?.toInt() ?? 12,
    );
    final discussion = Duration(
      seconds:
          (state.content['discussion_seconds'] as num?)?.toInt() ??
          ImpostoreScreen.discussionSeconds,
    );
    if (elapsed < secret) return _Phase.secret;
    if (elapsed < secret + discussion) return _Phase.discussion;
    return _Phase.vote;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final t = widget.t;
    final me = state.me;
    if (me == null) return Center(child: Text(t('lobby.room_closed')));

    final secret = ref
        .watch(mySecretProvider((roundId: state.round.id, playerId: me.id)))
        .value;
    final phase = _phase(state);

    return switch (phase) {
      _Phase.secret => _SecretCard(secret: secret, t: t),
      _Phase.discussion => _Discussion(state: state, secret: secret, t: t),
      _Phase.vote => _Vote(
        state: state,
        secret: secret,
        guessController: _guessController,
        t: t,
      ),
    };
  }
}

class _SecretCard extends StatelessWidget {
  const _SecretCard({required this.secret, required this.t});

  final Map<String, dynamic>? secret;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    if (secret == null) {
      return const Center(
        child: CircularProgressIndicator(color: JoyoColors.lime),
      );
    }

    final isImpostor = secret!['impostor'] == true;
    final word = secret!['word'] as String?;

    final accent = isImpostor ? JoyoColors.coral : JoyoColors.lime;

    return Center(
      child: RiseIn(
        child: GlowCard(
          accent: accent,
          glow: 2,
          borderWidth: 2,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Eyebrow(t('impostore.only_you')),
              const SizedBox(height: 16),
              if (isImpostor) ...[
                const Icon(
                  Icons.visibility_off_rounded,
                  size: 46,
                  color: JoyoColors.coral,
                ),
                const SizedBox(height: 14),
                Text(
                  t('impostore.you_are'),
                  style: text.displayMedium?.copyWith(color: JoyoColors.coral),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  t('impostore.you_are_body'),
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ] else ...[
                Text(
                  t('impostore.the_word'),
                  style: text.titleMedium?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  word ?? '—',
                  textAlign: TextAlign.center,
                  style: text.displayMedium?.copyWith(color: JoyoColors.lime),
                ),
                const SizedBox(height: 12),
                Text(
                  t('impostore.one_doesnt'),
                  style: text.bodyMedium?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Discussion extends ConsumerWidget {
  const _Discussion({
    required this.state,
    required this.secret,
    required this.t,
  });

  final RoundGameState state;
  final Map<String, dynamic>? secret;
  final Translator t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final isImpostor = secret?['impostor'] == true;
    final secretSeconds =
        (state.content['secret_seconds'] as num?)?.toInt() ?? 12;
    final discussionSeconds =
        (state.content['discussion_seconds'] as num?)?.toInt() ??
        ImpostoreScreen.discussionSeconds;
    final deadline = state.round.createdAt.add(
      Duration(seconds: secretSeconds + discussionSeconds),
    );

    return Column(
      children: [
        CountdownBar(
          deadline: deadline,
          total: Duration(seconds: discussionSeconds),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t('impostore.round_of_words'), style: text.headlineMedium),
                const SizedBox(height: 12),
                Text(
                  t('impostore.round_of_words_body'),
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: JoyoColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                GlowCard(
                  accent: isImpostor ? JoyoColors.coral : JoyoColors.lime,
                  glow: 1.4,
                  radius: 18,
                  borderWidth: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Text(
                    isImpostor
                        ? t('impostore.you_are')
                        : t('impostore.your_word', {
                            'word': '${secret?['word'] ?? '—'}',
                          }),
                    style: text.titleMedium?.copyWith(
                      color: isImpostor ? JoyoColors.coral : JoyoColors.lime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.isHost)
          JoyoGhostButton(
            label: t('impostore.to_vote'),
            onPressed: () => ref
                .read(gameRepositoryProvider)
                .forceVote(roundId: state.round.id, content: state.content),
          ),
      ],
    );
  }
}

class _Vote extends StatefulWidget {
  const _Vote({
    required this.state,
    required this.secret,
    required this.guessController,
    required this.t,
  });

  final RoundGameState state;
  final Map<String, dynamic>? secret;
  final TextEditingController guessController;
  final Translator t;

  @override
  State<_Vote> createState() => _VoteState();
}

class _VoteState extends State<_Vote> {
  String? _suspect;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final t = widget.t;
    final text = Theme.of(context).textTheme;
    final isImpostor = widget.secret?['impostor'] == true;
    final myVote = state.myValue;
    final chosen = myVote?['suspect'] as String? ?? _suspect;

    if (myVote != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.how_to_vote_rounded,
              size: 46,
              color: JoyoColors.violet,
            ),
            const SizedBox(height: 16),
            Text(t('impostore.vote_registered'), style: text.titleLarge),
            const SizedBox(height: 8),
            Text(
              t('game.answered', {
                'n': '${state.votes.length}',
                'total': '${state.players.length}',
              }),
              style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Text(t('impostore.who'), style: text.headlineMedium),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            children: [
              for (final player in state.players)
                if (player.id != state.me?.id)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _suspect = player.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: chosen == player.id
                              ? JoyoColors.coral.withValues(alpha: 0.18)
                              : JoyoColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: chosen == player.id
                                ? JoyoColors.coral
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            PlayerAvatar(player: player),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(player.name, style: text.titleMedium),
                            ),
                            if (chosen == player.id)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: JoyoColors.coral,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              if (isImpostor) ...[
                const SizedBox(height: 6),
                Text(
                  t('impostore.guess_body'),
                  style: text.bodySmall?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: widget.guessController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: t('impostore.guess_hint'),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        JoyoButton(
          accent: JoyoColors.magenta,
          label: t('impostore.confirm'),
          onPressed: chosen == null
              ? null
              : () => state.vote({
                  'suspect': chosen,
                  if (isImpostor) 'guess': widget.guessController.text.trim(),
                }),
        ),
      ],
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
    final impostorId = state.content['impostor'] as String?;
    final impostor = impostorId == null ? null : state.playerById(impostorId);
    final word = state.content['word'] as String?;
    final caught = state.content['caught'] == true;
    final guessOk = state.content['guess_ok'] == true;
    final guess = state.content['guess'] as String?;

    // Il voto dell'impostore va escluso dal conteggio come fa il server,
    // altrimenti il risultato mostrato sembra sbagliato (smascherato Ada ma
    // Bruno risulta il più votato).
    final counts = <String, int>{};
    for (final vote in state.votes) {
      if (vote.playerId == impostorId) continue;
      final suspect = vote.value['suspect'] as String?;
      if (suspect != null) counts[suspect] = (counts[suspect] ?? 0) + 1;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            caught ? t('impostore.caught') : t('impostore.escaped'),
            textAlign: TextAlign.center,
            style: text.headlineMedium?.copyWith(
              color: caught ? JoyoColors.lime : JoyoColors.coral,
            ),
          ),
          const SizedBox(height: 20),
          if (impostor != null) ...[
            PlayerAvatar(player: impostor, size: 64),
            const SizedBox(height: 8),
            Text(impostor.name, style: text.titleLarge),
          ],
          const SizedBox(height: 18),
          GlowCard(
            accent: JoyoColors.lime,
            glow: 1.4,
            child: Column(
              children: [
                Eyebrow(t('impostore.word_was')),
                const SizedBox(height: 8),
                Text(
                  word ?? '—',
                  style: text.headlineMedium?.copyWith(color: JoyoColors.lime),
                ),
                if (guess != null && guess.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    guessOk
                        ? t('impostore.guessed_it', {'guess': guess})
                        : t('impostore.said', {'guess': guess}),
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: guessOk
                          ? JoyoColors.aqua
                          : JoyoColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            caught
                ? t('impostore.points_caught')
                : t('impostore.points_escaped'),
            style: text.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
          ),
          const SizedBox(height: 18),
          for (final player in state.players)
            if ((counts[player.id] ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(player.name, style: text.bodyMedium)),
                    Text(
                      t.n('impostore.votes', counts[player.id] ?? 0),
                      style: text.bodySmall?.copyWith(
                        color: player.id == impostorId
                            ? JoyoColors.coral
                            : JoyoColors.textSecondary,
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
