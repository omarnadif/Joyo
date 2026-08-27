// Verifica Bluff Story: la verità del narratore, i voti degli altri e i punti
// assegnati dal server (il client non può scrivere players.score).
//
//   dart run tool/bluff_check.dart <SUPABASE_URL> <ANON_KEY>

import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Uso: dart run tool/bluff_check.dart <URL> <ANON_KEY>');
    exit(64);
  }

  final host = SupabaseClient(args[0], args[1]);
  final guest = SupabaseClient(args[0], args[1]);
  final third = SupabaseClient(args[0], args[1]);

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
    await third.auth.signInAnonymously();

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

    final guestPlayer =
        ((await guest.rpc(
                          'join_room',
                          params: {
                            'p_code': code,
                            'p_name': 'Giulia',
                            'p_color': 'coral',
                          },
                        )
                        as List)
                    .first
                as Map<String, dynamic>)['player_id']
            as String;
    final thirdPlayer =
        ((await third.rpc(
                          'join_room',
                          params: {
                            'p_code': code,
                            'p_name': 'Marco',
                            'p_color': 'aqua',
                          },
                        )
                        as List)
                    .first
                as Map<String, dynamic>)['player_id']
            as String;

    await host.rpc(
      'start_game',
      params: {'p_room': roomId, 'p_game': 'bluff_story'},
    );

    final round = await host
        .from('rounds')
        .insert({
          'room_id': roomId,
          'game_type': 'bluff_story',
          'round_number': 1,
          'content': {
            'teller': hostPlayer,
            'fake1': 'Una bugia',
            'fake2': 'Un\'altra bugia',
            'i': 0,
            'i2': 1,
            'ai': false,
          },
        })
        .select()
        .single();
    final roundId = round['id'] as String;

    // il narratore manda la verità come proprio voto
    await host.from('votes').insert({
      'round_id': roundId,
      'player_id': hostPlayer,
      'value': {'truth': 'Ho dormito in aeroporto per dodici ore'},
    });
    final seenByGuest = await guest
        .from('votes')
        .select('value')
        .eq('round_id', roundId);
    check(
      'la verità del narratore arriva agli altri',
      seenByGuest.isNotEmpty,
      '${seenByGuest.length} voti visibili',
    );

    // uno indovina (indice 0), l'altro sbaglia (indice 1)
    await guest.from('votes').insert({
      'round_id': roundId,
      'player_id': guestPlayer,
      'value': {'pick': 0},
    });
    await third.from('votes').insert({
      'round_id': roundId,
      'player_id': thirdPlayer,
      'value': {'pick': 1},
    });

    // il client non può assegnarsi punti da solo
    try {
      await guest.from('players').update({'score': 99}).eq('id', guestPlayer);
      final after =
          (await guest.from('players').select('score').eq('id', guestPlayer))
              .first;
      check(
        'un giocatore non può assegnarsi punti',
        (after['score'] as num).toInt() == 0,
        '${after['score']}',
      );
    } on PostgrestException catch (_) {
      check('un giocatore non può assegnarsi punti', true);
    }

    // i punti li assegna la RPC, solo prima del reveal
    await host.rpc(
      'award_points',
      params: {
        'p_round': roundId,
        'p_awards': {guestPlayer: 2, hostPlayer: 1},
      },
    );
    await host.from('rounds').update({'status': 'revealed'}).eq('id', roundId);

    var scores = {
      for (final row
          in await host
              .from('players')
              .select('id,score')
              .eq('room_id', roomId))
        row['id'] as String: (row['score'] as num).toInt(),
    };
    check(
      'chi indovina prende 2 punti',
      scores[guestPlayer] == 2,
      '${scores[guestPlayer]}',
    );
    check(
      'il narratore prende 1 punto per ogni bluff riuscito',
      scores[hostPlayer] == 1,
      '${scores[hostPlayer]}',
    );
    check(
      'chi sbaglia non prende punti',
      scores[thirdPlayer] == 0,
      '${scores[thirdPlayer]}',
    );

    // idempotenza: ripetere l'assegnazione su un round già svelato non fa nulla
    await host.rpc(
      'award_points',
      params: {
        'p_round': roundId,
        'p_awards': {guestPlayer: 2},
      },
    );
    scores = {
      for (final row
          in await host
              .from('players')
              .select('id,score')
              .eq('room_id', roomId))
        row['id'] as String: (row['score'] as num).toInt(),
    };
    check(
      'i punti non si assegnano due volte',
      scores[guestPlayer] == 2,
      '${scores[guestPlayer]}',
    );

    // un non-host non può assegnare punti
    try {
      await guest.rpc(
        'award_points',
        params: {
          'p_round': roundId,
          'p_awards': {guestPlayer: 50},
        },
      );
      final after =
          (await guest.from('players').select('score').eq('id', guestPlayer))
              .first;
      check(
        'un non-host non può assegnare punti',
        (after['score'] as num).toInt() == 2,
        '${after['score']}',
      );
    } on PostgrestException catch (_) {
      check('un non-host non può assegnare punti', true);
    }

    // rigiocare azzera i punteggi
    await host.rpc(
      'start_game',
      params: {'p_room': roomId, 'p_game': 'bluff_story'},
    );
    final reset = await host
        .from('players')
        .select('score')
        .eq('room_id', roomId);
    check(
      'una nuova partita riparte da zero punti',
      reset.every((row) => (row['score'] as num).toInt() == 0),
    );

    await host.from('rooms').delete().eq('id', roomId);
  } catch (e) {
    stderr.writeln('ERRORE: $e');
    failures++;
  } finally {
    await host.dispose();
    await guest.dispose();
    await third.dispose();
  }

  stdout.writeln(
    failures == 0
        ? '\nBluff Story e punteggi verificati.'
        : '\n$failures controlli falliti.',
  );
  exit(failures == 0 ? 0 : 1);
}
