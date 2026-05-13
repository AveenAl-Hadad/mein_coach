import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';
import 'dart:convert';
import '../modelle/mahlzeit.dart';


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
  Future<void> wasserVerringern(TagesEintrag eintrag) async {
    eintrag.wasser--;
    await speichern(eintrag);
  }
  Future<void> schritteErhoehen(TagesEintrag eintrag) async {
    eintrag.schritte += 500;
    await speichern(eintrag);
  }
  Future<void> schritteVerringern(TagesEintrag eintrag) async {
    eintrag.schritte -= 500;
    await speichern(eintrag);
  }
  
  Future<void> mahlzeitHinzufuegen(
  TagesEintrag eintrag,
  String text, {
  String kategorie = 'Sonstiges',
  String? bildPfad,
  required double menge,
  required String einheit,
  required String groesse,
  required int kalorienProEinheit,
  }) async {
    if (text.trim().isEmpty) return;

    final jetzt = DateTime.now();
    final stunde = jetzt.hour.toString().padLeft(2, '0');
    final minute = jetzt.minute.toString().padLeft(2, '0');

    double groessenFaktor = 1.0;

    if (groesse == 'klein') {
      groessenFaktor = 0.75;
    } else if (groesse == 'gross') {
      groessenFaktor = 1.25;
    }

    int berechneteKalorien = 0;

    if (einheit == 'gramm') {
      berechneteKalorien =
          ((menge / 100) * kalorienProEinheit * groessenFaktor).round();
    } else {
      berechneteKalorien =
          (menge * kalorienProEinheit * groessenFaktor).round();
    }

    final mahlzeit = Mahlzeit(
      text: text.trim(),
      kategorie: kategorie,
      uhrzeit: '$stunde:$minute',
      bildPfad: bildPfad,
      menge: menge,
      einheit: einheit,
      groesse: groesse,
      kalorienProEinheit: kalorienProEinheit,
      kalorien: berechneteKalorien,
    );

    eintrag.mahlzeiten.add(mahlzeit);
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
      stimmung: '🙂',
      notiz: '',
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
        stimmung: '🙂',
        notiz: '',
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
          'stimmung': e.stimmung,
          'notiz': e.notiz,
          'mahlzeiten': e.mahlzeiten.map((m) => m.zuJson()).toList(),
        }).toList();

    return jsonEncode(liste);
  }
  /// Speichert die Stimmung für den aktuellen Tag.
  Future<void> stimmungSpeichern(TagesEintrag eintrag, String stimmung) async {
    eintrag.stimmung = stimmung;
    await speichern(eintrag);
  }

  /// Speichert eine Tagesnotiz.
  Future<void> notizSpeichern(TagesEintrag eintrag, String notiz) async {
    eintrag.notiz = notiz;
    await speichern(eintrag);
  }

}