import 'package:flutter/material.dart';
import '../seiten/haupt_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/tages_provider.dart';
import '../seiten/haupt_navigation.dart';

/// Hauptklasse der App.
/// Hier werden Provider, Design und Startseite festgelegt.
class MeineApp extends StatelessWidget {
  const MeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TagesProvider()..datenLaden(),
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