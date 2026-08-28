/// Un giocatore dentro una stanza.
class Player {
  const Player({
    required this.id,
    required this.name,
    required this.color,
    required this.avatar,
    required this.locale,
    required this.isHost,
    required this.score,
    required this.joinedAt,
  });

  factory Player.fromMap(Map<String, dynamic> map) => Player(
    id: map['id'] as String,
    name: map['name'] as String,
    color: map['color'] as String,
    avatar: map['avatar'] as String? ?? 'tan_m',
    locale: map['locale'] as String? ?? 'en',
    isHost: map['is_host'] as bool? ?? false,
    score: (map['score'] as num?)?.toInt() ?? 0,
    joinedAt: DateTime.parse(map['joined_at'] as String),
  );

  final String id;
  final String name;
  final String color;
  final String avatar;

  /// Lingua del telefono del giocatore (codice AppLocale, es. 'it').
  final String locale;
  final bool isHost;
  final int score;
  final DateTime joinedAt;

  /// Iniziale mostrata nell'avatar.
  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}
