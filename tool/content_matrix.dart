// Conta i contenuti di ogni gioco, per lingua e per tono.
//
//   dart run tool/content_matrix.dart

import 'dart:io';

import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/content/game_content.dart';
import 'package:joyo/content/content_tone.dart';

int _perTone(List<({String text, String tone})> pool, String tone) =>
    pool.where((e) => e.tone == tone).length;

int _perTonePref(List<({String a, String b, String tone})> pool, String tone) =>
    pool.where((e) => e.tone == tone).length;

String _row(String label, List<String> cells) {
  final b = StringBuffer();
  b.write(label.padRight(34));
  for (final c in cells) {
    b.write(c.padLeft(8));
  }
  return b.toString();
}

void main() {
  final locales = AppLocale.values;
  final header = _row('GIOCO / categoria', [for (final l in locales) l.code]);
  final sep = '-' * header.length;

  void section(String title) {
    stdout.writeln('');
    stdout.writeln(title);
    stdout.writeln(sep);
  }

  stdout.writeln(header);
  stdout.writeln(sep);

  // Non ho mai
  section('NON HO MAI (atteso: 150 per tono)');
  for (final tone in ContentTone.all) {
    stdout.writeln(
      _row('  $tone', [
        for (final l in locales) '${_perTone(GameContent.nonHoMai(l), tone)}',
      ]),
    );
  }
  stdout.writeln(
    _row('  TOTALE', [
      for (final l in locales) '${GameContent.nonHoMai(l).length}',
    ]),
  );

  // Chi lo potrebbe fare
  section('CHI LO POTREBBE FARE (atteso: 150 per tono)');
  for (final tone in ContentTone.all) {
    stdout.writeln(
      _row('  $tone', [
        for (final l in locales)
          '${_perTone(GameContent.chiLoPotrebbeFare(l), tone)}',
      ]),
    );
  }
  stdout.writeln(
    _row('  TOTALE', [
      for (final l in locales) '${GameContent.chiLoPotrebbeFare(l).length}',
    ]),
  );

  // Obbligo o Verita
  section('OBBLIGHI (atteso: 150 per tono)');
  for (final tone in ContentTone.all) {
    stdout.writeln(
      _row('  $tone', [
        for (final l in locales) '${GameContent.obblighi(l, tone).length}',
      ]),
    );
  }
  section('VERITA (atteso: 150 per tono)');
  for (final tone in ContentTone.all) {
    stdout.writeln(
      _row('  $tone', [
        for (final l in locales) '${GameContent.verita(l, tone).length}',
      ]),
    );
  }

  // Preferisci
  section('PREFERISCI (entries per tono + coppie)');
  for (final tone in ContentTone.all) {
    stdout.writeln(
      _row('  $tone', [
        for (final l in locales)
          '${_perTonePref(GameContent.preferisciEntries(l), tone)}',
      ]),
    );
  }
  stdout.writeln(
    _row('  TOTALE entries', [
      for (final l in locales) '${GameContent.preferisciEntries(l).length}',
    ]),
  );
  stdout.writeln(
    _row('  coppie (pairs)', [
      for (final l in locales)
        '${_perTonePref(GameContent.preferisciEntries(l), ContentTone.normal)}',
    ]),
  );

  // Bluff Story + Impostore (senza toni)
  section('ALTRI (atteso: 150 ciascuno)');
  stdout.writeln(
    _row('  Bluff Story (fakes)', [
      for (final l in locales) '${GameContent.bluffFakes(l).length}',
    ]),
  );
  stdout.writeln(
    _row('  Impostore (parole)', [
      for (final l in locales) '${GameContent.impostoreWords(l).length}',
    ]),
  );
}
