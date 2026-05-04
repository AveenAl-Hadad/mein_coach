import 'mahlzeit.dart';

/// Datenmodell für einen einzelnen Tag.
/// Diese Klasse beschreibt, welche Daten pro Tag gespeichert werden.
class TagesEintrag {
  String datum;
  double gewicht;
  int wasser;
  int schritte;
  List<Mahlzeit> mahlzeiten;
  String stimmung;
  String notiz;

  TagesEintrag({
    required this.datum,
    required this.gewicht,
    required this.wasser,
    required this.schritte,
    required this.mahlzeiten,
    required this.stimmung,
    required this.notiz,
  });

  /// Erstellt einen neuen Eintrag für heute.
  factory TagesEintrag.heute() {
    return TagesEintrag(
      datum: heutigesDatum(),
      gewicht: 80.0,
      wasser: 0,
      schritte: 0,
      stimmung: '🙂',
      notiz: '',
      mahlzeiten: [],
    );
  }

  /// Wandelt den Eintrag in eine Map um.
  /// Das brauchen wir, damit wir ihn speichern können.
  Map<String, dynamic> zuMap() {
    return {
      'datum': datum,
      'gewicht': gewicht,
      'wasser': wasser,
      'schritte': schritte,
      'stimmung': stimmung,
      'notiz': notiz,
      'mahlzeiten': mahlzeiten.map((mahlzeit) => mahlzeit.zuJson()).toList(),
    };
  }

  /// Erstellt einen TagesEintrag aus gespeicherten Daten.
  factory TagesEintrag.vonMap(Map<String, dynamic> map) {
    final gespeicherteMahlzeiten = map['mahlzeiten'] ?? [];

    return TagesEintrag(
      datum: map['datum'],
      gewicht: (map['gewicht'] as num).toDouble(),
      wasser: map['wasser'],
      schritte: map['schritte'],
      stimmung: map['stimmung'],
      notiz: map['notiz'],
      mahlzeiten: gespeicherteMahlzeiten.map<Mahlzeit>((mahlzeit) {
        if (mahlzeit is String) {
          return Mahlzeit(
            text: mahlzeit,
            kategorie: 'Sonstiges',
            uhrzeit: '',
          );
        }

        return Mahlzeit.vonJson(Map<String, dynamic>.from(mahlzeit));
      }).toList(),
    );
  }

  /// Gibt das heutige Datum als Text zurück.
  static String heutigesDatum() {
    final heute = DateTime.now();

    final monat = heute.month.toString().padLeft(2, '0');
    final tag = heute.day.toString().padLeft(2, '0');

    return '${heute.year}-$monat-$tag';
  }

  /// Erstellt eine kurze Zusammenfassung für Listen.
  String zusammenfassung() {
    return '${gewicht.toStringAsFixed(1)} kg • '
        '$wasser Gläser • '
        '$schritte Schritte • '
        '${mahlzeiten.length} Mahlzeiten';
  }
}