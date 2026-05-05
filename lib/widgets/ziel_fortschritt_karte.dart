import 'package:flutter/material.dart';

import '../style/app_style.dart';

/// Karte für Ziel-Fortschritt.
/// Zeigt aktuellen Wert, Zielwert und Prozent-Fortschritt.
class ZielFortschrittKarte extends StatelessWidget {
  final String titel;
  final int aktuell;
  final int ziel;
  final String einheit;
  final IconData icon;

  const ZielFortschrittKarte({
    super.key,
    required this.titel,
    required this.aktuell,
    required this.ziel,
    required this.einheit,
    required this.icon,
  });

  /// Berechnet Fortschritt zwischen 0 und 1.
  double fortschrittBerechnen() {
    if (ziel <= 0) return 0;
    return (aktuell / ziel).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final fortschritt = fortschrittBerechnen();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(titel, style: AppStyle.titelMittel),
              ],
            ),

            AppStyle.abstandKlein,

            Text('$aktuell / $ziel $einheit'),

            AppStyle.abstandKlein,

            LinearProgressIndicator(value: fortschritt),

            AppStyle.abstandKlein,

            Text('${(fortschritt * 100).toStringAsFixed(0)} % erreicht'),
          ],
        ),
      ),
    );
  }
}