import 'package:flutter/material.dart';

/// Provider für das App-Theme.
/// Verwaltet, ob die App hell oder dunkel angezeigt wird.
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  /// Wechselt zwischen hell und dunkel.
  void themeWechseln() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }

    notifyListeners();
  }

  /// Prüft, ob aktuell Dark Mode aktiv ist.
  bool get istDunkel => themeMode == ThemeMode.dark;
}