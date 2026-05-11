/// Modell für eine Mahlzeit.
/// Speichert Text, Kategorie, Uhrzeit, Bild und Kalorien.
class Mahlzeit {
  final String text;
  final String kategorie;
  final String uhrzeit;
  final String? bildPfad;
  final int kalorien;

  Mahlzeit({
    required this.text,
    required this.kategorie,
    required this.uhrzeit,
    this.bildPfad,
    this.kalorien = 0,
  });

  Map<String, dynamic> zuJson() {
    return {
      'text': text,
      'kategorie': kategorie,
      'uhrzeit': uhrzeit,
      'bildPfad': bildPfad,
      'kalorien': kalorien,
    };
  }

  factory Mahlzeit.vonJson(Map<String, dynamic> json) {
    return Mahlzeit(
      text: json['text'] ?? '',
      kategorie: json['kategorie'] ?? '',
      uhrzeit: json['uhrzeit'] ?? '',
      bildPfad: json['bildPfad'],
      kalorien: json['kalorien'] ?? 0,
    );
  }
}