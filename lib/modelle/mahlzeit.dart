/// Modell für eine Mahlzeit.
/// Speichert Text, Kategorie und Uhrzeit.
class Mahlzeit {
  final String text;
  final String kategorie;
  final String uhrzeit;
  final String? bildPfad;

  Mahlzeit({
    required this.text,
    required this.kategorie,
    required this.uhrzeit,
    this.bildPfad,
  });

  Map<String, dynamic> zuJson() {
    return {
      'text': text,
      'kategorie': kategorie,
      'uhrzeit': uhrzeit,
      'bildPfad': bildPfad,
    };
  }

  factory Mahlzeit.vonJson(Map<String, dynamic> json) {
    return Mahlzeit(
      text: json['text'] ?? '',
      kategorie: json['kategorie'] ?? '',
      uhrzeit: json['uhrzeit'] ?? '',
      bildPfad: json['bildPfad'],
    );
  }
}