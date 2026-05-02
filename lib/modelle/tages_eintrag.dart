/// Datenmodell für einen Tag.
/// Diese Klasse speichert Gewicht, Wasser, Schritte und Mahlzeiten.
class TagesEintrag {
  double gewicht;
  int wasser;
  int schritte;
  List<String> mahlzeiten;

  TagesEintrag({
    required this.gewicht,
    required this.wasser,
    required this.schritte,
    required this.mahlzeiten,
  });

  /// Erstellt einen Standard-Eintrag,
  /// falls noch keine gespeicherten Daten existieren.
  factory TagesEintrag.standard() {
    return TagesEintrag(
      gewicht: 80.0,
      wasser: 0,
      schritte: 0,
      mahlzeiten: [],
    );
  }
}