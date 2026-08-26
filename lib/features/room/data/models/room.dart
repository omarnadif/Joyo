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

/// Stanza di gioco: sorgente di verità che sincronizza i telefoni al cambio
/// di `status`/`activeGame`.
class Room {
  const Room({
    required this.id,
    required this.code,
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
    status: RoomStatus.fromDb(map['status'] as String),
    activeGame: map['active_game'] as String?,
    isPremiumAi: map['is_premium_ai'] as bool? ?? false,
    aiCredits: (map['ai_credits'] as num?)?.toInt() ?? 0,
    tone: map['tone'] as String? ?? 'normal',
    mode: GameMode.fromId(map['mode'] as String?),
    roundsTotal: (map['rounds_total'] as num?)?.toInt() ?? 10,
  );

  final String id;
  final String code;
  final RoomStatus status;
  final String? activeGame;
  final bool isPremiumAi;

  /// Contenuti AI singoli, guadagnati guardando un annuncio.
  final int aiCredits;

  final String tone;

  /// Normale, Mix o Hot: decide contenuti e rotazione dei giochi.
  final GameMode mode;
  final int roundsTotal;

  /// Se la stanza può usare l'AI: premium, crediti da annuncio o flag di sviluppo.
  bool get canUseAi => isPremiumAi || aiCredits > 0 || AppEnv.devUnlockPremium;
}
