import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gli effetti sonori dell'app. I file stanno in assets/sounds/ (vedi pubspec).
/// Ogni voce porta il proprio volume di base (0..1): tenuto basso per un tono
/// leggero e dolce. Alza/abbassa qui per regolare la resa complessiva.
enum Sfx {
  /// Fruscio: sfoglio delle card di gioco e cambio pagina nell'onboarding.
  swish('sounds/swish.wav', 0.45),

  /// Tocco breve: quando si vota / si sceglie.
  tap('sounds/tap.wav', 0.5),

  /// Campanella: reveal del risultato e stop della ruota.
  ding('sounds/ding.wav', 0.5),

  /// Treno di click che decelera: la ruota/bottiglia che gira.
  spin('sounds/spin.wav', 0.4);

  const Sfx(this.asset, this.volume);

  final String asset;

  /// Volume di base con cui riprodurre questo effetto.
  final double volume;
}

/// Riproduce brevi effetti sonori senza bloccare l'interfaccia. Tiene un piccolo
/// pool di player a rotazione così due suoni ravvicinati non si tagliano fra
/// loro; se un asset manca o la piattaforma non ha backend audio (es. desktop
/// in dev) fallisce in silenzio, mai far crashare il gioco per un suono.
class SoundService {
  SoundService({required bool enabled}) : _enabled = enabled;

  static const _poolSize = 4;
  final List<AudioPlayer> _pool = [];
  int _next = 0;
  bool _enabled;
  bool _disposed = false;

  set enabled(bool value) => _enabled = value;

  AudioPlayer _acquire() {
    if (_pool.length < _poolSize) {
      final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _pool.add(player);
      return player;
    }
    final player = _pool[_next];
    _next = (_next + 1) % _poolSize;
    return player;
  }

  /// Suona [sfx]. Fire-and-forget: non attende la fine e non propaga errori.
  /// Senza [volume] usa il volume di base dell'effetto ([Sfx.volume]).
  Future<void> play(Sfx sfx, {double? volume}) async {
    if (!_enabled || _disposed) return;
    try {
      final player = _acquire();
      await player.stop();
      await player.play(AssetSource(sfx.asset), volume: volume ?? sfx.volume);
    } catch (_) {
      // Backend audio assente o asset mancante: si resta in silenzio.
    }
  }

  void dispose() {
    _disposed = true;
    for (final player in _pool) {
      player.dispose();
    }
    _pool.clear();
  }
}

const _soundPrefKey = 'joyo.sound_enabled';

/// Se gli effetti sonori sono attivi; `true` di default finché non si legge il
/// disco. Persistito su SharedPreferences come l'onboarding e la lingua.
class SoundEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    state = prefs.getBool(_soundPrefKey) ?? true;
  }

  Future<void> toggle() => set(!state);

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundPrefKey, value);
  }
}

final soundEnabledProvider = NotifierProvider<SoundEnabledNotifier, bool>(
  SoundEnabledNotifier.new,
);

/// Il servizio audio condiviso. Tiene il proprio flag allineato a
/// [soundEnabledProvider] e rilascia i player alla chiusura.
final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundService(enabled: ref.read(soundEnabledProvider));
  ref.listen<bool>(
    soundEnabledProvider,
    (_, next) => service.enabled = next,
    fireImmediately: true,
  );
  ref.onDispose(service.dispose);
  return service;
});
