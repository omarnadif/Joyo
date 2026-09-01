import 'dart:math';
import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../i18n/i18n.dart';
import '../../features/settings/notifications_pref.dart';

/// Notifiche locali: promemoria "torna a giocare" pianificati dal telefono.
/// Nessun server, nessun costo. Il promemoria viene riprogrammato a ogni
/// apertura dell'app: se l'utente non torna entro [_comebackAfter], scatta.
class NotificationsService {
  NotificationsService._();

  /// Unico, perché va inizializzato una volta sola all'avvio (in `main`).
  static final instance = NotificationsService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Id fisso del promemoria: riusarlo fa sì che riprogrammare sostituisca il
  /// vecchio invece di accumularne tanti.
  static const _comebackId = 1001;

  /// Ora della sera in cui ricordare di giocare (24h). 20 = 20:00.
  static const _eveningHour = 20;

  /// Canale Android per i promemoria (richiesto da Android 8+).
  static const _channelId = 'joyo_reminders';

  /// Colore accento (tinta dell'icona piccola e del nome app): il viola Joyo.
  static const _accent = Color(0xFF7F77DD);

  /// Dettagli Android standard: icona piccola monocromatica JO/YO (regola
  /// Android) su tinta viola del marchio. Look pulito e minimale.
  AndroidNotificationDetails _android({bool high = false}) {
    return AndroidNotificationDetails(
      _channelId,
      'Promemoria',
      channelDescription: 'Promemoria per tornare a giocare',
      importance: high ? Importance.high : Importance.defaultImportance,
      priority: high ? Priority.high : Priority.defaultPriority,
      color: _accent,
    );
  }

  /// Prepara il plugin e il database dei fusi orari. Idempotente.
  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    // Icona piccola dedicata: silhouette bianca su trasparente (JO/YO). Il
    // logo a colori come icona di notifica diventerebbe un quadrato bianco.
    const android = AndroidInitializationSettings('ic_stat_joyo');
    const ios = DarwinInitializationSettings(
      // I permessi li chiediamo noi al momento giusto, non all'avvio.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _ready = true;
  }

  /// Richiesta di permesso in corso: condivisa tra chiamanti concorrenti, così
  /// non partono due prompt insieme (Android lancerebbe permissionRequestInProgress).
  Future<bool>? _permissionRequest;

  /// Chiede il permesso di mostrare notifiche (Android 13+ e iOS). Ritorna
  /// `true` se concesso. Se una richiesta è già in volo, riusa quella.
  Future<bool> requestPermission() {
    final pending = _permissionRequest;
    if (pending != null) return pending;
    final future = _doRequestPermission();
    _permissionRequest = future;
    future.whenComplete(() => _permissionRequest = null);
    return future;
  }

  /// Silenzioso dove non serve/non è supportato.
  Future<bool> _doRequestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  /// Attiva il promemoria serale: chiede il permesso e pianifica una notifica
  /// che si ripete OGNI SERA alle [_eveningHour]. Da chiamare a ogni apertura:
  /// così la frase mostrata cambia (ne pesca una a caso dal pool [messages]).
  Future<void> enableComeback({
    required List<({String title, String body})> messages,
  }) async {
    if (!_ready || messages.isEmpty) return;
    final granted = await requestPermission();
    if (!granted) return;
    await cancelAll();
    final pick = messages[Random().nextInt(messages.length)];
    final title = pick.title;
    final body = pick.body;
    final when = _nextEvening();
    final details = NotificationDetails(
      android: _android(),
      iOS: const DarwinNotificationDetails(),
    );
    try {
      await _plugin.zonedSchedule(
        _comebackId,
        title,
        body,
        when,
        details,
        // Inesatta: non richiede il permesso "sveglie esatte" su Android 12+.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Ripete ogni giorno alla stessa ora.
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Piattaforma senza scheduling (es. alcune configurazioni): nessun crash.
    }
  }

  /// Prossima occorrenza delle [_eveningHour] in ora locale: oggi se non è
  /// ancora passata, altrimenti domani. Uso `DateTime` locale (che conosce il
  /// fuso del telefono) e lo converto nell'istante UTC da pianificare.
  tz.TZDateTime _nextEvening() {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, _eveningHour);
    if (!target.isAfter(now)) target = target.add(const Duration(days: 1));
    return tz.TZDateTime.from(target, tz.UTC);
  }

  /// Cancella ogni promemoria pianificato (usato quando l'utente disattiva).
  Future<void> cancelAll() async {
    if (!_ready) return;
    await _plugin.cancelAll();
  }
}

/// Quante frasi "torna a giocare" esistono in traduzione
/// (notif.comeback_1..N). Aggiornalo se ne aggiungi/rimuovi.
const _comebackMessageCount = 8;

/// Tiene i promemoria allineati alla preferenza: quando è attiva li
/// (ri)pianifica, quando è spenta li cancella. Va tenuto vivo leggendolo una
/// volta all'avvio (vedi `app.dart`), così `fireImmediately` riprogramma a
/// ogni apertura dell'app.
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  final service = NotificationsService.instance;
  ref.listen<bool>(
    notificationsPrefProvider,
    (_, enabled) {
      if (enabled) {
        final t = Translator(ref.read(localeProvider));
        // Pool di frasi "torna a giocare": tante coppie titolo/corpo quante ne
        // esistono in traduzione (notif.comeback_1..N). Ne verrà pescata una.
        final messages = [
          for (var i = 1; i <= _comebackMessageCount; i++)
            (
              title: t('notif.comeback_${i}_title'),
              body: t('notif.comeback_${i}_body'),
            ),
        ];
        service.enableComeback(messages: messages);
      } else {
        service.cancelAll();
      }
    },
    fireImmediately: true,
  );
  return service;
});
