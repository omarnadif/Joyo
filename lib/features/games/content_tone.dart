/// Tono dei contenuti, scelto dall'host per la stanza.
class ContentTone {
  const ContentTone._();

  static const String soft = 'soft';
  static const String piccante = 'piccante';
  static const String cattivo = 'cattivo';

  static const List<String> all = <String>[soft, piccante, cattivo];

  /// Un tono più alto include anche i contenuti dei toni più bassi.
  static bool allows(String roomTone, String itemTone) => switch (roomTone) {
    soft => itemTone == soft,
    piccante => itemTone == soft || itemTone == piccante,
    _ => true,
  };

  /// Indici degli elementi utilizzabili con il tono della stanza.
  static List<int> indexesFor<T>(
    List<T> items,
    String roomTone,
    String Function(T item) toneOf,
  ) => [
    for (var i = 0; i < items.length; i++)
      if (allows(roomTone, toneOf(items[i]))) i,
  ];
}
