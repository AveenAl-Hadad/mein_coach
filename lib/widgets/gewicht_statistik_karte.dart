import 'package:flutter/material.dart';

import '../style/app_style.dart';

/// Statistik-Karte für Gewicht.
/// Zeigt wichtige Werte unter dem Diagramm.
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

  @override
  Widget build(BuildContext context) {
    final differenzZumZiel = aktuellesGewicht - zielGewicht;
    final differenzSeitStart = aktuellesGewicht - startGewicht;

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gewicht Statistik', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            Text('Aktuell: ${aktuellesGewicht.toStringAsFixed(1)} kg'),
            Text('Start: ${startGewicht.toStringAsFixed(1)} kg'),
            Text('Ziel: ${zielGewicht.toStringAsFixed(1)} kg'),
            Text('Seit Start: ${differenzSeitStart.toStringAsFixed(1)} kg'),
            Text('Bis Ziel: ${differenzZumZiel.toStringAsFixed(1)} kg'),
          ],
        ),
      ),
    );
  }
}