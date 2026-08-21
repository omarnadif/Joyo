import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../data/game_models.dart';
import '../data/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepository(ref.watch(supabaseProvider)),
);

/// Round corrente della stanza, in tempo reale.
final currentRoundProvider = StreamProvider.family<Round?, String>(
  (ref, roomId) => ref.watch(gameRepositoryProvider).watchCurrentRound(roomId),
);

/// Voti del round, in tempo reale.
final votesProvider = StreamProvider.family<List<Vote>, String>(
  (ref, roundId) => ref.watch(gameRepositoryProvider).watchVotes(roundId),
);

/// La parte segreta del round destinata a questo giocatore (Impostore).
/// Ritenta finché non c'è: le righe dei segreti vengono create subito dopo il
/// round, quindi al primo tentativo possono ancora non esserci.
final mySecretProvider =
    FutureProvider.family<Map<String, dynamic>?, ({String roundId, String playerId})>(
      (ref, key) async {
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
      },
    );
