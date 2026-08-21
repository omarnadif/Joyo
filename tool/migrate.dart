// Applica le migrazioni SQL di supabase/migrations al database, in ordine,
// una sola volta ciascuna. Sostituisce il copia-incolla nell'SQL Editor.
//
//   dart run tool/migrate.dart                    applica quelle mancanti
//   dart run tool/migrate.dart --status           mostra cosa manca, senza scrivere
//   dart run tool/migrate.dart --baseline-until 0004_...sql
//                                                 segna come già applicate le
//                                                 migrazioni eseguite a mano
//
// La stringa di connessione viene letta da supabase/.db_url (fuori da git)
// oppure dalla variabile d'ambiente SUPABASE_DB_URL.

import 'dart:io';

import 'package:postgres/postgres.dart';

const _migrationsDir = 'supabase/migrations';
const _dbUrlFile = 'supabase/.db_url';

Future<void> main(List<String> args) async {
  final statusOnly = args.contains('--status');
  final baselineUntil = _optionValue(args, '--baseline-until');

  final url = _databaseUrl();
  if (url == null) {
    stderr.writeln(
      'Manca la stringa di connessione.\n'
      'Mettila in $_dbUrlFile (il file è in .gitignore) oppure esporta '
      'SUPABASE_DB_URL.',
    );
    exit(64);
  }

  final files = Directory(_migrationsDir)
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.sql'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (files.isEmpty) {
    stdout.writeln('Nessuna migrazione in $_migrationsDir.');
    return;
  }

  final connection = await _connect(url);
  try {
    await connection.execute('''
      create table if not exists public.schema_migrations (
        name       text primary key,
        applied_at timestamptz not null default now()
      );
    ''');

    final applied = <String>{
      for (final row in await connection.execute(
        'select name from public.schema_migrations',
      ))
        row[0] as String,
    };

    var pending = 0;
    for (final file in files) {
      final name = file.uri.pathSegments.last;
      if (applied.contains(name)) {
        stdout.writeln('  già applicata   $name');
        continue;
      }

      pending++;
      if (statusOnly) {
        stdout.writeln('  DA APPLICARE    $name');
        continue;
      }

      // Le migrazioni eseguite a mano nell'SQL Editor si registrano senza
      // rieseguirle: alcune cancellano dati e non vanno ripetute.
      final baseline =
          baselineUntil != null && name.compareTo(baselineUntil) <= 0;
      if (baseline) {
        await _record(connection, name);
        stdout.writeln('  segnata (baseline) $name');
        continue;
      }

      stdout.writeln('  applico…        $name');
      final sql = file.readAsStringSync();
      try {
        // queryMode simple: il file contiene più statement e corpi di funzione
        // con $$ ... $$, che il protocollo esteso non accetta.
        await connection.execute(sql, queryMode: QueryMode.simple);
        await _record(connection, name);
        stdout.writeln('  OK              $name');
      } catch (e) {
        stderr.writeln('  FALLITA         $name\n$e');
        exit(1);
      }
    }

    stdout.writeln(
      pending == 0
          ? '\nDatabase già allineato.'
          : statusOnly
          ? '\n$pending migrazioni da applicare.'
          : '\n$pending migrazioni applicate.',
    );
  } finally {
    await connection.close();
  }
}

Future<void> _record(Connection connection, String name) {
  final escaped = name.replaceAll("'", "''");
  return connection.execute(
    "insert into public.schema_migrations (name) values ('$escaped') "
    'on conflict do nothing',
    queryMode: QueryMode.simple,
  );
}

Future<Connection> _connect(String url) {
  final uri = Uri.parse(url);
  final userInfo = uri.userInfo.split(':');
  return Connection.open(
    Endpoint(
      host: uri.host,
      port: uri.port == 0 ? 5432 : uri.port,
      database: uri.pathSegments.isEmpty ? 'postgres' : uri.pathSegments.first,
      username: Uri.decodeComponent(userInfo.first),
      password: userInfo.length > 1 ? Uri.decodeComponent(userInfo[1]) : null,
    ),
    settings: const ConnectionSettings(sslMode: SslMode.require),
  );
}

String? _databaseUrl() {
  final fromEnv = Platform.environment['SUPABASE_DB_URL'];
  if (fromEnv != null && fromEnv.trim().isNotEmpty) return fromEnv.trim();

  final file = File(_dbUrlFile);
  if (file.existsSync()) {
    final value = file.readAsStringSync().trim();
    if (value.isNotEmpty) return value;
  }
  return null;
}

String? _optionValue(List<String> args, String option) {
  final index = args.indexOf(option);
  if (index == -1 || index + 1 >= args.length) return null;
  return args[index + 1];
}
