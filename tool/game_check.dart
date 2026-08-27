// Verifica il ciclo di gioco della Fase 3 con due giocatori veri:
// avvio partita -> round -> voti -> reveal, controllando che ogni evento
// arrivi all'altro telefono e che le regole reggano.
//
//   dart run tool/game_check.dart <SUPABASE_URL> <ANON_KEY>

import 'dart:async';
import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Uso: dart run tool/game_check.dart <URL> <ANON_KEY>');
    exit(64);
  }

  final host = SupabaseClient(args[0], args[1]);
  final guest = SupabaseClient(args[0], args[1]);

  var failures = 0;
  void check(String label, bool ok, [String detail = '']) {
    stdout.writeln(
      '${ok ? 'OK  ' : 'FAIL'}  $label${detail.isEmpty ? '' : ' — $detail'}',
    );
    if (!ok) failures++;
  }

  try {
    await host.auth.signInAnonymously();
    await guest.auth.signInAnonymously();

    final created =
        (await host.rpc(
                      'create_room',
                      params: {'p_name': 'Host', 'p_color': 'lime'},
                    )
                    as List)
                .first
            as Map<String, dynamic>;
    final roomId = created['room_id'] as String;
    final code = created['room_code'] as String;
    final hostPlayer = created['player_id'] as String;

    final joined =
        (await guest.rpc(
                      'join_room',
                      params: {
                        'p_code': code,
                        'p_name': 'Giulia',
                        'p_color': 'coral',
                      },
                    )
                    as List)
                .first
            as Map<String, dynamic>;
    final guestPlayer = joined['player_id'] as String;

    // il guest segue i round come fa la schermata di gioco
    final rounds = <String>[];
    final roundSub = guest
        .from('rounds')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .listen((rows) {
          if (rows.isNotEmpty) {
            final last = rows.last;
            rounds.add('${last['round_number']}/${last['status']}');
          }
        });
    await Future<void>.delayed(const Duration(seconds: 2));

    await host.rpc(
      'start_game',
      params: {'p_room': roomId, 'p_game': 'preferisci'},
    );
    final room =
        (await guest
                .from('rooms')
                .select('status,active_game')
                .eq('id', roomId))
            .first;
    check(
      'start_game mette la stanza in gioco',
      room['status'] == 'in_game' && room['active_game'] == 'preferisci',
      '${room['status']}/${room['active_game']}',
    );

    // solo l'host può creare il round
    try {
      await guest.from('rounds').insert({
        'room_id': roomId,
        'game_type': 'preferisci',
        'round_number': 99,
        'content': {'a': 'x', 'b': 'y', 'i': 0},
      });
      check('un non-host non può creare round', false, 'insert riuscito');
    } on PostgrestException catch (_) {
      check('un non-host non può creare round', true);
    }

    final round = await host
        .from('rounds')
        .insert({
          'room_id': roomId,
          'game_type': 'preferisci',
          'round_number': 1,
          'content': {'a': 'Mare', 'b': 'Montagna', 'i': 0},
        })
        .select()
        .single();
    final roundId = round['id'] as String;

    final sawRound = await _waitFor(
      () => rounds.any((r) => r.startsWith('1/waiting_votes')),
      const Duration(seconds: 10),
    );
    check(
      'il round arriva all\'altro giocatore in tempo reale',
      sawRound,
      rounds.isEmpty ? 'nessun evento' : rounds.last,
    );

    // l'host segue i voti
    final voteCounts = <int>[];
    final voteSub = host
        .from('votes')
        .stream(primaryKey: ['id'])
        .eq('round_id', roundId)
        .listen((rows) => voteCounts.add(rows.length));
    await Future<void>.delayed(const Duration(seconds: 2));

    await guest.from('votes').insert({
      'round_id': roundId,
      'player_id': guestPlayer,
      'value': {'choice': 'b'},
    });
    await host.from('votes').insert({
      'round_id': roundId,
      'player_id': hostPlayer,
      'value': {'choice': 'a'},
    });

    final sawVotes = await _waitFor(
      () => voteCounts.isNotEmpty && voteCounts.last == 2,
      const Duration(seconds: 10),
    );
    check(
      'l\'host vede arrivare i due voti',
      sawVotes,
      voteCounts.isEmpty ? 'nessun evento' : 'ultimo=${voteCounts.last}',
    );

    // niente doppio voto
    try {
      await guest.from('votes').insert({
        'round_id': roundId,
        'player_id': guestPlayer,
        'value': {'choice': 'a'},
      });
      check('non si può votare due volte', false, 'secondo voto accettato');
    } on PostgrestException catch (_) {
      check('non si può votare due volte', true);
    }

    // non si vota per conto di un altro
    try {
      await guest.from('votes').insert({
        'round_id': roundId,
        'player_id': hostPlayer,
        'value': {'choice': 'a'},
      });
      check('non si può votare al posto di un altro', false, 'insert riuscito');
    } on PostgrestException catch (_) {
      check('non si può votare al posto di un altro', true);
    }

    // solo l'host chiude le votazioni
    await guest.from('rounds').update({'status': 'revealed'}).eq('id', roundId);
    final stillOpen =
        (await guest.from('rounds').select('status').eq('id', roundId)).first;
    check(
      'un non-host non può svelare il risultato',
      stillOpen['status'] == 'waiting_votes',
      '${stillOpen['status']}',
    );

    await host.from('rounds').update({'status': 'revealed'}).eq('id', roundId);
    final sawReveal = await _waitFor(
      () => rounds.any((r) => r == '1/revealed'),
      const Duration(seconds: 10),
    );
    check(
      'il reveal arriva a tutti',
      sawReveal,
      rounds.isEmpty ? 'nessun evento' : rounds.last,
    );

    // rigiocare azzera i round della partita precedente
    await host.rpc(
      'start_game',
      params: {'p_room': roomId, 'p_game': 'preferisci'},
    );
    final leftovers = await host
        .from('rounds')
        .select('id')
        .eq('room_id', roomId);
    check(
      'rigiocando i round vecchi spariscono',
      leftovers.isEmpty,
      '${leftovers.length} round rimasti',
    );

    await roundSub.cancel();
    await voteSub.cancel();
    await host.from('rooms').delete().eq('id', roomId);
  } catch (e) {
    stderr.writeln('ERRORE: $e');
    failures++;
  } finally {
    await host.dispose();
    await guest.dispose();
  }

  stdout.writeln(
    failures == 0
        ? '\nCiclo di gioco verificato.'
        : '\n$failures controlli falliti.',
  );
  exit(failures == 0 ? 0 : 1);
}

Future<bool> _waitFor(bool Function() condition, Duration timeout) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (condition()) return true;
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
  return condition();
}
