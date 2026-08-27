// Controllo grammaticale (LanguageTool) e traduzioni mancanti (DeepL) sui
// contenuti di lib/content/content_*.dart.
//
//   dart run tool/content_lint.dart                    tutto, tutte le lingue
//   dart run tool/content_lint.dart --locale=fr         solo francese
//   dart run tool/content_lint.dart --skip-translate    solo grammatica
//   dart run tool/content_lint.dart --skip-grammar      solo traduzioni mancanti
//   dart run tool/content_lint.dart --batch=40          frasi per richiesta LanguageTool
//
// La chiave DeepL si legge da .env (DEEPL_API_KEY=...) o dalla variabile
// d'ambiente omonima. LanguageTool non richiede una chiave: di default usa
// l'endpoint pubblico gratuito (api.languagetool.org), oppure una tua
// istanza self-hosted se imposti LANGUAGETOOL_URL (in .env o come env var).
//
// Le frasi vengono raggruppate a blocchi (--batch, default 35) e inviate a
// LanguageTool in un'unica richiesta per blocco, così il rate limit gratuito
// (~20 richieste/min) basta anche per l'intero contenuto.

import 'dart:convert';
import 'dart:io';

import 'package:joyo/content/content_tone.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/features/games/content/game_content.dart';

/// Una voce di contenuto: {'text': ...} per le liste semplici,
/// {'a': ..., 'b': ...} per le coppie di "Preferisci".
typedef ContentItem = Map<String, String>;

/// Un gruppo di contenuti confrontabile 1:1 fra lingue (es. "nonHoMai/hot").
class ContentGroup {
  ContentGroup(this.name, this.byLocale);

  final String name;
  final Map<AppLocale, List<ContentItem>> byLocale;
}

const _ltLanguage = {
  AppLocale.it: 'it',
  AppLocale.en: 'en-US',
  AppLocale.de: 'de-DE',
  AppLocale.es: 'es',
  AppLocale.fr: 'fr',
};

const _deeplTarget = {
  AppLocale.en: 'EN-US',
  AppLocale.de: 'DE',
  AppLocale.es: 'ES',
  AppLocale.fr: 'FR',
};

const _ltSeparator = '\n\n';
const _publicLanguageTool = 'https://api.languagetool.org/v2/check';

Future<void> main(List<String> args) async {
  final skipGrammar = args.contains('--skip-grammar');
  final skipTranslate = args.contains('--skip-translate');
  final batchSize = int.tryParse(_option(args, '--batch') ?? '') ?? 35;
  final onlyLocaleCode = _option(args, '--locale');

  final env = {..._loadEnvFile('.env'), ...Platform.environment};

  final locales = onlyLocaleCode == null
      ? AppLocale.values
      : [AppLocale.fromCode(onlyLocaleCode)];

  final groups = _collectGroups();

  if (!skipGrammar) {
    final languageToolUrl = env['LANGUAGETOOL_URL'] ?? _publicLanguageTool;
    final rateLimited = languageToolUrl == _publicLanguageTool;
    stdout.writeln('=== CONTROLLO GRAMMATICALE (LanguageTool) ===');
    for (final locale in locales) {
      await _grammarCheckLocale(
        locale,
        groups,
        languageToolUrl,
        rateLimited,
        batchSize,
      );
    }
  }

  if (!skipTranslate) {
    final apiKey = env['DEEPL_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      stderr.writeln(
        '\nManca DEEPL_API_KEY (mettila in .env) — salto le traduzioni mancanti.',
      );
    } else {
      stdout.writeln('\n=== TRADUZIONI MANCANTI (rispetto a IT) ===');
      await _missingTranslations(groups, locales, apiKey, batchSize);
    }
  }
}

// --------------------------------------------------------------------------
// Raccolta contenuti, riusando gli stessi accessor di GameContent.
// --------------------------------------------------------------------------

List<ContentGroup> _collectGroups() {
  final groups = <ContentGroup>[];

  ContentGroup textGroupByTone(
    String name,
    List<({String text, String tone})> Function(AppLocale) pool,
    String tone,
  ) {
    final byLocale = <AppLocale, List<ContentItem>>{};
    for (final locale in AppLocale.values) {
      byLocale[locale] = [
        for (final e in pool(locale))
          if (e.tone == tone) {'text': e.text},
      ];
    }
    return ContentGroup('$name/$tone', byLocale);
  }

  for (final tone in ContentTone.all) {
    groups.add(textGroupByTone('nonHoMai', GameContent.nonHoMai, tone));
    groups.add(
      textGroupByTone('chiLoPotrebbeFare', GameContent.chiLoPotrebbeFare, tone),
    );
  }

  for (final tone in ContentTone.all) {
    final byLocale = <AppLocale, List<ContentItem>>{};
    for (final locale in AppLocale.values) {
      byLocale[locale] = [
        for (final s in GameContent.obblighi(locale, tone)) {'text': s},
      ];
    }
    groups.add(ContentGroup('obblighi/$tone', byLocale));
  }

  for (final tone in ContentTone.all) {
    final byLocale = <AppLocale, List<ContentItem>>{};
    for (final locale in AppLocale.values) {
      byLocale[locale] = [
        for (final s in GameContent.verita(locale, tone)) {'text': s},
      ];
    }
    groups.add(ContentGroup('verita/$tone', byLocale));
  }

  for (final tone in ContentTone.all) {
    final byLocale = <AppLocale, List<ContentItem>>{};
    for (final locale in AppLocale.values) {
      byLocale[locale] = [
        for (final e in GameContent.preferisciEntries(locale))
          if (e.tone == tone) {'a': e.a, 'b': e.b},
      ];
    }
    groups.add(ContentGroup('preferisci/$tone', byLocale));
  }

  groups.add(
    ContentGroup('bluffFakes', {
      for (final locale in AppLocale.values)
        locale: [
          for (final s in GameContent.bluffFakes(locale)) {'text': s},
        ],
    }),
  );
  groups.add(
    ContentGroup('impostoreWords', {
      for (final locale in AppLocale.values)
        locale: [
          for (final s in GameContent.impostoreWords(locale)) {'text': s},
        ],
    }),
  );

  return groups;
}

// --------------------------------------------------------------------------
// Grammatica (LanguageTool)
// --------------------------------------------------------------------------

Future<void> _grammarCheckLocale(
  AppLocale locale,
  List<ContentGroup> groups,
  String languageToolUrl,
  bool rateLimited,
  int batchSize,
) async {
  final language = _ltLanguage[locale]!;
  final entries = <({String label, String text})>[];
  for (final group in groups) {
    final items = group.byLocale[locale] ?? const [];
    for (var i = 0; i < items.length; i++) {
      items[i].forEach((field, text) {
        if (text.trim().isEmpty) return;
        entries.add((label: '${group.name}#$i.$field', text: text));
      });
    }
  }

  stdout.writeln('\n-- ${locale.code} (${entries.length} frasi) --');

  var issues = 0;
  for (var start = 0; start < entries.length; start += batchSize) {
    final batch = entries.sublist(
      start,
      (start + batchSize).clamp(0, entries.length),
    );
    final matches = await _languageToolCheck(
      languageToolUrl,
      batch.map((e) => e.text).toList(),
      language,
    );
    for (final m in matches) {
      final entry = batch[m.index];
      stdout.writeln(
        '  [${entry.label}] ${m.message}'
        '${m.replacement != null ? ' → "${m.replacement}"' : ''}\n'
        '    "${entry.text}"',
      );
      issues++;
    }
    if (rateLimited && start + batchSize < entries.length) {
      await Future<void>.delayed(const Duration(milliseconds: 3200));
    }
  }
  if (issues == 0) stdout.writeln('  nessun problema trovato.');
}

class _LtMatch {
  _LtMatch(this.index, this.message, this.replacement);
  final int index;
  final String message;
  final String? replacement;
}

Future<List<_LtMatch>> _languageToolCheck(
  String baseUrl,
  List<String> texts,
  String language,
) async {
  final joined = texts.join(_ltSeparator);
  final starts = <int>[];
  var pos = 0;
  for (final t in texts) {
    starts.add(pos);
    pos += t.length + _ltSeparator.length;
  }

  // REPETITIONS_STYLE (es. "tre frasi di seguito iniziano con la stessa
  // parola") è un falso positivo strutturale: ogni voce è una riga
  // indipendente di una lista, non prosa scorrevole, ma LanguageTool vede il
  // blocco incollato come un unico testo e segnala ripetizioni che nel
  // contesto reale (una voce alla volta, mostrata da sola in gioco) non
  // esistono.
  final body = _formEncode({
    'text': joined,
    'language': language,
    'disabledCategories': 'REPETITIONS_STYLE',
  });
  final response = await _post(baseUrl, body);
  final decoded = jsonDecode(response) as Map<String, dynamic>;
  final rawMatches = (decoded['matches'] as List?) ?? const [];

  final results = <_LtMatch>[];
  for (final raw in rawMatches) {
    final match = raw as Map<String, dynamic>;
    final offset = match['offset'] as int;

    // Attribuisci il match alla frase che lo precede: gli unici match che
    // potrebbero cadere nel separatore riguardano lo spazio fra frasi, non
    // interessante per un report di correzione testi.
    var index = 0;
    for (var i = 0; i < starts.length; i++) {
      if (starts[i] <= offset) index = i;
    }
    final replacements = (match['replacements'] as List?) ?? const [];
    final replacement = replacements.isNotEmpty
        ? (replacements.first as Map<String, dynamic>)['value'] as String?
        : null;
    results.add(_LtMatch(index, match['message'] as String, replacement));
  }
  return results;
}

// --------------------------------------------------------------------------
// Traduzioni mancanti (DeepL) — solo le voci in coda che IT ha e la lingua
// target no, per ciascun gruppo (lista + tono).
// --------------------------------------------------------------------------

Future<void> _missingTranslations(
  List<ContentGroup> groups,
  List<AppLocale> locales,
  String apiKey,
  int batchSize,
) async {
  for (final group in groups) {
    final itItems = group.byLocale[AppLocale.it] ?? const [];
    for (final locale in locales) {
      if (locale == AppLocale.it) continue;
      final targetItems = group.byLocale[locale] ?? const [];
      if (targetItems.length >= itItems.length) continue;

      final missing = itItems.sublist(targetItems.length);
      stdout.writeln(
        '\n-- ${group.name} → ${locale.code}: '
        '${missing.length} voci mancanti (da #${targetItems.length}) --',
      );

      final fields = <String>[];
      for (final item in missing) {
        fields.addAll(item.values);
      }
      final translated = await _deeplTranslateBatched(
        fields,
        _deeplTarget[locale]!,
        apiKey,
        batchSize,
      );

      var cursor = 0;
      for (final item in missing) {
        final out = <String, String>{};
        for (final key in item.keys) {
          out[key] = translated[cursor++];
        }
        final rendered = out.length == 1
            ? "(text: '${_escape(out['text']!)}', tone: ...),"
            : "(a: '${_escape(out['a']!)}', b: '${_escape(out['b']!)}', tone: ...),";
        stdout.writeln('  $rendered');
      }
    }
  }
}

Future<List<String>> _deeplTranslateBatched(
  List<String> texts,
  String targetLang,
  String apiKey,
  int batchSize,
) async {
  final host = apiKey.endsWith(':fx')
      ? 'https://api-free.deepl.com'
      : 'https://api.deepl.com';
  final out = <String>[];
  for (var start = 0; start < texts.length; start += batchSize) {
    final batch = texts.sublist(
      start,
      (start + batchSize).clamp(0, texts.length),
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

// --------------------------------------------------------------------------
// Utility
// --------------------------------------------------------------------------

// Il pubblico api.languagetool.org va in timeout o 5xx di tanto in tanto sotto
// carico: sono errori transitori, non motivo per buttare via tutto il lavoro
// fatto finora. Si ritenta con backoff prima di arrendersi.
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

String _escape(String s) => s.replaceAll("'", "\\'");

String? _option(List<String> args, String prefix) {
  for (final a in args) {
    if (a.startsWith('$prefix=')) return a.substring(prefix.length + 1);
  }
  return null;
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
