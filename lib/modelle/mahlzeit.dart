/// Modell für eine Mahlzeit.
/// Speichert Text, Kategorie, Uhrzeit, Bild und Kalorien.
class Mahlzeit {
  final String text;
  final String kategorie;
  final String uhrzeit;
  final String? bildPfad;
  final int kalorien;
  final double menge;
  final String einheit; // gramm oder stueck
  final String groesse; // klein, normal, gross
  final int kalorienProEinheit;


  Mahlzeit({
    required this.text,
    required this.kategorie,
    required this.uhrzeit,
    this.bildPfad,
    this.kalorien = 0,
    this.menge = 0,
    this.einheit = 'gramm',
    this.groesse = 'normal',
    this.kalorienProEinheit = 0,
  });

  Map<String, dynamic> zuJson() {
    return {
      'text': text,
      'kategorie': kategorie,
      'uhrzeit': uhrzeit,
      'bildPfad': bildPfad,
      'kalorien': kalorien,
      'menge': menge,
      'einheit': einheit,
      'groesse': groesse,
      'kalorienProEinheit': kalorienProEinheit,
    };
  }

  factory Mahlzeit.vonJson(Map<String, dynamic> json) {
    return Mahlzeit(
      text: json['text'] ?? '',
      kategorie: json['kategorie'] ?? '',
      uhrzeit: json['uhrzeit'] ?? '',
      bildPfad: json['bildPfad'],
      kalorien: json['kalorien'] ?? 0,
      menge: (json['menge'] ?? 0).toDouble(),
      einheit: json['einheit'] ?? 'gramm',    
      groesse: json['groesse'] ?? 'normal',
      kalorienProEinheit: json['kalorienProEinheit'] ?? 0,
    );
  }
}