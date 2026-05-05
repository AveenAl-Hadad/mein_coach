import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Karte für die Wochenanalyse.
/// Sie berechnet Durchschnittswerte und erstellt einfache Bewertungen.
class WochenanalyseKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const WochenanalyseKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  List<TagesEintrag> letzteSiebenTage() {
    final sortierteTage = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    return sortierteTage.take(7).toList();
  }

  double durchschnittDouble(List<double> werte) {
    if (werte.isEmpty) return 0;
    return werte.reduce((a, b) => a + b) / werte.length;
  }

  double durchschnittInt(List<int> werte) {
    if (werte.isEmpty) return 0;
    return werte.reduce((a, b) => a + b) / werte.length;
  }

  String wasserBewertung(double durchschnittWasser) {
    if (durchschnittWasser >= wasserZiel) {
      return 'Wasserziel gut erreicht 💧';
    }

    return 'Wasserziel noch nicht erreicht';
  }

  String schritteBewertung(double durchschnittSchritte) {
    if (durchschnittSchritte >= schritteZiel) {
      return 'Schritteziel gut erreicht 🚶';
    }

    return 'Mehr Bewegung wäre hilfreich';
  }

  String gewichtsTrendBewertung(List<TagesEintrag> letzteTage) {
    if (letzteTage.length < 2) {
      return 'Noch zu wenig Daten für Gewichtstrend';
    }

    final neuestesGewicht = letzteTage.first.gewicht;
    final aeltestesGewicht = letzteTage.last.gewicht;
    final differenz = neuestesGewicht - aeltestesGewicht;

    if (differenz < -0.2) {
      return 'Gewicht ist diese Woche gesunken';
    }

    if (differenz > 0.2) {
      return 'Gewicht ist diese Woche gestiegen';
    }

    return 'Gewicht ist diese Woche stabil';
  }
  /// Zählt Mahlzeiten nach Kategorie.
Map<String, int> mahlzeitenNachKategorieZaehlen(List<TagesEintrag> letzteTage) {
  final Map<String, int> zaehler = {};

  for (final tag in letzteTage) {
    for (final mahlzeit in tag.mahlzeiten) {
      zaehler[mahlzeit.kategorie] = (zaehler[mahlzeit.kategorie] ?? 0) + 1;
    }
  }

  return zaehler;
}
  @override
  Widget build(BuildContext context) {
    final letzteTage = letzteSiebenTage();

    final durchschnittGewicht = durchschnittDouble(
      letzteTage.map((tag) => tag.gewicht).toList(),
    );

    final durchschnittWasser = durchschnittInt(
      letzteTage.map((tag) => tag.wasser).toList(),
    );

    final durchschnittSchritte = durchschnittInt(
      letzteTage.map((tag) => tag.schritte).toList(),
    );

    final mahlzeitenGesamt = letzteTage.fold<int>(
      0,
      (summe, tag) => summe + tag.mahlzeiten.length,
    );
    final mahlzeitenNachKategorie = mahlzeitenNachKategorieZaehlen(letzteTage);

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wochenanalyse', style: AppStyle.titelMittel),

            AppStyle.abstandKlein,

            Text('Tage ausgewertet: ${letzteTage.length}'),
            Text('Ø Gewicht: ${durchschnittGewicht.toStringAsFixed(1)} kg'),
            Text('Ø Wasser: ${durchschnittWasser.toStringAsFixed(1)} Gläser'),
            Text('Ø Schritte: ${durchschnittSchritte.toStringAsFixed(0)}'),
            Text('Mahlzeiten gesamt: $mahlzeitenGesamt'),
            AppStyle.abstandKlein,

            const Text(
              'Mahlzeiten nach Kategorie:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            for (final eintrag in mahlzeitenNachKategorie.entries)
              Text('${eintrag.key}: ${eintrag.value}'),

            AppStyle.abstandKlein,

            Text(wasserBewertung(durchschnittWasser)),
            Text(schritteBewertung(durchschnittSchritte)),
            Text(gewichtsTrendBewertung(letzteTage)),
          ],
        ),
      ),
    );
  }
}