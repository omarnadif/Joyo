import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../data/models/player.dart';
import '../data/models/room.dart';
import '../data/room_repository.dart';

final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => RoomRepository(ref.watch(supabaseProvider)),
);

/// Stanza in cui si trova questo dispositivo (null = siamo nella home).
class RoomSessionNotifier extends Notifier<RoomSession?> {
  @override
  RoomSession? build() => null;

  void enter(RoomSession session) => state = session;

  void exit() => state = null;
}

final roomSessionProvider = NotifierProvider<RoomSessionNotifier, RoomSession?>(
  RoomSessionNotifier.new,
);

/// Giocatori della stanza in tempo reale; `autoDispose` chiude il canale
/// Realtime all'uscita, evitando lista stantia al rientro e websocket appesi.
final playersProvider = StreamProvider.autoDispose.family<List<Player>, String>(
  (ref, roomId) => ref.watch(roomRepositoryProvider).watchPlayers(roomId),
);

/// Stato della stanza, aggiornato in tempo reale.
final roomProvider = StreamProvider.autoDispose.family<Room?, String>(
  (ref, roomId) => ref.watch(roomRepositoryProvider).watchRoom(roomId),
);

/// Il giocatore che sta usando questo telefono.
final myPlayerProvider = Provider.autoDispose.family<Player?, String>((
  ref,
  roomId,
) {
  final session = ref.watch(roomSessionProvider);
  final players = ref.watch(playersProvider(roomId)).value;
  if (session == null || players == null) return null;
  for (final player in players) {
    if (player.id == session.playerId) return player;
  }
  return null;
});

/// True se questo telefono è quello dell'host.
final isHostProvider = Provider.autoDispose.family<bool, String>(
  (ref, roomId) => ref.watch(myPlayerProvider(roomId))?.isHost ?? false,
);
