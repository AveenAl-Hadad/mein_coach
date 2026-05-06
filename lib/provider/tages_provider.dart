import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/tages_service.dart';
import 'historie_provider.dart';

/// Provider für den aktuellen TagesEintrag.
/// Er verwaltet Daten, Ladezustand und Änderungen.
class TagesProvider extends ChangeNotifier {
  final TagesService _service = TagesService();
  HistorieProvider? historieProvider;
  TagesEintrag eintrag = TagesEintrag.heute();
  bool wirdGeladen = true;

  /// Lädt den heutigen Eintrag.
  Future<void> datenLaden() async {
    eintrag = await _service.laden();
    wirdGeladen = false;
    notifyListeners();
  }

  /// Fügt eine Mahlzeit mit Kategorie hinzu.
    Future<void> mahlzeitHinzufuegen(
    String text, {
    String kategorie = 'Sonstiges',
    String? bildPfad,
  }) async {
    await _service.mahlzeitHinzufuegen(
      eintrag,
      text,
      kategorie: kategorie,
      bildPfad: bildPfad,
    );

    await historieAktualisieren();
    notifyListeners();
  }

  /// Löscht eine Mahlzeit.
  Future<void> mahlzeitLoeschen(int index) async {
    await _service.mahlzeitLoeschen(eintrag, index);
    await historieAktualisieren();
    notifyListeners();
  }

  /// Setzt den aktuell ausgewählten Tag zurück.
  Future<void> tagZuruecksetzen() async {
    eintrag = await _service.tagZuruecksetzen(eintrag.datum);
    await historieAktualisieren();
    notifyListeners();
  }

  /// Erhöht das Gewicht.
  Future<void> gewichtErhoehen() async {
    await _service.gewichtErhoehen(eintrag);
    await historieAktualisieren();
    notifyListeners();
  }

  /// Verringert das Gewicht.
  Future<void> gewichtVerringern() async {
    await _service.gewichtVerringern(eintrag);
    await historieAktualisieren();
    notifyListeners();
  }

  /// Setzt das Gewicht manuell.
  Future<void> gewichtSetzen(double wert) async {
    await _service.gewichtSetzen(eintrag, wert);
    await historieAktualisieren();
    notifyListeners();
  }

  /// Erhöht Wasser.
  Future<void> wasserErhoehen() async {
    await _service.wasserErhoehen(eintrag);
      await historieAktualisieren();

    notifyListeners();
  }
  Future<void> wasserVerringern() async {
    await _service.wasserVerringern(eintrag);
      await historieAktualisieren();

    notifyListeners();
  }

  /// Erhöht Schritte.
  Future<void> schritteErhoehen() async {
    await _service.schritteErhoehen(eintrag);
      await historieAktualisieren();

    notifyListeners();
  }
  Future<void> schritteVerringern() async {
    await _service.schritteVerringern(eintrag);
      await historieAktualisieren();

    notifyListeners();
  }



  /// Wechselt zu einem bestimmten Datum.
  Future<void> datumWechseln(String datum) async {
    wirdGeladen = true;
    notifyListeners();

    eintrag = await _service.eintragFuerDatumLaden(datum);

    wirdGeladen = false;
    await historieAktualisieren();
    notifyListeners();
  }

  /// Exportiert Daten als JSON.
  Future<String> exportieren() {
    return _service.exportieren();
  }
  /// Verbindet den TagesProvider mit dem HistorieProvider.
  /// So kann die Historie nach Änderungen automatisch neu geladen werden.
  void historieProviderSetzen(HistorieProvider provider) {
    historieProvider = provider;
  }
  /// Aktualisiert die Historie, falls sie verbunden ist.
  Future<void> historieAktualisieren() async {
    await historieProvider?.aktualisieren();
  }
  /// Ändert die Stimmung und speichert sie.
Future<void> stimmungSpeichern(String stimmung) async {
  await _service.stimmungSpeichern(eintrag, stimmung);
  await historieAktualisieren();
  notifyListeners();
}

/// Ändert die Tagesnotiz und speichert sie.
Future<void> notizSpeichern(String notiz) async {
  await _service.notizSpeichern(eintrag, notiz);
  await historieAktualisieren();
  notifyListeners();
}
}