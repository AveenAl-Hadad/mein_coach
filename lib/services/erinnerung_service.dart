import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service für lokale Erinnerungen.
/// Diese Klasse kümmert sich um Benachrichtigungen auf dem Gerät.
class ErinnerungService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialisiert die Benachrichtigungen.
  Future<void> starten() async {
    const androidEinstellungen = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const einstellungen = InitializationSettings(
      android: androidEinstellungen,
    );

    await _plugin.initialize(
      settings: einstellungen,
    );

    await erlaubnisAnfragen();
  }

  /// Fragt die Benachrichtigungs-Erlaubnis auf Android an.
  Future<void> erlaubnisAnfragen() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  /// Zeigt sofort eine Test-Erinnerung an.
  Future<void> testErinnerungAnzeigen() async {
    const androidDetails = AndroidNotificationDetails(
      'wasser_erinnerung',
      'Wasser Erinnerung',
      channelDescription: 'Erinnerungen zum Wasser trinken',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: 1,
      title: 'Wasser trinken 💧',
      body: 'Zeit für ein Glas Wasser.',
      notificationDetails: details,
    );
  }
  /// Startet eine wiederholende Wasser-Erinnerung.
  /// Alle 2 Stunden wird eine Benachrichtigung angezeigt.
  Future<void> wasserErinnerungStarten() async {
    const androidDetails = AndroidNotificationDetails(
      'wasser_erinnerung',
      'Wasser Erinnerung',
      channelDescription: 'Erinnerungen zum Wasser trinken',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

   await _plugin.periodicallyShow(
    id: 2,
    title: 'Wasser trinken 💧',
    body: 'Zeit für ein Glas Wasser.',
    repeatInterval: RepeatInterval.everyMinute,
    notificationDetails: details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
  }
  /// Stoppt alle Erinnerungen.
  Future<void> stopAlleErinnerungen() async {
    await _plugin.cancelAll();
  }
}