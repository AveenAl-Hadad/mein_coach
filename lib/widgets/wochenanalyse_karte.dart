import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Karte für die Wochenanalyse.
/// Sie berechnet Durchschnittswerte der letzten 7 gespeicherten Tage.
class WochenanalyseKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const WochenanalyseKarte({
    super.key,
    required this.tage,
  });

  /// Gibt maximal die letzten 7 Tage zurück.
  List<TagesEintrag> letzteSiebenTage() {
    final sortierteTage = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    return sortierteTage.take(7).toList();
  }

  /// Berechnet den Durchschnitt eines double-Wertes.
  double durchschnittDouble(List<double> werte) {
    if (werte.isEmpty) return 0;
    return werte.reduce((a, b) => a + b) / werte.length;
  }

  /// Berechnet den Durchschnitt eines int-Wertes.
  double durchschnittInt(List<int> werte) {
    if (werte.isEmpty) return 0;
    return werte.reduce((a, b) => a + b) / werte.length;
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
          ],
        ),
      ),
    );
  }
}