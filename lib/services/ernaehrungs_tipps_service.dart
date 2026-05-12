/// Service für einfache Ernährungstipps.
class ErnaehrungsTippsService {

  static List<String> tippsFuerKalorien(int uebrig) {

    if (uebrig < 0) {
      return [
        'Heute eher leichte Mahlzeiten essen.',
        'Viel Wasser trinken.',
        'Ein kleiner Spaziergang könnte helfen.',
      ];
    }

    if (uebrig < 300) {
      return [
        'Heute passen noch kleine Snacks.',
        'Gemüse oder Obst wären gute Optionen.',
      ];
    }

    if (uebrig < 700) {
      return [
        'Eine normale Mahlzeit passt noch gut.',
        'Achte auf genug Eiweiß.',
      ];
    }

    return [
      'Du hast noch viele Kalorien übrig.',
      'Vergiss nicht genug zu essen.',
    ];
  }
}