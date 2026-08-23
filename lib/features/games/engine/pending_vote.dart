/// Il voto appena toccato su questo telefono, non ancora confermato dal
/// server. Serve a evidenziare subito la scelta senza aspettare la rete.
///
/// È legato all'id del round di proposito: quando arriva il round successivo
/// la scelta non vale più. Tenerla slegata è stato un bug reale — dal secondo
/// round in poi l'opzione risultava già scelta e il voto non partiva.
class PendingVote {
  String? _roundId;
  Map<String, dynamic>? _value;

  void set(String roundId, Map<String, dynamic> value) {
    _roundId = roundId;
    _value = value;
  }

  void clear() {
    _roundId = null;
    _value = null;
  }

  /// Azzera il voto solo se riguarda il round indicato: un errore arrivato
  /// dopo il cambio round non deve cancellare il voto del round nuovo.
  void clearRound(String roundId) {
    if (_roundId == roundId) clear();
  }

  /// Il voto in sospeso, ma solo se riguarda il round richiesto.
  Map<String, dynamic>? forRound(String roundId) =>
      _roundId == roundId ? _value : null;
}
