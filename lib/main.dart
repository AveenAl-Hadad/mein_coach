import 'package:flutter/material.dart';

import 'app/meine_app.dart';
import 'services/erinnerung_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final erinnerungService = ErinnerungService();
  await erinnerungService.starten();

  // 🔥 Einstellungen laden
  final speicher = await SharedPreferences.getInstance();
  final erinnerungAktiv =
      speicher.getBool('wasser_erinnerung_aktiv') ?? false;

  // 🔔 Wenn aktiv → automatisch starten
  if (erinnerungAktiv) {
    await erinnerungService.wasserErinnerungenZuEchtenZeitenStarten();
  }

  runApp(const MeineApp());
}