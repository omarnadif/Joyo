// Verifica Impostore: la parola segreta non deve trapelare, e i punti devono
// essere calcolati dal server anche quando l'host è lui stesso l'impostore.
//
//   dart run tool/impostore_check.dart <SUPABASE_URL> <ANON_KEY>

import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Uso: dart run tool/impostore_check.dart <URL> <ANON_KEY>');
    exit(64);
  }

  final host = SupabaseClient(args[0], args[1]);
  final guest = SupabaseClient(args[0], args[1]);
  final third = SupabaseClient(args[0], args[1]);

  var failures = 0;
  void check(String label, bool ok, [String detail = '']) {
    stdout.writeln(
        '${ok ? 'OK  ' : 'FAIL'}  $label${detail.isEmpty ? '' : ' — $detail'}');
    if (!ok) failures++;
  }

  try {
    await host.auth.signInAnonymously();
    await guest.auth.signInAnonymously();
    await third.auth.signInAnonymously();

    final created = (await host.rpc('create_room',
        params: {'p_name': 'Host', 'p_color': 'lime'}) as List).first as Map<String, dynamic>;
    final roomId = created['room_id'] as String;
    final code = created['room_code'] as String;
    final hostPlayer = created['player_id'] as String;

    final guestPlayer = ((await guest.rpc('join_room', params: {
      'p_code': code,
      'p_name': 'Giulia',
      'p_color': 'coral',
    }) as List).first as Map<String, dynamic>)['player_id'] as String;

    final thirdPlayer = ((await third.rpc('join_room', params: {
      'p_code': code,
      'p_name': 'Marco',
      'p_color': 'aqua',
    }) as List).first as Map<String, dynamic>)['player_id'] as String;

    await host.rpc('start_game', params: {'p_room': roomId, 'p_game': 'impostore'});
    await host.rpc('start_impostore_round', params: {
      'p_room': roomId,
      'p_round_number': 1,
      'p_word': 'Spiaggia',
      'p_word_index': 0,
      'p_discussion': 5,
    });

    final round = (await host.from('rounds').select('id,content').eq('room_id', roomId)).first;
    final roundId = round['id'] as String;
    final content = round['content'] as Map<String, dynamic>;
    check('la parola non finisce nel contenuto pubblico del round',
        !content.containsKey('word'), content.keys.join(', '));

    // ognuno vede solo la propria riga di segreto
    final hostSecrets = await host.from('round_secrets').select('player_id,payload').eq('round_id', roundId);
    final guestSecrets = await guest.from('round_secrets').select('player_id,payload').eq('round_id', roundId);
    check('ogni giocatore vede una sola riga di segreto',
        hostSecrets.length == 1 && guestSecrets.length == 1,
        'host=${hostSecrets.length} guest=${guestSecrets.length}');
    check('ognuno vede la riga giusta',
        hostSecrets.first['player_id'] == hostPlayer &&
            guestSecrets.first['player_id'] == guestPlayer);

    // esattamente un impostore, e gli altri hanno la parola
    final payloads = [
      hostSecrets.first['payload'] as Map<String, dynamic>,
      guestSecrets.first['payload'] as Map<String, dynamic>,
      (await third.from('round_secrets').select('payload').eq('round_id', roundId))
          .first['payload'] as Map<String, dynamic>,
    ];
    final impostors = payloads.where((p) => p['impostor'] == true).length;
    check('c\'è esattamente un impostore', impostors == 1, '$impostors');
    check('l\'impostore non riceve la parola',
        payloads.every((p) => p['impostor'] == true ? !p.containsKey('word') : p['word'] == 'Spiaggia'));

    // nessuno può leggere i segreti altrui nemmeno chiedendoli esplicitamente
    final spy = await guest
        .from('round_secrets')
        .select('payload')
        .eq('round_id', roundId)
        .eq('player_id', hostPlayer);
    check('non si possono leggere i segreti degli altri', spy.isEmpty,
        '${spy.length} righe');

    // nessuno può scrivere segreti
    try {
      await guest.from('round_secrets').insert({
        'round_id': roundId,
        'player_id': guestPlayer,
        'payload': {'impostor': false, 'word': 'Spiaggia'},
      });
      check('i segreti non sono scrivibili dal client', false, 'insert riuscito');
    } on PostgrestException catch (_) {
      check('i segreti non sono scrivibili dal client', true);
    }

    // chi è l'impostore, secondo il server
    final impostorPlayer = [
      if (payloads[0]['impostor'] == true) hostPlayer,
      if (payloads[1]['impostor'] == true) guestPlayer,
      if (payloads[2]['impostor'] == true) thirdPlayer,
    ].first;

    // tutti votano l'impostore, che prova a indovinare la parola
    for (final entry in <(SupabaseClient, String)>[
      (host, hostPlayer),
      (guest, guestPlayer),
      (third, thirdPlayer),
    ]) {
      final isImpostor = entry.$2 == impostorPlayer;
      await entry.$1.from('votes').insert({
        'round_id': roundId,
        'player_id': entry.$2,
        'value': {
          'suspect': impostorPlayer,
          if (isImpostor) 'guess': 'spiaggia ',
        },
      });
    }

    await host.rpc('resolve_impostore', params: {'p_round': roundId});

    final resolved = (await host.from('rounds').select('status,content').eq('id', roundId)).first;
    final resolvedContent = resolved['content'] as Map<String, dynamic>;
    check('il round si chiude da solo', resolved['status'] == 'revealed');
    check('la parola viene svelata solo alla fine',
        resolvedContent['word'] == 'Spiaggia');
    check('l\'impostore risulta scoperto', resolvedContent['caught'] == true);
    check('la parola indovinata viene riconosciuta anche con spazi e maiuscole',
        resolvedContent['guess_ok'] == true);

    final scores = {
      for (final row in await host.from('players').select('id,score').eq('room_id', roomId))
        row['id'] as String: (row['score'] as num).toInt(),
    };
    final accusers = scores.entries.where((e) => e.key != impostorPlayer);
    check('chi ha smascherato prende 2 punti',
        accusers.every((e) => e.value == 2),
        accusers.map((e) => e.value).join('/'));
    check('l\'impostore scoperto ma che indovina recupera 3 punti',
        scores[impostorPlayer] == 3, '${scores[impostorPlayer]}');

    // secondo giro: nessuno vota l'impostore, deve farla franca
    await host.rpc('start_game', params: {'p_room': roomId, 'p_game': 'impostore'});
    await host.rpc('start_impostore_round', params: {
      'p_room': roomId,
      'p_round_number': 1,
      'p_word': 'Aeroporto',
      'p_word_index': 1,
      'p_discussion': 5,
    });
    final round2 = (await host.from('rounds').select('id').eq('room_id', roomId)).first['id'] as String;
    final secrets2 = <String, Map<String, dynamic>>{
      hostPlayer: (await host.from('round_secrets').select('payload').eq('round_id', round2)).first['payload'] as Map<String, dynamic>,
      guestPlayer: (await guest.from('round_secrets').select('payload').eq('round_id', round2)).first['payload'] as Map<String, dynamic>,
      thirdPlayer: (await third.from('round_secrets').select('payload').eq('round_id', round2)).first['payload'] as Map<String, dynamic>,
    };
    final impostor2 = secrets2.entries.firstWhere((e) => e.value['impostor'] == true).key;
    final innocent = secrets2.keys.firstWhere((id) => id != impostor2);

    for (final entry in <(SupabaseClient, String)>[
      (host, hostPlayer),
      (guest, guestPlayer),
      (third, thirdPlayer),
    ]) {
      await entry.$1.from('votes').insert({
        'round_id': round2,
        'player_id': entry.$2,
        'value': {'suspect': innocent},
      });
    }
    await host.rpc('resolve_impostore', params: {'p_round': round2});

    final scores2 = {
      for (final row in await host.from('players').select('id,score').eq('room_id', roomId))
        row['id'] as String: (row['score'] as num).toInt(),
    };
    check('l\'impostore non scoperto prende 5 punti',
        scores2[impostor2] == 5, '${scores2[impostor2]}');

    await host.from('rooms').delete().eq('id', roomId);
  } catch (e) {
    stderr.writeln('ERRORE: $e');
    failures++;
  } finally {
    await host.dispose();
    await guest.dispose();
    await third.dispose();
  }

  stdout.writeln(failures == 0
      ? '\nImpostore verificato.'
      : '\n$failures controlli falliti.');
  exit(failures == 0 ? 0 : 1);
}
