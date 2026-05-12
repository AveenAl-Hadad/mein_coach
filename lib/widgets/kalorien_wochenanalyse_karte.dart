import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';

/// Karte für die Kalorien-Wochenanalyse.
/// Zeigt Durchschnitt, höchsten Tag und niedrigsten Tag.
class KalorienWochenanalyseKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const KalorienWochenanalyseKarte({
    super.key,
    required this.tage,
  });

  List<TagesEintrag> letzteSiebenTage() {
    final sortiert = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    return sortiert.take(7).toList();
  }

  @override
  Widget build(BuildContext context) {
    final letzteTage = letzteSiebenTage();

    if (letzteTage.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Noch keine Kalorien-Daten vorhanden.'),
        ),
      );
    }

    final kalorienListe = letzteTage.map((tag) => tag.gesamtKalorien()).toList();

    final durchschnitt =
        kalorienListe.reduce((a, b) => a + b) / kalorienListe.length;

    final hoechsterWert = kalorienListe.reduce((a, b) => a > b ? a : b);
    final niedrigsterWert = kalorienListe.reduce((a, b) => a < b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalorien-Wochenanalyse',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text('Durchschnitt: ${durchschnitt.round()} kcal'),
            Text('Höchster Tag: $hoechsterWert kcal'),
            Text('Niedrigster Tag: $niedrigsterWert kcal'),
          ],
        ),
      ),
    );
  }
}