/// Catalogo avatar giocatore: personas flat (SVG in assets/avatars/).
/// La chiave è il valore salvato in `players.avatar`; l'ordine è quello
/// mostrato nel picker della join. 10 archetipi, 5 coppie uomo/donna,
/// incarnati e capigliature diverse per rappresentare più etnie.
class AvatarCatalog {
  const AvatarCatalog._();

  static const List<String> keys = <String>[
    'old_m',
    'old_f',
    'blonde_m',
    'blonde_f',
    'tan_m',
    'tan_f',
    'dark_m',
    'dark_f',
    'asian_m',
    'asian_f',
  ];

  /// Avatar di ripiego per righe vecchie o valori sconosciuti.
  static const String fallback = 'tan_m';

  /// Percorso asset dell'SVG per una chiave; se la chiave non esiste
  /// (client disallineato) ripiega su [fallback] così non resta un buco.
  static String asset(String key) {
    final k = keys.contains(key) ? key : fallback;
    return 'assets/avatars/$k.svg';
  }
}
