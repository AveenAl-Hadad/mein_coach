import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

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

  Future<void> zuruecksetzen() async {
    final neu = TagesEintrag.heute();
    await speichern(neu);
  }
}