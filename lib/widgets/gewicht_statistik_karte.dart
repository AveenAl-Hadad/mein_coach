import 'package:flutter/material.dart';

import '../style/app_style.dart';

/// Statistik-Karte für Gewicht.
/// Zeigt Startgewicht, aktuelles Gewicht, Zielgewicht und Fortschritt.
class GewichtStatistikKarte extends StatelessWidget {
  final double aktuellesGewicht;
  final double startGewicht;
  final double zielGewicht;

  const GewichtStatistikKarte({
    super.key,
    required this.aktuellesGewicht,
    required this.startGewicht,
    required this.zielGewicht,
  });

  /// Berechnet den Unterschied vom aktuellen Gewicht zum Zielgewicht.
  double differenzZumZielBerechnen() {
    return aktuellesGewicht - zielGewicht;
  }

  /// Berechnet den Unterschied zwischen aktuellem Gewicht und Startgewicht.
  double veraenderungSeitStartBerechnen() {
    return aktuellesGewicht - startGewicht;
  }

  /// Erstellt einen verständlichen Status-Text.
  String statusTextErstellen() {
    final differenzZumZiel = differenzZumZielBerechnen();

    if (differenzZumZiel <= 0) {
      return 'Ziel erreicht 🎉';
    }

    return 'Noch ${differenzZumZiel.toStringAsFixed(1)} kg bis zum Ziel';
  }

  @override
  Widget build(BuildContext context) {
    final veraenderungSeitStart = veraenderungSeitStartBerechnen();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gewicht Statistik', style: AppStyle.titelMittel),

            AppStyle.abstandKlein,

            Text(statusTextErstellen()),

            AppStyle.abstandKlein,

            Text('Aktuell: ${aktuellesGewicht.toStringAsFixed(1)} kg'),
            Text('Start: ${startGewicht.toStringAsFixed(1)} kg'),
            Text('Ziel: ${zielGewicht.toStringAsFixed(1)} kg'),

            AppStyle.abstandKlein,

            Text(
              'Veränderung seit Start: '
              '${veraenderungSeitStart.toStringAsFixed(1)} kg',
            ),
          ],
        ),
      ),
    );
  }
}