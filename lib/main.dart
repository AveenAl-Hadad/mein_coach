import 'package:flutter/material.dart';

import 'app/meine_app.dart';
import 'services/erinnerung_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final erinnerungService = ErinnerungService();
  await erinnerungService.starten();

  runApp(const MeineApp());
}