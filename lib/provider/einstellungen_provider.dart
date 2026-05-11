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
  static const String _wasserErinnerungAktivSchluessel = 'wasser_erinnerung_aktiv';
  static const String _alterSchluessel = 'alter';
  static const String _istMaennlichSchluessel = 'ist_maennlich';
  static const String _aktivitaetsFaktorSchluessel = 'aktivitaets_faktor';

bool wasserErinnerungAktiv = false;

  double zielGewicht = 75.0;
  bool wirdGeladen = true;
  int wasserZiel = 8;
  int schritteZiel = 8000;
  String name = '';
  int groesse = 170;
  double startGewicht = 80.0;
  int alter = 18;
  bool istMaennlich = true;
  double aktivitaetsFaktor = 1.4;

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
    wasserErinnerungAktiv =
    speicher.getBool(_wasserErinnerungAktivSchluessel) ?? false;

    alter = speicher.getInt(_alterSchluessel) ?? 18;
    istMaennlich = speicher.getBool(_istMaennlichSchluessel) ?? true;
    aktivitaetsFaktor = speicher.getDouble(_aktivitaetsFaktorSchluessel) ?? 1.4;

    notifyListeners();
  }
  /// Speichert das Alter.
  Future<void> alterSpeichern(int neuesAlter) async {
    final speicher = await SharedPreferences.getInstance();

    alter = neuesAlter;
    await speicher.setInt(_alterSchluessel, neuesAlter);

    notifyListeners();
  }

  /// Speichert das Geschlecht.
  Future<void> geschlechtSpeichern(bool maennlich) async {
    final speicher = await SharedPreferences.getInstance();

    istMaennlich = maennlich;
    await speicher.setBool(_istMaennlichSchluessel, maennlich);

    notifyListeners();
  }

  /// Speichert den Aktivitätsfaktor.
  Future<void> aktivitaetsFaktorSpeichern(double neuerFaktor) async {
    final speicher = await SharedPreferences.getInstance();

    aktivitaetsFaktor = neuerFaktor;
    await speicher.setDouble(_aktivitaetsFaktorSchluessel, neuerFaktor);

    notifyListeners();
  }


  /// Speichert, ob Wasser-Erinnerungen aktiv sind.
  Future<void> wasserErinnerungAktivSpeichern(bool aktiv) async {
    final speicher = await SharedPreferences.getInstance();

    wasserErinnerungAktiv = aktiv;
    await speicher.setBool(_wasserErinnerungAktivSchluessel, aktiv);

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