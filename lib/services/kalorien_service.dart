/// Service für Kalorienberechnung.
/// Berechnet:
/// - Grundumsatz
/// - Tagesbedarf
/// - Kalorienziel zum Abnehmen
/// - Geschätzte Abnehmzeit
class KalorienService {

  /// Grundumsatz berechnen (Mifflin-St Jeor Formel)
  static double grundumsatz({
    required bool istMaennlich,
    required int alter,
    required double gewicht,
    required double groesse,
  }) {

    if (istMaennlich) {
      return 10 * gewicht +
          6.25 * groesse -
          5 * alter +
          5;
    }

    return 10 * gewicht +
        6.25 * groesse -
        5 * alter -
        161;
  }

  /// Tagesbedarf mit Aktivität berechnen
  static double tagesbedarf({
    required double grundumsatz,
    required double aktivitaetsFaktor,
  }) {
    return grundumsatz * aktivitaetsFaktor;
  }

  /// Kalorienziel zum Abnehmen
  static double abnehmKalorien({
    required double tagesbedarf,
  }) {

    // 500 kcal Defizit pro Tag
    return tagesbedarf - 500;
  }

  /// Wochen bis Zielgewicht schätzen
  static int wochenBisZiel({
    required double aktuellesGewicht,
    required double zielGewicht,
  }) {

    final differenz = aktuellesGewicht - zielGewicht;

    if (differenz <= 0) {
      return 0;
    }

    // ungefähr 0.5 kg pro Woche
    return (differenz / 0.5).ceil();
  }

}