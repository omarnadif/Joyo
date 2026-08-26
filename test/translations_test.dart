import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/i18n/app_locale.dart';
import 'package:joyo/core/i18n/i18n.dart';
import 'package:joyo/core/i18n/translations.dart';

/// Una traduzione mancante non rompe la compilazione: si vede solo a schermo,
/// nella lingua sbagliata. Questi test la trasformano in un errore. I testi
/// vivono ora in `content_xx.dart` (mappa `ui`); si leggono via `AppTexts`.
void main() {
  final byLocale = {for (final l in AppLocale.values) l: AppTexts.of(l)};
  final allKeys = {for (final map in byLocale.values) ...map.keys};

  test('ogni stringa esiste in tutte e cinque le lingue', () {
    final missing = <String>[];
    for (final key in allKeys) {
      for (final locale in AppLocale.values) {
        final value = byLocale[locale]![key];
        if (value == null || value.trim().isEmpty) {
          missing.add('$key → ${locale.code}');
        }
      }
    }
    expect(missing, isEmpty, reason: missing.join('\n'));
  });

  test('i segnaposto sono gli stessi in tutte le lingue', () {
    final pattern = RegExp(r'\{(\w+)\}');
    final problems = <String>[];

    for (final key in allKeys) {
      final reference = pattern
          .allMatches(byLocale[AppLocale.it]![key] ?? '')
          .map((m) => m.group(1))
          .toSet();
      for (final locale in AppLocale.values) {
        final found = pattern
            .allMatches(byLocale[locale]![key] ?? '')
            .map((m) => m.group(1))
            .toSet();
        if (found.length != reference.length || !found.containsAll(reference)) {
          problems.add('$key → ${locale.code}: $found != $reference');
        }
      }
    }
    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('i segnaposto vengono sostituiti', () {
    const t = Translator(AppLocale.en);
    expect(t('game.round_of', {'n': '3', 'total': '10'}), 'Round 3 of 10');
  });

  test('una chiave sconosciuta non fa esplodere niente', () {
    const t = Translator(AppLocale.fr);
    expect(t('chiave.che.non.esiste'), 'chiave.che.non.esiste');
  });

  test('il codice lingua di sistema viene riconosciuto', () {
    expect(AppLocale.fromSystem('fr_FR'), AppLocale.fr);
    expect(AppLocale.fromSystem('de-DE'), AppLocale.de);
    expect(AppLocale.fromSystem('pt_BR'), AppLocale.en); // ripiego sensato
  });
}
