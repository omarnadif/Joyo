import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Client Supabase già inizializzato in `main()`.
final supabaseProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Sessione anonima: se non esiste ancora, ne crea una.
///
/// La sessione viene persistita da supabase_flutter, quindi riaprendo l'app
/// lo stesso dispositivo resta lo stesso utente (serve per rientrare in una
/// stanza dopo un crash o un riavvio).
final anonSessionProvider = FutureProvider<Session>((ref) async {
  final client = ref.watch(supabaseProvider);

  final existing = client.auth.currentSession;
  if (existing != null) return existing;

  final response = await client.auth.signInAnonymously();
  final session = response.session;
  if (session == null) {
    throw StateError(
      'Login anonimo riuscito ma senza sessione. '
      'Controlla che "Anonymous sign-ins" sia abilitato in Supabase.',
    );
  }
  return session;
});

/// Verifica che PostgREST risponda e che le policy RLS siano attive.
/// Restituisce sempre una lista vuota: un utente senza stanze non vede righe.
final databasePingProvider = FutureProvider<int>((ref) async {
  await ref.watch(anonSessionProvider.future);
  final client = ref.watch(supabaseProvider);
  final rows = await client
      .from('rooms')
      .select('id')
      .limit(1)
      .timeout(const Duration(seconds: 10));
  return rows.length;
});

/// Verifica che il websocket Realtime si apra e accetti la sessione.
final realtimePingProvider = FutureProvider.autoDispose<String>((ref) async {
  final client = ref.watch(supabaseProvider);

  // Registrato prima dell'await: se il provider viene eliminato durante
  // l'attesa della sessione, il canale non deve né aprirsi né restare appeso.
  RealtimeChannel? channel;
  ref.onDispose(() {
    final open = channel;
    if (open != null) client.removeChannel(open);
  });

  await ref.watch(anonSessionProvider.future);
  if (!ref.mounted) throw StateError('provider dismesso durante il login');

  final completer = Completer<String>();
  final health = client.channel('joyo-health');
  channel = health;

  health.subscribe((status, error) {
    if (completer.isCompleted) return;
    switch (status) {
      case RealtimeSubscribeStatus.subscribed:
        completer.complete('Websocket connesso');
      case RealtimeSubscribeStatus.channelError:
      case RealtimeSubscribeStatus.timedOut:
      case RealtimeSubscribeStatus.closed:
        completer.completeError(error ?? 'Realtime: ${status.name}');
    }
  });

  return completer.future.timeout(
    const Duration(seconds: 15),
    onTimeout: () => throw TimeoutException('Realtime non ha risposto'),
  );
});
