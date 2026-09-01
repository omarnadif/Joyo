import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'joyo.notifications';

/// Preferenza locale "voglio ricevere notifiche". Per ora è solo salvata: quando
/// arriverà il sistema di push (promemoria, novità) leggerà questo flag per
/// decidere se registrare il dispositivo. Parte attiva.
class NotificationsPref extends Notifier<bool> {
  @override
  bool build() {
    _restore();
    return true;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    final saved = prefs.getBool(_prefsKey);
    if (saved != null) state = saved;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}

final notificationsPrefProvider = NotifierProvider<NotificationsPref, bool>(
  NotificationsPref.new,
);
