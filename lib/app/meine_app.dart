import 'package:flutter/material.dart';
import '../seiten/haupt_navigation.dart';

/// Hauptklasse der App.
/// Hier werden Design, Titel und Startseite festgelegt.
class MeineApp extends StatelessWidget {
  const MeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mein Coach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HauptNavigation(),
    );
  }
}