import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider für das App-Theme.
/// Speichert, ob hell oder dunkel aktiv ist.
class ThemeProvider extends ChangeNotifier {
  static const String _themeSchluessel = 'theme_mode';

  ThemeMode themeMode = ThemeMode.system;

  bool get istDunkel => themeMode == ThemeMode.dark;

  /// Lädt das gespeicherte Theme beim App-Start.
  Future<void> themeLaden() async {
    final speicher = await SharedPreferences.getInstance();
    final gespeicherterWert = speicher.getString(_themeSchluessel);

    if (gespeicherterWert == 'dark') {
      themeMode = ThemeMode.dark;
    } else if (gespeicherterWert == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  /// Wechselt zwischen hell und dunkel und speichert die Auswahl.
  Future<void> themeWechseln() async {
    final speicher = await SharedPreferences.getInstance();

    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
      await speicher.setString(_themeSchluessel, 'light');
    } else {
      themeMode = ThemeMode.dark;
      await speicher.setString(_themeSchluessel, 'dark');
    }

    notifyListeners();
  }
}