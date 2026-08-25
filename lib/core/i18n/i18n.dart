import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_locale.dart';
import 'translations.dart';

/// Traduce una chiave nella lingua scelta, con fallback su inglese e poi sulla
/// chiave stessa: meglio `lobby.players` a schermo che uno spazio vuoto.
class Translator {
  const Translator(this.locale);

  final AppLocale locale;

  String call(String key, [Map<String, String>? args]) {
    final entry = kTranslations[key];
    var value = entry?[locale.code] ?? entry?['en'] ?? key;
    if (args != null) {
      for (final arg in args.entries) {
        value = value.replaceAll('{${arg.key}}', arg.value);
      }
    }
    return value;
  }

  /// Singolare/plurale via chiave `_one` (le cinque lingue hanno due sole forme).
  String n(String key, int count, [Map<String, String>? args]) {
    final singular = '${key}_one';
    final chosen = count == 1 && kTranslations.containsKey(singular)
        ? singular
        : key;
    return call(chosen, {'n': '$count', ...?args});
  }
}

const _prefsKey = 'joyo.locale';

/// Lingua scelta dal gruppo. Parte da quella del telefono e resta salvata.
class LocaleNotifier extends Notifier<AppLocale> {
  bool _chosen = false;

  @override
  AppLocale build() {
    _restore();
    return AppLocale.fromSystem(
      ui.PlatformDispatcher.instance.locale.toString(),
    );
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    // Se l'utente ha già scelto in onboarding, il valore salvato non deve vincere.
    if (_chosen || !ref.mounted) return;
    final saved = prefs.getString(_prefsKey);
    if (saved != null) state = AppLocale.fromCode(saved);
  }

  Future<void> set(AppLocale locale) async {
    _chosen = true;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.code);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(
  LocaleNotifier.new,
);

/// `final t = ref.watch(tProvider);` e poi `t('home.create')`.
final tProvider = Provider<Translator>(
  (ref) => Translator(ref.watch(localeProvider)),
);
