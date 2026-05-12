/// Service für einfache Mahlzeiten-Vorschläge.
class MahlzeitenVorschlagService {
  static List<String> vorschlaegeFuerKalorien(int uebrig) {
    if (uebrig <= 0) {
      return [
        'Gurke, Tomaten und Wasser',
        'Ungesüßter Tee',
      ];
    }

    if (uebrig <= 300) {
      return [
        'Joghurt mit Beeren',
        'Apfel mit etwas Erdnussbutter',
        'Gemüsesticks mit Kräuterquark',
      ];
    }

    if (uebrig <= 600) {
      return [
        'Hähnchen mit Reis und Gemüse',
        'Omelett mit Salat',
        'Vollkornbrot mit Ei',
      ];
    }

    return [
      'Lachs mit Kartoffeln und Gemüse',
      'Pasta mit Tomatensoße und Salat',
      'Bowl mit Reis, Gemüse und Eiweißquelle',
    ];
  }
}