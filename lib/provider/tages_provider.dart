import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/tages_service.dart';

/// Provider für den aktuellen TagesEintrag.
/// Er verwaltet Daten, Ladezustand und Änderungen.
class TagesProvider extends ChangeNotifier {
  final TagesService _service = TagesService();

  TagesEintrag eintrag = TagesEintrag.heute();
  bool wirdGeladen = true;

  /// Lädt den heutigen Eintrag.
  Future<void> datenLaden() async {
    eintrag = await _service.laden();
    wirdGeladen = false;
    notifyListeners();
  }

  /// Fügt eine Mahlzeit hinzu.
  Future<void> mahlzeitHinzufuegen(String text) async {
    await _service.mahlzeitHinzufuegen(eintrag, text);
    notifyListeners();
  }

  /// Löscht eine Mahlzeit.
  Future<void> mahlzeitLoeschen(int index) async {
    await _service.mahlzeitLoeschen(eintrag, index);
    notifyListeners();
  }

  /// Setzt den aktuell ausgewählten Tag zurück.
  Future<void> tagZuruecksetzen() async {
    eintrag = await _service.tagZuruecksetzen(eintrag.datum);
    notifyListeners();
  }

  /// Erhöht das Gewicht.
  Future<void> gewichtErhoehen() async {
    await _service.gewichtErhoehen(eintrag);
    notifyListeners();
  }

  /// Verringert das Gewicht.
  Future<void> gewichtVerringern() async {
    await _service.gewichtVerringern(eintrag);
    notifyListeners();
  }

  /// Setzt das Gewicht manuell.
  Future<void> gewichtSetzen(double wert) async {
    await _service.gewichtSetzen(eintrag, wert);
    notifyListeners();
  }

  /// Erhöht Wasser.
  Future<void> wasserErhoehen() async {
    await _service.wasserErhoehen(eintrag);
    notifyListeners();
  }

  /// Erhöht Schritte.
  Future<void> schritteErhoehen() async {
    await _service.schritteErhoehen(eintrag);
    notifyListeners();
  }

  /// Wechselt zu einem bestimmten Datum.
  Future<void> datumWechseln(String datum) async {
    wirdGeladen = true;
    notifyListeners();

    eintrag = await _service.eintragFuerDatumLaden(datum);

    wirdGeladen = false;
    notifyListeners();
  }

  /// Exportiert Daten als JSON.
  Future<String> exportieren() {
    return _service.exportieren();
  }
}