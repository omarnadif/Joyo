import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'joyo.onboarded';

/// Se la presentazione iniziale è già stata vista.
/// `null` mentre lo stiamo ancora leggendo dal disco.
class OnboardingNotifier extends Notifier<bool?> {
  @override
  bool? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> complete() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  /// Utile per rivedere la presentazione dalle impostazioni.
  Future<void> reset() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, bool?>(
  OnboardingNotifier.new,
);
