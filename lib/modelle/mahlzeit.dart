/// Modell für eine Mahlzeit.
/// Speichert Text, Kategorie und Uhrzeit.
class Mahlzeit {
  final String text;
  final String kategorie;
  final String uhrzeit;

  Mahlzeit({
    required this.text,
    required this.kategorie,
    required this.uhrzeit,
  });

  Map<String, dynamic> zuJson() {
    return {
      'text': text,
      'kategorie': kategorie,
      'uhrzeit': uhrzeit,
    };
  }

  factory Mahlzeit.vonJson(Map<String, dynamic> json) {
    return Mahlzeit(
      text: json['text'] ?? '',
      kategorie: json['kategorie'] ?? '',
      uhrzeit: json['uhrzeit'] ?? '',
    );
  }
}