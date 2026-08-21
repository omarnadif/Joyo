enum RoundStatus {
  waitingVotes,
  revealed;

  static RoundStatus fromDb(String value) =>
      value == 'revealed' ? RoundStatus.revealed : RoundStatus.waitingVotes;
}

/// Un round di gioco. `content` cambia forma a seconda del gioco:
/// per Preferisci è `{a, b, i}` (le due opzioni e l'indice nel pool).
class Round {
  const Round({
    required this.id,
    required this.roomId,
    required this.gameType,
    required this.roundNumber,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory Round.fromMap(Map<String, dynamic> map) => Round(
    id: map['id'] as String,
    roomId: map['room_id'] as String,
    gameType: map['game_type'] as String,
    roundNumber: (map['round_number'] as num).toInt(),
    content: Map<String, dynamic>.from(map['content'] as Map? ?? {}),
    status: RoundStatus.fromDb(map['status'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
  );

  final String id;
  final String roomId;
  final String gameType;
  final int roundNumber;
  final Map<String, dynamic> content;
  final RoundStatus status;
  final DateTime createdAt;

  bool get isRevealed => status == RoundStatus.revealed;
}

/// Il voto di un giocatore. `value` è jsonb: per Preferisci `{"choice": "a"}`.
class Vote {
  const Vote({
    required this.id,
    required this.roundId,
    required this.playerId,
    required this.value,
  });

  factory Vote.fromMap(Map<String, dynamic> map) => Vote(
    id: map['id'] as String,
    roundId: map['round_id'] as String,
    playerId: map['player_id'] as String,
    value: Map<String, dynamic>.from(map['value'] as Map? ?? {}),
  );

  final String id;
  final String roundId;
  final String playerId;
  final Map<String, dynamic> value;

  String? get choice => value['choice'] as String?;
}
