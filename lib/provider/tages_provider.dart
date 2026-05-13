import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/tages_service.dart';
import 'historie_provider.dart';
import '../services/firebase_sync_service.dart';


/// Provider für den aktuellen TagesEintrag.
/// Er verwaltet Daten, Ladezustand und Änderungen.
class TagesProvider extends ChangeNotifier {
  final TagesService _service = TagesService();
  final FirebaseSyncService _syncService = FirebaseSyncService();

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
  required double menge,
  required String einheit,
  required String groesse,
  required int kalorienProEinheit,
}) async {
  await _service.mahlzeitHinzufuegen(
    eintrag,
    text,
    kategorie: kategorie,
    bildPfad: bildPfad,
    menge: menge,
    einheit: einheit,
    groesse: groesse,
    kalorienProEinheit: kalorienProEinheit,
  );

  await historieAktualisierenUndSynchronisieren();
}

  /// Löscht eine Mahlzeit.
  Future<void> mahlzeitLoeschen(int index) async {
    await _service.mahlzeitLoeschen(eintrag, index);
   await historieAktualisierenUndSynchronisieren();
  }

  /// Setzt den aktuell ausgewählten Tag zurück.
  Future<void> tagZuruecksetzen() async {
    eintrag = await _service.tagZuruecksetzen(eintrag.datum);
    await historieAktualisierenUndSynchronisieren();
  }

  /// Erhöht das Gewicht.
  Future<void> gewichtErhoehen() async {
    await _service.gewichtErhoehen(eintrag);
    await historieAktualisierenUndSynchronisieren();
   
  }

  /// Verringert das Gewicht.
  Future<void> gewichtVerringern() async {
    await _service.gewichtVerringern(eintrag);
    await historieAktualisierenUndSynchronisieren();
  }

  /// Setzt das Gewicht manuell.
  Future<void> gewichtSetzen(double wert) async {
    await _service.gewichtSetzen(eintrag, wert);
    await historieAktualisierenUndSynchronisieren();
  }

  /// Erhöht Wasser.
  Future<void> wasserErhoehen() async {
    await _service.wasserErhoehen(eintrag);
    await historieAktualisierenUndSynchronisieren();
  }
  Future<void> wasserVerringern() async {
    await _service.wasserVerringern(eintrag);
    await historieAktualisierenUndSynchronisieren();
  }

  /// Erhöht Schritte.
  Future<void> schritteErhoehen() async {
    await _service.schritteErhoehen(eintrag);
    await historieAktualisierenUndSynchronisieren();
  }
  Future<void> schritteVerringern() async {
    await _service.schritteVerringern(eintrag);
    await historieAktualisierenUndSynchronisieren();    
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

  Future<void> historieAktualisierenUndSynchronisieren() async {
  await historieAktualisieren();

  try {
    await _syncService.cloudUpload();
  } catch (_) {
    // App funktioniert offline weiter, auch wenn Cloud Sync nicht eingerichtet ist.
  }

  notifyListeners();
}
  /// Aktualisiert die Historie, falls sie verbunden ist.
  Future<void> historieAktualisieren() async {
    await historieProvider?.aktualisieren();
  }
  /// Ändert die Stimmung und speichert sie.
Future<void> stimmungSpeichern(String stimmung) async {
  await _service.stimmungSpeichern(eintrag, stimmung);
  await historieAktualisierenUndSynchronisieren();
}

/// Ändert die Tagesnotiz und speichert sie.
Future<void> notizSpeichern(String notiz) async {
  await _service.notizSpeichern(eintrag, notiz);
  await historieAktualisierenUndSynchronisieren();
}
}