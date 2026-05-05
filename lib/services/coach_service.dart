import '../modelle/tages_eintrag.dart';

/// Einfacher KI-Coach (regelbasiert).
/// Später kann hier echte KI integriert werden.
class CoachService {
  /// Erstellt einen personalisierten Hinweis.
  String erstelleHinweis({
    required List<TagesEintrag> tage,
    required int wasserZiel,
    required int schritteZiel,
  }) {
    if (tage.isEmpty) {
      return 'Starte mit deinem ersten Eintrag.';
    }

    final letzteTage = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    final letzte7 = letzteTage.take(7).toList();

    final avgWasser = letzte7
            .map((t) => t.wasser)
            .reduce((a, b) => a + b) /
        letzte7.length;

    final avgSchritte = letzte7
            .map((t) => t.schritte)
            .reduce((a, b) => a + b) /
        letzte7.length;

    final erstesGewicht = letzte7.last.gewicht;
    final letztesGewicht = letzte7.first.gewicht;
    final diff = letztesGewicht - erstesGewicht;

    // Priorität: Wasser
    if (avgWasser < wasserZiel) {
      return 'Du trinkst im Schnitt zu wenig Wasser. Versuche heute öfter zu trinken 💧';
    }

    // Schritte
    if (avgSchritte < schritteZiel) {
      return 'Deine Schritte sind unter deinem Ziel. Ein Spaziergang hilft 🚶';
    }

    // Gewicht
    if (diff > 0.3) {
      return 'Dein Gewicht steigt diese Woche leicht. Achte auf deine Ernährung 🍽️';
    }

    if (diff < -0.3) {
      return 'Super! Dein Gewicht entwickelt sich in die richtige Richtung 🎉';
    }

    return 'Gute Arbeit! Bleib dran 💪';
  }
}