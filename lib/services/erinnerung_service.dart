import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service für lokale Erinnerungen.
/// Diese Klasse kümmert sich um Benachrichtigungen auf dem Gerät.
class ErinnerungService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialisiert die Benachrichtigungen.
  Future<void> starten() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
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

  /// Berechnet den nächsten Zeitpunkt für eine tägliche Erinnerung.
tz.TZDateTime naechsteUhrzeit(int stunde, int minute) {
  final jetzt = tz.TZDateTime.now(tz.local);

  var geplant = tz.TZDateTime(
    tz.local,
    jetzt.year,
    jetzt.month,
    jetzt.day,
    stunde,
    minute,
  );

  if (geplant.isBefore(jetzt)) {
    geplant = geplant.add(const Duration(days: 1));
  }

  return geplant;
}
/// Plant Wasser-Erinnerungen zu festen Tageszeiten.
Future<void> wasserErinnerungenZuEchtenZeitenStarten() async {
  await stopAlleErinnerungen();

  const androidDetails = AndroidNotificationDetails(
    'wasser_erinnerung_feste_zeiten',
    'Wasser Erinnerung feste Zeiten',
    channelDescription: 'Erinnerungen zum Wasser trinken zu festen Zeiten',
    importance: Importance.high,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidDetails);

  final zeiten = [
    [8, 0],
    [10, 0],
    [12, 0],
    [14, 0],
    [16, 0],
    [18, 0],
    [20, 0],
  ];

  for (int i = 0; i < zeiten.length; i++) {
    final stunde = zeiten[i][0];
    final minute = zeiten[i][1];

    await _plugin.zonedSchedule(
      id: 100 + i,
      title: 'Wasser trinken 💧',
      body: 'Zeit für ein Glas Wasser.',
      scheduledDate: naechsteUhrzeit(stunde, minute),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
}