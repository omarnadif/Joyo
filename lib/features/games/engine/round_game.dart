import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../room/data/models/player.dart';
import '../../room/data/models/room.dart';
import '../../room/state/room_providers.dart';
import '../data/game_models.dart';
import '../data/game_repository.dart';
import '../game_catalog.dart';
import '../state/game_providers.dart';
import 'pending_vote.dart';
import '../widgets/countdown_bar.dart';
import '../widgets/game_scaffold.dart';

/// Informazioni per generare il contenuto del prossimo round.
class RoundContext {
  const RoundContext({
    required this.room,
    required this.players,
    required this.usedIndexes,
    required this.roundNumber,
    required this.repository,
  });

  final Room room;
  final List<Player> players;
  final GameRepository repository;

  /// Indici del pool già usciti in questa partita: serve a non ripetere.
  final Set<int> usedIndexes;
  final int roundNumber;
}

/// Tutto quello che serve a una schermata di gioco per disegnarsi.
class RoundGameState {
  const RoundGameState({
    required this.room,
    required this.round,
    required this.votes,
    required this.players,
    required this.me,
    required this.isHost,
    required this.myValue,
    required this.vote,
    required this.deadline,
    required this.repository,
  });

  final Room room;
  final Round round;
  final List<Vote> votes;
  final List<Player> players;
  final Player? me;
  final bool isHost;

  /// Il voto di questo telefono, già confermato dal server oppure appena
  /// toccato e in viaggio.
  final Map<String, dynamic>? myValue;

  final Future<void> Function(Map<String, dynamic> value) vote;
  final DateTime deadline;
  final GameRepository repository;

  bool get hasVoted => myValue != null;
  Map<String, dynamic> get content => round.content;

  Player? playerById(String id) => players.where((p) => p.id == id).firstOrNull;

  /// Voti raggruppati per un campo di `value` (es. 'choice').
  List<Player> votersWhere(bool Function(Vote vote) test) => [
    for (final vote in votes)
      if (test(vote)) ?playerById(vote.playerId),
  ];
}

/// Punti da assegnare al reveal: id giocatore -> punti.
typedef ScoreAwards = Map<String, int>;

/// Motore comune ai giochi a round.
///
/// Fa tre cose che prima erano sparse nelle singole schermate:
/// tiene il round corrente allineato fra tutti i telefoni, gestisce il voto
/// locale (azzerandolo al cambio di round — era il bug per cui dal secondo
/// round in poi l'opzione risultava già scelta) e, sul telefono dell'host,
/// porta avanti la partita: crea i round, chiude le votazioni quando hanno
/// votato tutti o allo scadere del tempo, assegna i punti, finisce la partita.
class RoundGame extends ConsumerStatefulWidget {
  const RoundGame({
    required this.room,
    required this.gameId,
    required this.title,
    required this.votingBuilder,
    required this.resultBuilder,
    this.accent = JoyoColors.violet,
    this.buildContent,
    this.roundCreator,
    this.votingWindow = const Duration(seconds: 20),
    this.awards,
    this.onClose,
    this.shouldClose,
    this.showVoteCounter = true,
    super.key,
  }) : assert(
         buildContent != null || roundCreator != null,
         'serve un modo per creare il round',
       );

  final Room room;
  final String gameId;
  final String title;

  /// Colore del gioco: tinge l'aurora di sfondo, i bordi e i pulsanti.
  final Color accent;

  /// Contenuto del prossimo round, generato dall'host.
  final Future<Map<String, dynamic>> Function(RoundContext context)?
  buildContent;

  /// Alternativa a [buildContent] per i giochi che creano il round lato
  /// server (Impostore: la parola segreta non deve passare dal client).
  final Future<void> Function(RoundContext context)? roundCreator;

  /// Eseguito dall'host alla chiusura del round, prima del reveal. Serve ai
  /// giochi il cui punteggio si calcola sul server.
  final Future<void> Function(RoundGameState state)? onClose;

  final Widget Function(BuildContext context, RoundGameState state)
  votingBuilder;
  final Widget Function(BuildContext context, RoundGameState state)
  resultBuilder;

  final Duration votingWindow;

  /// Punti da assegnare quando il round si chiude (null = gioco senza punti).
  final ScoreAwards Function(RoundGameState state)? awards;

  /// Quando il round può chiudersi. Di default quando hanno risposto tutti;
  /// i giochi in cui risponde una persona sola passano la propria condizione.
  final bool Function(RoundGameState state)? shouldClose;

  final bool showVoteCounter;

  @override
  ConsumerState<RoundGame> createState() => _RoundGameState();
}

class _RoundGameState extends ConsumerState<RoundGame> {
  Timer? _revealTimer;
  String? _timerRoundId;
  String? _closingRoundId;
  bool _creatingRound = false;
  int? _lastRequestedNumber;

  /// Ultimo stato visto da `_drive`: il timer di scadenza legge questo invece
  /// dello stato catturato alla sua creazione, altrimenti chiuderebbe il round
  /// con i voti fotografati al primo build (quasi sempre zero) e i giochi che
  /// assegnano punti al reveal non li darebbero mai sui round scaduti.
  RoundGameState? _latestState;

  /// Voto toccato su questo telefono e non ancora tornato dal server.
  /// È legato al round: cambiando round si azzera da solo.
  final _pending = PendingVote();

  @override
  void dispose() {
    _revealTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final t = ref.watch(tProvider);
    final players =
        ref.watch(playersProvider(room.id)).value ?? const <Player>[];
    final me = ref.watch(myPlayerProvider(room.id));
    final isHost = ref.watch(isHostProvider(room.id));

    final latest = ref.watch(currentRoundProvider(room.id)).value;
    final round = (latest != null && latest.gameType == widget.gameId)
        ? latest
        : null;

    final votes = round == null
        ? const <Vote>[]
        : ref.watch(votesProvider(round.id)).value ?? const <Vote>[];

    if (round == null) {
      // In modalità Mix il gioco cambia a ogni round: la numerazione prosegue
      // da dove l'ha lasciata il gioco precedente, non riparte da 1.
      final nextNumber = (latest?.roundNumber ?? 0) + 1;
      // Senza giocatori (lista ancora in caricamento) il round non si crea:
      // nascerebbe senza narratore/bersaglio e resterebbe morto.
      if (isHost && players.isNotEmpty) _createRound(room, players, nextNumber);
      return GameScaffold(
        title: widget.title,
        accent: widget.accent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: widget.accent),
              const SizedBox(height: 20),
              Text(t('game.preparing')),
            ],
          ),
        ),
      );
    }

    final serverVote = me == null
        ? null
        : votes.where((v) => v.playerId == me.id).firstOrNull;
    final pending = _pending.forRound(round.id);

    final state = RoundGameState(
      room: room,
      round: round,
      votes: votes,
      players: players,
      me: me,
      isHost: isHost,
      myValue: serverVote?.value ?? pending,
      vote: (value) => _vote(round, me, value),
      deadline: round.createdAt.add(widget.votingWindow),
      repository: ref.read(gameRepositoryProvider),
    );

    if (isHost) _drive(state);

    final isLastRound = round.roundNumber >= room.roundsTotal;

    return GameScaffold(
      title: widget.title,
      accent: widget.accent,
      subtitle: t('game.round_of', {
        'n': '${round.roundNumber}',
        'total': '${room.roundsTotal}',
      }),
      child: Column(
        children: [
          Expanded(
            // Il passaggio voto → risultato è il momento della schermata:
            // una sola transizione, curata, invece di tante animazioni sparse.
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey('${round.id}-${round.isRevealed}'),
                child: round.isRevealed
                    ? widget.resultBuilder(context, state)
                    : widget.votingBuilder(context, state),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (round.isRevealed)
            isHost
                ? JoyoButton(
                    accent: JoyoColors.lime,
                    label: isLastRound
                        ? t('game.see_podium')
                        : t('game.next_round'),
                    onPressed: isLastRound
                        ? () => ref
                              .read(gameRepositoryProvider)
                              .finishGame(room.id)
                        : () => _advance(room, players, round),
                  )
                : Text(
                    isLastRound ? t('game.finished') : t('game.waiting_next'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: JoyoColors.textSecondary,
                    ),
                  )
          else if (widget.showVoteCounter)
            Text(
              t('game.answered', {
                'n': '${votes.length}',
                'total': '${players.length}',
              }),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: JoyoColors.textSecondary),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- motore host

  void _drive(RoundGameState state) {
    _latestState = state;
    final round = state.round;
    if (round.isRevealed) {
      _revealTimer?.cancel();
      _timerRoundId = null;
      return;
    }

    final voters = state.votes.map((v) => v.playerId).toSet();
    final closeNow =
        widget.shouldClose?.call(state) ??
        (state.players.isNotEmpty &&
            state.players.every((p) => voters.contains(p.id)));
    if (closeNow) {
      _closeRound(state);
      return;
    }

    if (_timerRoundId != round.id) {
      _revealTimer?.cancel();
      _timerRoundId = round.id;
      final remaining = state.deadline.difference(DateTime.now().toUtc());
      _revealTimer = Timer(
        remaining.isNegative ? Duration.zero : remaining,
        () {
          final latest = _latestState;
          if (latest != null && latest.round.id == round.id) {
            _closeRound(latest);
          }
        },
      );
    }
  }

  /// Avanti di un round. In Mix cambia anche gioco: basta cambiare
  /// `active_game`, il nuovo schermo crea il round proseguendo la numerazione.
  Future<void> _advance(Room room, List<Player> players, Round round) async {
    if (room.mode.rotatesGames) {
      final next = GameCatalog.randomPlayable(exclude: widget.gameId);
      await ref
          .read(roomRepositoryProvider)
          .setActiveGame(roomId: room.id, gameType: next.id);
      return;
    }
    await _createRound(room, players, round.roundNumber + 1);
  }

  Future<void> _createRound(Room room, List<Player> players, int number) async {
    if (_creatingRound) return;
    // Fra la creazione del round e il suo arrivo via Realtime passa qualche
    // decina di millisecondi: senza questo controllo una ricostruzione in
    // mezzo creerebbe lo stesso round due volte.
    if (_lastRequestedNumber != null && number <= _lastRequestedNumber!) return;
    _lastRequestedNumber = number;
    _creatingRound = true;
    try {
      final repo = ref.read(gameRepositoryProvider);
      // Il numero vero lo dice il database: `latest` può essere un round della
      // partita precedente, già cancellato da start_game ma non ancora
      // scomparso dalla cache locale.
      final actualNumber = await repo.nextRoundNumber(room.id);
      final used = await repo.usedPoolIndexes(
        roomId: room.id,
        gameType: widget.gameId,
      );
      final context = RoundContext(
        room: room,
        players: players,
        usedIndexes: used,
        roundNumber: actualNumber,
        repository: repo,
      );

      if (widget.roundCreator case final creator?) {
        await creator(context);
      } else {
        final content = await widget.buildContent!(context);
        await repo.createRound(
          roomId: room.id,
          gameType: widget.gameId,
          roundNumber: actualNumber,
          content: content,
        );
      }
    } catch (e) {
      _snack(_t('game.create_failed', {'detail': '$e'}));
      // Piccola pausa prima di riarmare il tentativo: senza, un errore
      // persistente farebbe girare a vuoto crea → fallisci → ricrea.
      await Future<void>.delayed(const Duration(seconds: 2));
      _lastRequestedNumber = null;
    } finally {
      _creatingRound = false;
    }
  }

  /// Assegna i punti (se il gioco ne ha) e poi svela: in quest'ordine, perché
  /// la RPC dei punti accetta solo round ancora aperti.
  Future<void> _closeRound(RoundGameState state) async {
    if (_closingRoundId == state.round.id) return;
    _closingRoundId = state.round.id;
    try {
      final repo = ref.read(gameRepositoryProvider);
      final awards = widget.awards?.call(state);
      if (awards != null && awards.isNotEmpty) {
        await repo.awardPoints(roundId: state.round.id, awards: awards);
      }
      // I giochi che calcolano i punti sul server svelano da soli il round.
      if (widget.onClose case final onClose?) {
        await onClose(state);
      } else {
        await repo.revealRound(state.round.id);
      }
    } catch (e) {
      _closingRoundId = null;
      _snack(_t('game.close_failed', {'detail': '$e'}));
    }
  }

  Future<void> _vote(
    Round round,
    Player? me,
    Map<String, dynamic> value,
  ) async {
    if (me == null) return;
    setState(() => _pending.set(round.id, value));
    try {
      await ref
          .read(gameRepositoryProvider)
          .castVote(roundId: round.id, playerId: me.id, value: value);
    } catch (e) {
      // Si azzera solo il voto di questo round: se nel frattempo il round è
      // cambiato, il voto in sospeso appartiene già a quello nuovo.
      if (mounted) setState(() => _pending.clearRound(round.id));
      _snack(_t('game.vote_failed', {'detail': '$e'}));
    }
  }

  String _t(String key, Map<String, String> args) =>
      ref.read(tProvider)(key, args);

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Barra del tempo, da mettere in cima alle schermate di voto.
class RoundCountdown extends StatelessWidget {
  const RoundCountdown({required this.state, super.key});

  final RoundGameState state;

  @override
  Widget build(BuildContext context) => CountdownBar(
    deadline: state.deadline,
    total: state.deadline.difference(state.round.createdAt),
  );
}
