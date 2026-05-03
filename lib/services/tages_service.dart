import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';
import 'dart:convert';


/// Service für alle Logik rund um TagesEintrag.
/// UI soll nur anzeigen – Logik passiert hier.
class TagesService {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  Future<TagesEintrag> laden() {
    return _speicher.heutigenEintragLaden();
  }

  Future<void> speichern(TagesEintrag eintrag) {
    return _speicher.heutigenEintragSpeichern(eintrag);
  }

  Future<void> gewichtErhoehen(TagesEintrag eintrag) async {
    eintrag.gewicht += 0.1;
    await speichern(eintrag);
  }

  Future<void> gewichtVerringern(TagesEintrag eintrag) async {
    eintrag.gewicht -= 0.1;
    await speichern(eintrag);
  }

  Future<void> wasserErhoehen(TagesEintrag eintrag) async {
    eintrag.wasser++;
    await speichern(eintrag);
  }

  Future<void> schritteErhoehen(TagesEintrag eintrag) async {
    eintrag.schritte += 500;
    await speichern(eintrag);
  }

  Future<void> mahlzeitHinzufuegen(
    TagesEintrag eintrag,
    String text,
  ) async {
    if (text.trim().isEmpty) return;

    eintrag.mahlzeiten.add(text.trim());
    await speichern(eintrag);
  }

  Future<void> mahlzeitLoeschen(
    TagesEintrag eintrag,
    int index,
  ) async {
    eintrag.mahlzeiten.removeAt(index);
    await speichern(eintrag);
  }

 /// Setzt einen bestimmten Tag zurück.
  Future<TagesEintrag> tagZuruecksetzen(String datum) async {
    final neuerEintrag = TagesEintrag(
      datum: datum,
      gewicht: 80.0,
      wasser: 0,
      schritte: 0,
      mahlzeiten: [],
    );

    await speichern(neuerEintrag);

    return neuerEintrag;
  }
  /// Setzt das Gewicht manuell.
  Future<void> gewichtSetzen(TagesEintrag eintrag, double neuesGewicht,) async {
    eintrag.gewicht = neuesGewicht;
    await speichern(eintrag);
  }

  /// Lädt einen Eintrag für ein bestimmtes Datum.
  /// Falls es keinen Eintrag gibt, wird ein neuer erstellt.
  Future<TagesEintrag> eintragFuerDatumLaden(String datum) async {
    final tage = await _speicher.alleTageLaden();

    try {
      return tage.firstWhere((e) => e.datum == datum);
    } catch (_) {
      return TagesEintrag(
        datum: datum,
        gewicht: 80.0,
        wasser: 0,
        schritte: 0,
        mahlzeiten: [],
      );
    }
  }

  /// Exportiert alle Daten als JSON String.
Future<String> exportieren() async {
  final tage = await _speicher.alleTageLaden();

  final liste = tage.map((e) => {
        'datum': e.datum,
        'gewicht': e.gewicht,
        'wasser': e.wasser,
        'schritte': e.schritte,
        'mahlzeiten': e.mahlzeiten,
      }).toList();

  return jsonEncode(liste);
}
}