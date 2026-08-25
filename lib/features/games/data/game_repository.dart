import 'package:supabase_flutter/supabase_flutter.dart';

import 'game_models.dart';

/// Scritture `async`/`await`, non espressioni: il builder di postgrest parte
/// solo se atteso, e un `onPressed: () => repo.x()` lo scarterebbe senza inviare.
class GameRepository {
  const GameRepository(this._client);

  final SupabaseClient _client;

  /// Round corrente (il più recente): deduplico per id senza fidarmi
  /// dell'ordine con cui Realtime consegna gli eventi.
  Stream<Round?> watchCurrentRound(String roomId) => _client
      .from('rounds')
      .stream(primaryKey: ['id'])
      .eq('room_id', roomId)
      .map((rows) {
        if (rows.isEmpty) return null;
        final byId = <String, Round>{};
        for (final row in rows) {
          final round = Round.fromMap(row);
          byId[round.id] = round;
        }
        final list = byId.values.toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return list.last;
      });

  Stream<List<Vote>> watchVotes(String roundId) => _client
      .from('votes')
      .stream(primaryKey: ['id'])
      .eq('round_id', roundId)
      .map((rows) {
        final byId = <String, Vote>{};
        for (final row in rows) {
          final vote = Vote.fromMap(row);
          byId[vote.id] = vote;
        }
        return byId.values.toList();
      });

  /// Prossimo numero di round chiesto al database, non alla cache locale, che
  /// dopo `start_game` può ancora contenere i round della partita precedente.
  Future<int> nextRoundNumber(String roomId) async {
    final rows = await _client
        .from('rounds')
        .select('round_number')
        .eq('room_id', roomId)
        .order('round_number', ascending: false)
        .limit(1);
    if (rows.isEmpty) return 1;
    return ((rows.first['round_number'] as num).toInt()) + 1;
  }

  /// Solo l'host. Ritorna il round creato.
  Future<Round> createRound({
    required String roomId,
    required String gameType,
    required int roundNumber,
    required Map<String, dynamic> content,
  }) async {
    final row = await _client
        .from('rounds')
        .insert({
          'room_id': roomId,
          'game_type': gameType,
          'round_number': roundNumber,
          'content': content,
        })
        .select()
        .single();
    return Round.fromMap(row);
  }

  Future<void> castVote({
    required String roundId,
    required String playerId,
    required Map<String, dynamic> value,
  }) async => await _client.from('votes').insert({
    'round_id': roundId,
    'player_id': playerId,
    'value': value,
  });

  /// Solo l'host: assegna i punti, *prima* del reveal, perché la RPC accetta
  /// solo round aperti (così resta idempotente se l'host ripete).
  Future<void> awardPoints({
    required String roundId,
    required Map<String, int> awards,
  }) async => await _client.rpc(
    'award_points',
    params: {'p_round': roundId, 'p_awards': awards},
  );

  /// Solo l'host: chiude le votazioni e mostra il risultato a tutti.
  Future<void> revealRound(String roundId) async => await _client
      .from('rounds')
      .update({'status': 'revealed'})
      .eq('id', roundId);

  /// Solo l'host: fine partita, si va al podio.
  Future<void> finishGame(String roomId) async => await _client
      .from('rooms')
      .update({'status': 'finished'})
      .eq('id', roomId);

  /// Impostore: round creato sul server, perché parola e ruolo non devono
  /// passare dal telefono dell'host (che potrebbe essere l'impostore).
  Future<void> startImpostoreRound({
    required String roomId,
    required int roundNumber,
    required String word,
    required int wordIndex,
    required int discussionSeconds,
  }) async => await _client.rpc(
    'start_impostore_round',
    params: {
      'p_room': roomId,
      'p_round_number': roundNumber,
      'p_word': word,
      'p_word_index': wordIndex,
      'p_discussion': discussionSeconds,
    },
  );

  /// Solo l'host: riscrive il contenuto del round (sostituzione AI o avanzamento fase).
  Future<void> updateContent({
    required String roundId,
    required Map<String, dynamic> content,
  }) async => await _client
      .from('rounds')
      .update({'content': content})
      .eq('id', roundId);

  /// Impostore: l'host taglia corto sulla discussione e manda tutti al voto.
  Future<void> forceVote({
    required String roundId,
    required Map<String, dynamic> content,
  }) async => await updateContent(
    roundId: roundId,
    content: {...content, 'force_vote': true},
  );

  /// Impostore: conteggio voti, punti e reveal, tutto sul server.
  Future<void> resolveImpostore(String roundId) async =>
      await _client.rpc('resolve_impostore', params: {'p_round': roundId});

  /// La parte di round destinata solo a questo giocatore (Impostore).
  Future<Map<String, dynamic>?> mySecret({
    required String roundId,
    required String playerId,
  }) async {
    final rows = await _client
        .from('round_secrets')
        .select('payload')
        .eq('round_id', roundId)
        .eq('player_id', playerId)
        .limit(1);
    if (rows.isEmpty) return null;
    return Map<String, dynamic>.from(rows.first['payload'] as Map);
  }

  /// Indici del pool già usciti in questa partita, per non ripetere domande.
  Future<Set<int>> usedPoolIndexes({
    required String roomId,
    required String gameType,
  }) async {
    final rows = await _client
        .from('rounds')
        .select('content')
        .eq('room_id', roomId)
        .eq('game_type', gameType);
    // 'i' è l'indice principale; 'i2' per i giochi a due pool (Obbligo o Verità).
    return {
      for (final row in rows)
        for (final key in const ['i', 'i2'])
          if ((row['content'] as Map?)?[key] is num)
            ((row['content'] as Map)[key] as num).toInt(),
    };
  }
}
