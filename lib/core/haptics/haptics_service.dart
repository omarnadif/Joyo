import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// I tipi di vibrazione usati nell'app, dal più leggero al più deciso.
enum Haptic {
  /// Tocco impercettibile: selezioni, voti, cambio pagina.
  selection,

  /// Colpetto leggero: pressione dei pulsanti principali.
  light,

  /// Colpo medio: reveal del risultato, stop della ruota.
  medium,

  /// Colpo forte (usato di rado).
  heavy,
}

/// Piccole vibrazioni di feedback. Come il suono: gated da un flag persistito e
/// silenziosa (nessun errore) dove la piattaforma non le supporta (web/desktop).
class HapticsService {
  HapticsService({required bool enabled}) : _enabled = enabled;

  bool _enabled;

  set enabled(bool value) => _enabled = value;

  /// Fa scattare la vibrazione [h]. Fire-and-forget: non propaga errori.
  Future<void> fire(Haptic h) async {
    if (!_enabled) return;
    try {
      switch (h) {
        case Haptic.selection:
          await HapticFeedback.selectionClick();
        case Haptic.light:
          await HapticFeedback.lightImpact();
        case Haptic.medium:
          await HapticFeedback.mediumImpact();
        case Haptic.heavy:
          await HapticFeedback.heavyImpact();
      }
    } catch (_) {
      // Piattaforma senza motore aptico: nessuna vibrazione, nessun crash.
    }
  }
}

const _hapticsPrefKey = 'joyo.haptics_enabled';

/// Se le vibrazioni sono attive; `true` di default finché non si legge il disco.
class HapticsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    state = prefs.getBool(_hapticsPrefKey) ?? true;
  }

  Future<void> toggle() => set(!state);

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsPrefKey, value);
  }
}

final hapticsEnabledProvider = NotifierProvider<HapticsEnabledNotifier, bool>(
  HapticsEnabledNotifier.new,
);

/// Il servizio aptico condiviso; tiene il proprio flag allineato al provider.
final hapticsServiceProvider = Provider<HapticsService>((ref) {
  final service = HapticsService(enabled: ref.read(hapticsEnabledProvider));
  ref.listen<bool>(
    hapticsEnabledProvider,
    (_, next) => service.enabled = next,
    fireImmediately: true,
  );
  return service;
});
