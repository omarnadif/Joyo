import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../data/game_models.dart';
import '../data/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepository(ref.watch(supabaseProvider)),
);

/// Round corrente della stanza, in tempo reale.
///
/// `autoDispose` chiude il canale Realtime a fine partita; senza, ogni round
/// giocato lascerebbe una subscription aperta per tutta la vita dell'app.
final currentRoundProvider = StreamProvider.autoDispose.family<Round?, String>(
  (ref, roomId) => ref.watch(gameRepositoryProvider).watchCurrentRound(roomId),
);

/// Voti del round, in tempo reale.
final votesProvider = StreamProvider.autoDispose.family<List<Vote>, String>(
  (ref, roundId) => ref.watch(gameRepositoryProvider).watchVotes(roundId),
);

/// La parte segreta del round per questo giocatore (Impostore): ritenta perché
/// le righe dei segreti nascono subito dopo il round e possono non esserci ancora.
final mySecretProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, ({String roundId, String playerId})>((
      ref,
      key,
    ) async {
      final repo = ref.watch(gameRepositoryProvider);
      for (var attempt = 0; attempt < 6; attempt++) {
        final secret = await repo.mySecret(
          roundId: key.roundId,
          playerId: key.playerId,
        );
        if (secret != null) return secret;
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
      return null;
    });
