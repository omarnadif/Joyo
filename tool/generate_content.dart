// Genera i contenuti di una lingua (divisi per gioco in lib/content/<lang>/)
// traducendo i pool italiani via DeepL.
//
//   dart run tool/generate_content.dart --locale=es      spagnolo
//   dart run tool/generate_content.dart --locale=fr      francese
//   dart run tool/generate_content.dart --locale=de      tedesco
//   dart run tool/generate_content.dart --locale=en      inglese
//
// La chiave DeepL si legge da .env (DEEPL_API_KEY=...) o dalla variabile
// d'ambiente omonima, come tool/content_lint.dart.
//
// L'italiano è la lingua di riferimento: ogni lista/mappa viene tradotta 1:1,
// mantenendo lo stesso ordine e lo stesso `tone` a ogni indice, così la
// localizzazione per indice (vedi GameContent) e content_parity_test restano
// validi. DeepL preserva nativamente i segnaposto `{name}`/`{n}` e gli a-capo,
// quindi la mappa `ui` va tradotta senza tag-handling. La scrittura su disco
// (file per-gioco) è delegata a emit_content.dart.

import 'dart:convert';
import 'dart:io';

import 'package:joyo/content/ita/content_it_app.dart';
import 'package:joyo/content/ita/content_it_bluff.dart';
import 'package:joyo/content/ita/content_it_chi_lo_potrebbe_fare.dart';
import 'package:joyo/content/ita/content_it_impostore.dart';
import 'package:joyo/content/ita/content_it_non_ho_mai.dart';
import 'package:joyo/content/ita/content_it_obbligo_o_verita.dart';
import 'package:joyo/content/ita/content_it_preferisci.dart';

import 'emit_content.dart';

const _batchSize = 50; // DeepL accetta fino a 50 testi per richiesta.

const _deeplLang = {'en': 'EN-US', 'es': 'ES', 'fr': 'FR', 'de': 'DE'};

Future<void> main(List<String> args) async {
  final code = _option(args, '--locale');
  if (code == null || !_deeplLang.containsKey(code)) {
    stderr.writeln('Uso: --locale=en|es|fr|de');
    exitCode = 1;
    return;
  }

  final env = {..._loadEnvFile('.env'), ...Platform.environment};
  final apiKey = env['DEEPL_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Manca DEEPL_API_KEY (mettila in .env). Interrompo.');
    exitCode = 1;
    return;
  }

  final t = _Deepl(apiKey, _deeplLang[code]!);
  stdout.writeln('→ ${classPrefix[code]} (${_deeplLang[code]})');

  // ui: DeepL preserva segnaposto e a-capo, quindi niente tag-handling.
  stdout.writeln('Traduco ui (${ContentItApp.ui.length} stringhe)…');
  final uiKeys = ContentItApp.ui.keys.toList();
  final uiValues = await t.translate([
    for (final k in uiKeys) ContentItApp.ui[k]!,
  ]);
  final ui = <String, String>{
    for (var i = 0; i < uiKeys.length; i++) uiKeys[i]: uiValues[i],
  };

  stdout.writeln('Traduco nonHoMai (${ContentItNonHoMai.nonHoMai.length})…');
  final nonHoMai = await _translateTonedList(t, ContentItNonHoMai.nonHoMai);

  stdout.writeln(
    'Traduco chiLoPotrebbeFare (${ContentItChiLoPotrebbeFare.chiLoPotrebbeFare.length})…',
  );
  final chiLo = await _translateTonedList(
    t,
    ContentItChiLoPotrebbeFare.chiLoPotrebbeFare,
  );

  stdout.writeln('Traduco obblighi/verita…');
  final obblighi = await _translateToneMap(t, ContentItObbligoOVerita.obblighi);
  final verita = await _translateToneMap(t, ContentItObbligoOVerita.verita);

  stdout.writeln('Traduco bluffFakes (${ContentItBluff.bluffFakes.length})…');
  final bluff = await t.translate(ContentItBluff.bluffFakes);

  stdout.writeln(
    'Traduco impostoreWords (${ContentItImpostore.impostoreWords.length})…',
  );
  final impostore = await t.translate(ContentItImpostore.impostoreWords);

  stdout.writeln(
    'Traduco preferisciPairs (${ContentItPreferisci.preferisciPairs.length})…',
  );
  final pairsA = await t.translate([
    for (final p in ContentItPreferisci.preferisciPairs) p.a,
  ]);
  final pairsB = await t.translate([
    for (final p in ContentItPreferisci.preferisciPairs) p.b,
  ]);
  final pairs = [
    for (var i = 0; i < pairsA.length; i++) (a: pairsA[i], b: pairsB[i]),
  ];

  stdout.writeln(
    'Traduco preferisciHot (${ContentItPreferisci.preferisciHot.length})…',
  );
  final hotA = await t.translate([
    for (final p in ContentItPreferisci.preferisciHot) p.a,
  ]);
  final hotB = await t.translate([
    for (final p in ContentItPreferisci.preferisciHot) p.b,
  ]);
  final hot = [
    for (var i = 0; i < hotA.length; i++)
      (a: hotA[i], b: hotB[i], tone: ContentItPreferisci.preferisciHot[i].tone),
  ];

  final files = writeSplit(
    code,
    LangContent(
      ui: ui,
      nonHoMai: nonHoMai,
      chiLo: chiLo,
      obblighi: obblighi,
      verita: verita,
      bluff: bluff,
      impostore: impostore,
      pairs: pairs,
      hot: hot,
    ),
  );
  stdout.writeln('\nScritti ${files.length} file in lib/content/$code/');
  stdout.writeln('Ora: dart format lib/content/$code  &&  flutter test');
}

Future<List<({String text, String tone})>> _translateTonedList(
  _Deepl t,
  List<({String text, String tone})> src,
) async {
  final texts = await t.translate([for (final e in src) e.text]);
  return [
    for (var i = 0; i < src.length; i++) (text: texts[i], tone: src[i].tone),
  ];
}

Future<Map<String, List<String>>> _translateToneMap(
  _Deepl t,
  Map<String, List<String>> src,
) async {
  final out = <String, List<String>>{};
  for (final entry in src.entries) {
    out[entry.key] = await t.translate(entry.value);
  }
  return out;
}

// --------------------------------------------------------------------------
// DeepL client (batching + retry), stessa logica di tool/content_lint.dart.
// --------------------------------------------------------------------------

class _Deepl {
  _Deepl(this.apiKey, this.targetLang)
    : host = apiKey.endsWith(':fx')
          ? 'https://api-free.deepl.com'
          : 'https://api.deepl.com';

  final String apiKey;
  final String targetLang;
  final String host;

  Future<List<String>> translate(List<String> texts) async {
    final out = <String>[];
    for (var start = 0; start < texts.length; start += _batchSize) {
      final batch = texts.sublist(
        start,
        (start + _batchSize).clamp(0, texts.length),
      );
      final body = _formEncode(
        {'source_lang': 'IT', 'target_lang': targetLang},
        repeated: {'text': batch},
      );
      final response = await _post(
        '$host/v2/translate',
        body,
        authHeader: 'DeepL-Auth-Key $apiKey',
      );
      final decoded = jsonDecode(response) as Map<String, dynamic>;
      final translations = decoded['translations'] as List;
      out.addAll(
        translations.map((t) => (t as Map<String, dynamic>)['text'] as String),
      );
    }
    return out;
  }
}

const _maxRetries = 4;

Future<String> _post(String url, String body, {String? authHeader}) async {
  for (var attempt = 0; ; attempt++) {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(url));
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/x-www-form-urlencoded; charset=UTF-8',
      );
      if (authHeader != null) {
        request.headers.set(HttpHeaders.authorizationHeader, authHeader);
      }
      request.write(body);
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final text = await response.transform(utf8.decoder).join();
      if (response.statusCode >= 300) {
        throw HttpException('$url → HTTP ${response.statusCode}: $text');
      }
      return text;
    } catch (e) {
      if (attempt >= _maxRetries) rethrow;
      final wait = Duration(seconds: 5 * (attempt + 1));
      stderr.writeln(
        '  (errore transitorio, riprovo fra ${wait.inSeconds}s: $e)',
      );
      await Future<void>.delayed(wait);
    } finally {
      client.close();
    }
  }
}

String _formEncode(
  Map<String, String> fields, {
  Map<String, List<String>>? repeated,
}) {
  final parts = <String>[
    for (final e in fields.entries)
      '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
    if (repeated != null)
      for (final e in repeated.entries)
        for (final v in e.value)
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(v)}',
  ];
  return parts.join('&');
}

Map<String, String> _loadEnvFile(String path) {
  final file = File(path);
  if (!file.existsSync()) return {};
  final map = <String, String>{};
  for (final rawLine in file.readAsLinesSync()) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final eq = line.indexOf('=');
    if (eq == -1) continue;
    final key = line.substring(0, eq).trim();
    var value = line.substring(eq + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    map[key] = value;
  }
  return map;
}

String? _option(List<String> args, String prefix) {
  for (final a in args) {
    if (a.startsWith('$prefix=')) return a.substring(prefix.length + 1);
  }
  return null;
}
