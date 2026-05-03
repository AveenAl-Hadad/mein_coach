import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../seiten/haupt_navigation.dart';
import '../provider/tages_provider.dart';
import '../provider/historie_provider.dart';

/// Hauptklasse der App.
/// Hier werden Provider, Design und Startseite festgelegt.
class MeineApp extends StatelessWidget {
  const MeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TagesProvider()..datenLaden(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistorieProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Mein Coach',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        home: const HauptNavigation(),
      ),
    );
  }
}