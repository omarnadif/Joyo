// Verifica end-to-end del pezzo su cui si regge la lobby: due utenti anonimi
// diversi, uno crea la stanza e resta in ascolto, l'altro entra. Il primo deve
// vedere arrivare il secondo via Realtime, senza ricaricare nulla.
//
// Uso:
//   dart run tool/realtime_check.dart <SUPABASE_URL> <ANON_KEY>
//
// Esce con codice 0 se la sincronizzazione funziona, 1 altrimenti.

import 'dart:async';
import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Uso: dart run tool/realtime_check.dart <URL> <ANON_KEY>');
    exit(64);
  }
  final url = args[0];
  final key = args[1];

  final host = SupabaseClient(url, key);
  final guest = SupabaseClient(url, key);

  var failures = 0;
  void check(String label, bool ok, [String detail = '']) {
    stdout.writeln('${ok ? 'OK  ' : 'FAIL'}  $label${detail.isEmpty ? '' : ' — $detail'}');
    if (!ok) failures++;
  }

  try {
    await host.auth.signInAnonymously();
    await guest.auth.signInAnonymously();
    check('due sessioni anonime distinte',
        host.auth.currentUser!.id != guest.auth.currentUser!.id);

    final created = (await host.rpc('create_room',
        params: {'p_name': 'Host', 'p_color': 'lime'}) as List).first as Map<String, dynamic>;
    final roomId = created['room_id'] as String;
    final code = created['room_code'] as String;
    check('stanza creata con codice a 6 caratteri', code.length == 6, 'codice $code');

    // l'host si mette in ascolto come fa la lobby
    final seen = <List<String>>[];
    final sub = host
        .from('players')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('joined_at', ascending: true)
        .listen((rows) {
      // Stessa deduplica del client: Realtime può riconsegnare l'INSERT di una
      // riga già presente nello snapshot iniziale.
      final byId = <String, String>{
        for (final row in rows) row['id'] as String: row['name'] as String,
      };
      seen.add(byId.values.toList());
      stdout.writeln('      emissione: ${byId.entries.map((e) => "${e.value}#${e.key.substring(0, 4)}").join(' | ')}');
    });

    await Future<void>.delayed(const Duration(seconds: 2));
    check('primo snapshot ricevuto', seen.isNotEmpty && seen.last.length == 1,
        seen.isEmpty ? 'nessun evento' : seen.last.join(', '));

    // arriva il secondo giocatore
    await guest.rpc('join_room',
        params: {'p_code': code, 'p_name': 'Giulia', 'p_color': 'coral'});

    final gotSecond = await _waitFor(
        () => seen.isNotEmpty && seen.last.length == 2,
        const Duration(seconds: 10));
    check('l\'host vede entrare il secondo giocatore in tempo reale', gotSecond,
        seen.isEmpty ? 'nessun evento' : seen.last.join(', '));

    // stato stanza: il guest deve vedere partire il gioco senza toccare nulla
    final roomEvents = <String>[];
    final roomSub = guest
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('id', roomId)
        .listen((rows) {
      roomEvents.add(rows.isEmpty
          ? 'stanza-chiusa'
          : '${rows.first['status']}/${rows.first['active_game']}');
    });
    await Future<void>.delayed(const Duration(seconds: 2));

    await host
        .from('rooms')
        .update({'status': 'in_game', 'active_game': 'preferisci'})
        .eq('id', roomId);

    final gotStart = await _waitFor(
        () => roomEvents.isNotEmpty && roomEvents.last == 'in_game/preferisci',
        const Duration(seconds: 10));
    check('il giocatore non-host riceve l\'avvio del gioco', gotStart,
        roomEvents.isEmpty ? 'nessun evento' : roomEvents.last);

    // uscita dalla stanza: gli altri lo vedono sparire
    final guestPlayer = (await guest
        .from('players')
        .select('id')
        .eq('room_id', roomId)
        .eq('user_id', guest.auth.currentUser!.id)).first['id'] as String;
    await guest.from('players').delete().eq('id', guestPlayer);

    final gotLeave = await _waitFor(
        () => seen.isNotEmpty && seen.last.length == 1,
        const Duration(seconds: 10));
    check('l\'host vede uscire il giocatore in tempo reale', gotLeave,
        seen.isEmpty ? 'nessun evento' : seen.last.join(', '));

    // il guest rientra, così la chiusura della stanza lo trova dentro
    await guest.rpc('join_room',
        params: {'p_code': code, 'p_name': 'Giulia', 'p_color': 'coral'});
    await Future<void>.delayed(const Duration(seconds: 2));

    // l'host chiude la stanza: il guest deve accorgersene, altrimenti resta
    // appeso su una schermata di attesa (è successo davvero in Fase 2)
    await host.from('rooms').delete().eq('id', roomId);
    final gotClose = await _waitFor(
        () => roomEvents.isNotEmpty && roomEvents.last == 'stanza-chiusa',
        const Duration(seconds: 10));
    check('il guest vede la stanza chiudersi', gotClose,
        roomEvents.isEmpty ? 'nessun evento' : roomEvents.last);

    await sub.cancel();
    await roomSub.cancel();
  } catch (e) {
    stderr.writeln('ERRORE: $e');
    failures++;
  } finally {
    await host.dispose();
    await guest.dispose();
  }

  stdout.writeln(failures == 0
      ? '\nTutti i controlli realtime superati.'
      : '\n$failures controlli falliti.');
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
