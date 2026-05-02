class TagesEintrag {
  String datum; // NEU
  double gewicht;
  int wasser;
  int schritte;
  List<String> mahlzeiten;

  TagesEintrag({
    required this.datum,
    required this.gewicht,
    required this.wasser,
    required this.schritte,
    required this.mahlzeiten,
  });

  factory TagesEintrag.heute() {
    final heute = DateTime.now();
    final datumText =
        "${heute.year}-${heute.month}-${heute.day}";

    return TagesEintrag(
      datum: datumText,
      gewicht: 80.0,
      wasser: 0,
      schritte: 0,
      mahlzeiten: [],
    );
  }
}