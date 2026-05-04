import 'package:flutter/material.dart';
import 'package:mein_coach/style/app_style.dart';
import 'package:provider/provider.dart';

import '../seiten/haupt_navigation.dart';
import '../provider/tages_provider.dart';
import '../provider/historie_provider.dart';
import '../provider/theme_provider.dart';

/// Hauptklasse der App.
/// Hier werden Provider, Design und Startseite festgelegt.
class MeineApp extends StatelessWidget {
  const MeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider()..themeLaden(),
      ),
      ChangeNotifierProvider(
        create: (_) => HistorieProvider()..tageLaden(),
      ),
      ChangeNotifierProxyProvider<HistorieProvider, TagesProvider>(
        create: (_) => TagesProvider()..datenLaden(),
        update: (_, historieProvider, tagesProvider) {
          final provider = tagesProvider ?? TagesProvider();

          provider.historieProviderSetzen(historieProvider);

          return provider;
        },
      ),
    ],
    child: Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Mein Coach',
          debugShowCheckedModeBanner: false,
          theme: AppStyle.hellesTheme,
          darkTheme: AppStyle.dunklesTheme,
          themeMode: themeProvider.themeMode,
          home: const HauptNavigation(),
        );
      },
    ),
  );
  }
}