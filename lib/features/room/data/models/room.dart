import '../../../../core/env/app_env.dart';
import '../../../games/game_mode.dart';

enum RoomStatus {
  lobby,
  inGame,
  finished;

  static RoomStatus fromDb(String value) => switch (value) {
    'in_game' => RoomStatus.inGame,
    'finished' => RoomStatus.finished,
    _ => RoomStatus.lobby,
  };
}

/// Una stanza di gioco. È la sorgente di verità che tiene sincronizzati tutti
/// i telefoni: quando cambia `status` / `activeGame`, ogni client reagisce.
class Room {
  const Room({
    required this.id,
    required this.code,
    required this.hostId,
    required this.status,
    required this.activeGame,
    required this.isPremiumAi,
    required this.aiCredits,
    required this.tone,
    required this.mode,
    required this.roundsTotal,
  });

  factory Room.fromMap(Map<String, dynamic> map) => Room(
    id: map['id'] as String,
    code: map['code'] as String,
    hostId: map['host_id'] as String?,
    status: RoomStatus.fromDb(map['status'] as String),
    activeGame: map['active_game'] as String?,
    isPremiumAi: map['is_premium_ai'] as bool? ?? false,
    aiCredits: (map['ai_credits'] as num?)?.toInt() ?? 0,
    tone: map['tone'] as String? ?? 'soft',
    mode: GameMode.fromId(map['mode'] as String?),
    roundsTotal: (map['rounds_total'] as num?)?.toInt() ?? 10,
  );

  final String id;
  final String code;
  final String? hostId;
  final RoomStatus status;
  final String? activeGame;
  final bool isPremiumAi;

  /// Contenuti AI singoli, guadagnati guardando un annuncio.
  final int aiCredits;

  final String tone;

  /// Normale, Mix o Hot: decide contenuti e rotazione dei giochi.
  final GameMode mode;
  final int roundsTotal;

  /// Se questa stanza può usare i contenuti generati dall'AI: premium
  /// acquistato, crediti da annuncio, oppure l'interruttore di sviluppo.
  bool get canUseAi =>
      isPremiumAi || aiCredits > 0 || AppEnv.devUnlockPremium;
}
