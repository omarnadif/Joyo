import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/player.dart';
import 'models/room.dart';

/// Riferimento alla stanza in cui si trova questo dispositivo.
class RoomSession {
  const RoomSession({
    required this.roomId,
    required this.code,
    required this.playerId,
  });

  final String roomId;
  final String code;
  final String playerId;
}

/// Errore mostrabile all'utente: porta una chiave di traduzione, non una
/// frase, così il messaggio esce nella lingua scelta dal gruppo.
class RoomException implements Exception {
  const RoomException(this.messageKey, [this.detail]);

  factory RoomException.fromPostgrest(PostgrestException e) {
    final raw = e.message;
    if (raw.contains('ROOM_NOT_FOUND')) {
      return const RoomException('error.room_not_found');
    }
    if (raw.contains('ROOM_FULL')) {
      return const RoomException('error.room_full');
    }
    if (raw.contains('ROOM_FINISHED')) {
      return const RoomException('error.room_finished');
    }
    if (raw.contains('AUTH_REQUIRED')) {
      return const RoomException('error.connection');
    }
    return RoomException('error.connection', raw);
  }

  final String messageKey;
  final String? detail;

  @override
  String toString() => detail ?? messageKey;
}

/// Scritture `async`/`await` così partono anche quando il chiamante non
/// attende il risultato (i bottoni della lobby).
class RoomRepository {
  const RoomRepository(this._client);

  final SupabaseClient _client;

  Future<RoomSession> createRoom({
    required String name,
    required String color,
  }) => _rpcSession('create_room', {'p_name': name, 'p_color': color});

  Future<RoomSession> joinRoom({
    required String code,
    required String name,
    required String color,
  }) => _rpcSession('join_room', {
    'p_code': code.toUpperCase(),
    'p_name': name,
    'p_color': color,
  });

  Future<RoomSession> _rpcSession(
    String fn,
    Map<String, dynamic> params,
  ) async {
    try {
      final rows = await _client.rpc(fn, params: params) as List<dynamic>;
      if (rows.isEmpty) throw const RoomException('error.connection');
      final row = rows.first as Map<String, dynamic>;
      return RoomSession(
        roomId: row['room_id'] as String,
        code: row['room_code'] as String,
        playerId: row['player_id'] as String,
      );
    } on PostgrestException catch (e) {
      throw RoomException.fromPostgrest(e);
    }
  }

  /// Lista giocatori in tempo reale, in ordine di ingresso: deduplico per id
  /// perché Realtime può rimandare l'INSERT di una riga già nello snapshot.
  Stream<List<Player>> watchPlayers(String roomId) => _client
      .from('players')
      .stream(primaryKey: ['id'])
      .eq('room_id', roomId)
      .map((rows) {
        final byId = <String, Player>{};
        for (final row in rows) {
          final player = Player.fromMap(row);
          byId[player.id] = player;
        }
        return byId.values.toList()
          ..sort((a, b) => a.joinedAt.compareTo(b.joinedAt));
      });

  /// Stato della stanza in tempo reale: fa cambiare schermata a tutti insieme.
  Stream<Room?> watchRoom(String roomId) => _client
      .from('rooms')
      .stream(primaryKey: ['id'])
      .eq('id', roomId)
      .map((rows) => rows.isEmpty ? null : Room.fromMap(rows.first));

  /// Solo l'host: lancia un gioco per la stanza. Via RPC perché avviare una
  /// partita sono tre scritture atomiche (pulisci round, azzera punti, stato).
  Future<void> startGame({
    required String roomId,
    required String gameType,
  }) async => await _client.rpc(
    'start_game',
    params: {'p_room': roomId, 'p_game': gameType},
  );

  /// Solo l'host: modalità e numero di round della partita.
  Future<void> updateSettings({
    required String roomId,
    String? mode,
    String? tone,
    int? roundsTotal,
  }) async => await _client
      .from('rooms')
      .update({'mode': ?mode, 'tone': ?tone, 'rounds_total': ?roundsTotal})
      .eq('id', roomId);

  /// Solo l'host: cambia gioco senza toccare i round giocati (modalità Mix).
  Future<void> setActiveGame({
    required String roomId,
    required String gameType,
  }) async => await _client
      .from('rooms')
      .update({'active_game': gameType})
      .eq('id', roomId);

  /// Solo l'host: riporta tutti in lobby.
  Future<void> backToLobby(String roomId) async => await _client
      .from('rooms')
      .update({'status': 'lobby', 'active_game': null})
      .eq('id', roomId);

  Future<void> leaveRoom(String playerId) async =>
      await _client.from('players').delete().eq('id', playerId);

  /// Solo l'host: chiude la stanza per tutti; il delete della riga `rooms`
  /// cancella in cascata i giocatori, così ogni client capisce che è finita.
  Future<void> closeRoom(String roomId) async =>
      await _client.from('rooms').delete().eq('id', roomId);
}
