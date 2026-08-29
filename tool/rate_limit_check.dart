// Verifica end-to-end del rate limit su grant_mode_unlock (migration 0020):
// un utente anonimo può registrare un annuncio, ma una seconda chiamata
// immediata deve essere rifiutata con TOO_FAST. Senza questo limite chiunque
// poteva coniare partite premium in loop senza guardare alcun annuncio.
//
// Uso:
//   dart run tool/rate_limit_check.dart <SUPABASE_URL> <ANON_KEY>
//
// Esce con codice 0 se il limite funziona, 1 altrimenti.

import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Uso: dart run tool/rate_limit_check.dart <URL> <ANON_KEY>');
    exit(64);
  }
  final client = SupabaseClient(args[0], args[1]);

  var failures = 0;
  void check(String label, bool ok, [String detail = '']) {
    stdout.writeln(
      '${ok ? 'OK  ' : 'FAIL'}  $label${detail.isEmpty ? '' : ' — $detail'}',
    );
    if (!ok) failures++;
  }

  try {
    await client.auth.signInAnonymously();

    final first = await client.rpc<dynamic>('grant_mode_unlock');
    check(
      'la prima chiamata registra un annuncio',
      first is List && first.isNotEmpty && first.first['ad_progress'] == 1,
      '$first',
    );

    try {
      await client.rpc<dynamic>('grant_mode_unlock');
      check('la seconda chiamata immediata viene rifiutata', false,
          'nessuna eccezione: il rate limit non è attivo');
    } on PostgrestException catch (error) {
      check(
        'la seconda chiamata immediata viene rifiutata',
        error.message.contains('TOO_FAST'),
        error.message,
      );
    }
  } catch (error) {
    check('esecuzione completa', false, '$error');
  } finally {
    await client.auth.signOut();
    client.dispose();
  }

  exit(failures == 0 ? 0 : 1);
}
