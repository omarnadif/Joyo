// Scrittura dei contenuti di una lingua divisi per gioco, come l'italiano in
// lib/content/ita/. Usata sia dal generatore DeepL (tool/generate_content.dart)
// sia dallo splitter una tantum, così la struttura su disco è sempre la stessa.
import 'dart:io';

import 'package:joyo/content/content_tone.dart';

/// Tutti i pool di una lingua, nella stessa forma degli accessor di GameContent.
class LangContent {
  LangContent({
    required this.ui,
    required this.nonHoMai,
    required this.chiLo,
    required this.obblighi,
    required this.verita,
    required this.bluff,
    required this.impostore,
    required this.pairs,
    required this.hot,
  });

  final Map<String, String> ui;
  final List<({String text, String tone})> nonHoMai;
  final List<({String text, String tone})> chiLo;
  final Map<String, List<String>> obblighi;
  final Map<String, List<String>> verita;
  final List<String> bluff;
  final List<String> impostore;
  final List<({String a, String b})> pairs;
  final List<({String a, String b, String tone})> hot;
}

const classPrefix = {
  'en': 'ContentEn',
  'es': 'ContentEs',
  'fr': 'ContentFr',
  'de': 'ContentDe',
};

/// Scrive i 7 file per-gioco della lingua [code] in lib/content/<code>/.
List<String> writeSplit(String code, LangContent c) {
  final prefix = classPrefix[code]!;
  final dir = 'lib/content/$code';
  Directory(dir).createSync(recursive: true);
  final written = <String>[];

  void write(String file, String body, {required bool toneImport}) {
    final b = StringBuffer();
    if (toneImport) b.writeln("import '../content_tone.dart';\n");
    b.write(body);
    File('$dir/$file').writeAsStringSync(b.toString());
    written.add('$dir/$file');
  }

  write(
    'content_${code}_app.dart',
    _appClass('${prefix}App', c.ui),
    toneImport: false,
  );
  write(
    'content_${code}_bluff.dart',
    _stringListClass('${prefix}Bluff', 'bluffFakes', c.bluff),
    toneImport: false,
  );
  write(
    'content_${code}_impostore.dart',
    _stringListClass('${prefix}Impostore', 'impostoreWords', c.impostore),
    toneImport: false,
  );
  write(
    'content_${code}_chi_lo_potrebbe_fare.dart',
    _tonedListClass('${prefix}ChiLoPotrebbeFare', 'chiLoPotrebbeFare', c.chiLo),
    toneImport: true,
  );
  write(
    'content_${code}_non_ho_mai.dart',
    _tonedListClass('${prefix}NonHoMai', 'nonHoMai', c.nonHoMai),
    toneImport: true,
  );
  write(
    'content_${code}_obbligo_o_verita.dart',
    _obbligoClass('${prefix}ObbligoOVerita', c.obblighi, c.verita),
    toneImport: true,
  );
  write(
    'content_${code}_preferisci.dart',
    _preferisciClass('${prefix}Preferisci', c.pairs, c.hot),
    toneImport: true,
  );

  return written;
}

// --------------------------------------------------------------------------
// Costruttori delle singole classi.
// --------------------------------------------------------------------------

String _header(String className) {
  final b = StringBuffer();
  b.writeln('/// Generato da tool/generate_content.dart (traduzione DeepL dai');
  b.writeln(
    '/// pool italiani). Stesse posizioni e stesso tono degli originali IT.',
  );
  b.writeln('class $className {');
  b.writeln('  const $className._();');
  b.writeln();
  return b.toString();
}

String _appClass(String className, Map<String, String> ui) {
  final b = StringBuffer(_header(className));
  b.writeln('  static const Map<String, String> ui = {');
  for (final e in ui.entries) {
    b.writeln("    '${_esc(e.key)}': '${_esc(e.value)}',");
  }
  b.writeln('  };');
  b.writeln('}');
  return b.toString();
}

String _stringListClass(String className, String member, List<String> items) {
  final b = StringBuffer(_header(className));
  b.writeln('  static const List<String> $member = [');
  for (final s in items) {
    b.writeln("    '${_esc(s)}',");
  }
  b.writeln('  ];');
  b.writeln('}');
  return b.toString();
}

String _tonedListClass(
  String className,
  String member,
  List<({String text, String tone})> items,
) {
  final b = StringBuffer(_header(className));
  b.writeln('  static const List<({String text, String tone})> $member = [');
  for (final e in items) {
    b.writeln("    (text: '${_esc(e.text)}', tone: ${_toneExpr(e.tone)}),");
  }
  b.writeln('  ];');
  b.writeln('}');
  return b.toString();
}

String _obbligoClass(
  String className,
  Map<String, List<String>> obblighi,
  Map<String, List<String>> verita,
) {
  final b = StringBuffer(_header(className));
  void map(String member, Map<String, List<String>> data) {
    b.writeln('  static const Map<String, List<String>> $member = {');
    for (final tone in ContentTone.all) {
      final items = data[tone];
      if (items == null) continue;
      b.writeln('    ${_toneExpr(tone)}: [');
      for (final s in items) {
        b.writeln("      '${_esc(s)}',");
      }
      b.writeln('    ],');
    }
    b.writeln('  };');
    b.writeln();
  }

  map('obblighi', obblighi);
  map('verita', verita);
  // rimuove l'ultima riga vuota prima della chiusura classe
  final s = b.toString().trimRight();
  return '$s\n}';
}

String _preferisciClass(
  String className,
  List<({String a, String b})> pairs,
  List<({String a, String b, String tone})> hot,
) {
  final b = StringBuffer(_header(className));
  b.writeln('  static const List<({String a, String b})> preferisciPairs = [');
  for (final p in pairs) {
    b.writeln("    (a: '${_esc(p.a)}', b: '${_esc(p.b)}'),");
  }
  b.writeln('  ];');
  b.writeln();
  b.writeln(
    '  static const List<({String a, String b, String tone})> preferisciHot = [',
  );
  for (final p in hot) {
    b.writeln(
      "    (a: '${_esc(p.a)}', b: '${_esc(p.b)}', tone: ${_toneExpr(p.tone)}),",
    );
  }
  b.writeln('  ];');
  b.writeln('}');
  return b.toString();
}

// --------------------------------------------------------------------------
// Helper.
// --------------------------------------------------------------------------

String _toneExpr(String tone) => switch (tone) {
  ContentTone.normal => 'ContentTone.normal',
  ContentTone.mix => 'ContentTone.mix',
  ContentTone.hot => 'ContentTone.hot',
  _ => "'$tone'",
};

/// Escaping per una stringa Dart racchiusa fra apici singoli.
String _esc(String s) => s
    .replaceAll('\\', '\\\\')
    .replaceAll('\$', '\\\$')
    .replaceAll("'", "\\'")
    .replaceAll('\r', '')
    .replaceAll('\n', '\\n');
