import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../modelle/tages_eintrag.dart';

class KiErinnerungService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialisieren() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

   await _notifications.initialize(
    settings:settings,
   );
    
  }

  Future<void> motivationSenden({
    required TagesEintrag eintrag,
    required int wasserZiel,
    required int schritteZiel,
  }) async {
    String titel = 'Mein Coach';
    String text = 'Weiter so 💪';

    if (eintrag.wasser < wasserZiel) {
      titel = 'Wasser Erinnerung 💧';
      text = 'Du solltest heute noch mehr trinken.';
    } else if (eintrag.schritte < schritteZiel) {
      titel = 'Schritte Erinnerung 🚶';
      text = 'Ein kleiner Spaziergang würde helfen.';
    } else if (eintrag.notiz.trim().isEmpty) {
      titel = 'Tagesreflexion 📝';
      text = 'Schreibe eine kurze Tagesnotiz.';
    } else {
      titel = 'Starker Tag 🔥';
      text = 'Du machst heute richtig gute Fortschritte.';
    }

    const androidDetails = AndroidNotificationDetails(
      'ki_erinnerungen',
      'KI Erinnerungen',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id: 999,
      title: titel,
      body: text,
      notificationDetails: details,
    );
  }
}