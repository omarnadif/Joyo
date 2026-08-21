import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/features/games/engine/pending_vote.dart';

void main() {
  test('la scelta in sospeso vale solo per il round in cui è stata fatta', () {
    final pending = PendingVote()..set('round-1', {'choice': 'a'});

    expect(pending.forRound('round-1'), {'choice': 'a'});

    // Regressione: al round successivo la scelta non deve risultare già fatta,
    // altrimenti l'opzione appare selezionata e il voto non parte mai.
    expect(pending.forRound('round-2'), isNull);
  });

  test('clear azzera la scelta', () {
    final pending = PendingVote()..set('round-1', {'choice': 'b'});
    pending.clear();
    expect(pending.forRound('round-1'), isNull);
  });
}
