import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider für App-Einstellungen.
/// Hier speichern wir Werte, die für die ganze App gelten.
/// Beispiel: Zielgewicht.
class EinstellungenProvider extends ChangeNotifier {
  
  static const String _zielGewichtSchluessel = 'ziel_gewicht'; 
  static const String _nameSchluessel = 'name';
  static const String _groesseSchluessel = 'groesse';
  static const String _startGewichtSchluessel = 'start_gewicht';
  static const String _wasserZielSchluessel = 'wasser_ziel';
  static const String _schritteZielSchluessel = 'schritte_ziel';

  double zielGewicht = 75.0;
  bool wirdGeladen = true;
  int wasserZiel = 8;
  int schritteZiel = 8000;
  String name = '';
  int groesse = 170;
  double startGewicht = 80.0;

  /// Lädt das gespeicherte Zielgewicht.
  Future<void> einstellungenLaden() async {
    final speicher = await SharedPreferences.getInstance();

    zielGewicht = speicher.getDouble(_zielGewichtSchluessel) ?? 75.0;
    name = speicher.getString(_nameSchluessel) ?? '';
    groesse = speicher.getInt(_groesseSchluessel) ?? 170;
    startGewicht = speicher.getDouble(_startGewichtSchluessel) ?? 80.0;
    wirdGeladen = false;
    wasserZiel = speicher.getInt(_wasserZielSchluessel) ?? 8;
    schritteZiel = speicher.getInt(_schritteZielSchluessel) ?? 8000;

    notifyListeners();
  }

  /// Speichert ein neues Zielgewicht.
  Future<void> zielGewichtSpeichern(double neuesZielGewicht) async {
    final speicher = await SharedPreferences.getInstance();

    zielGewicht = neuesZielGewicht;
    await speicher.setDouble(_zielGewichtSchluessel, neuesZielGewicht);

    notifyListeners();
  }

  /// Speichert den Namen des Nutzers.
  Future<void> nameSpeichern(String neuerName) async {
    final speicher = await SharedPreferences.getInstance();

    name = neuerName;
    await speicher.setString(_nameSchluessel, neuerName);

    notifyListeners();
  }

  /// Speichert die Körpergröße.
  Future<void> groesseSpeichern(int neueGroesse) async {
    final speicher = await SharedPreferences.getInstance();

    groesse = neueGroesse;
    await speicher.setInt(_groesseSchluessel, neueGroesse);

    notifyListeners();
  }

  /// Speichert das Startgewicht.
  Future<void> startGewichtSpeichern(double neuesStartGewicht) async {
    final speicher = await SharedPreferences.getInstance();

    startGewicht = neuesStartGewicht;
    await speicher.setDouble(_startGewichtSchluessel, neuesStartGewicht);

    notifyListeners();
  }
  /// Speichert das tägliche Wasserziel.
  Future<void> wasserZielSpeichern(int neuesWasserZiel) async {
    final speicher = await SharedPreferences.getInstance();

    wasserZiel = neuesWasserZiel;
    await speicher.setInt(_wasserZielSchluessel, neuesWasserZiel);

    notifyListeners();
  }

  /// Speichert das tägliche Schritteziel.
  Future<void> schritteZielSpeichern(int neuesSchritteZiel) async {
    final speicher = await SharedPreferences.getInstance();

    schritteZiel = neuesSchritteZiel;
    await speicher.setInt(_schritteZielSchluessel, neuesSchritteZiel);

    notifyListeners();
  }
}