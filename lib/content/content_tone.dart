/// Tono dei contenuti, scelto dall'host per la stanza.
///
/// I tre valori coincidono con le modalità di gioco: `normal`, `mix`, `hot`.
class ContentTone {
  const ContentTone._();

  static const String normal = 'normal';
  static const String mix = 'mix';
  static const String hot = 'hot';

  static const List<String> all = <String>[normal, mix, hot];

  /// Un tono più alto include anche i contenuti dei toni più bassi.
  static bool allows(String roomTone, String itemTone) => switch (roomTone) {
    normal => itemTone == normal,
    mix => itemTone == normal || itemTone == mix,
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
