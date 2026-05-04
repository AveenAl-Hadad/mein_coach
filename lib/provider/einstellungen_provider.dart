import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider für App-Einstellungen.
/// Hier speichern wir Werte, die für die ganze App gelten.
/// Beispiel: Zielgewicht.
class EinstellungenProvider extends ChangeNotifier {
  static const String _zielGewichtSchluessel = 'ziel_gewicht';

  double zielGewicht = 75.0;
  bool wirdGeladen = true;

  /// Lädt das gespeicherte Zielgewicht.
  Future<void> einstellungenLaden() async {
    final speicher = await SharedPreferences.getInstance();

    zielGewicht = speicher.getDouble(_zielGewichtSchluessel) ?? 75.0;
    wirdGeladen = false;

    notifyListeners();
  }

  /// Speichert ein neues Zielgewicht.
  Future<void> zielGewichtSpeichern(double neuesZielGewicht) async {
    final speicher = await SharedPreferences.getInstance();

    zielGewicht = neuesZielGewicht;
    await speicher.setDouble(_zielGewichtSchluessel, neuesZielGewicht);

    notifyListeners();
  }
}