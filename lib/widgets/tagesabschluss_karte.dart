import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class TagesabschlussKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const TagesabschlussKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  int get score {
    int punkte = 0;

    if (eintrag.wasser >= wasserZiel) {
      punkte += 35;
    }

    if (eintrag.schritte >= schritteZiel) {
      punkte += 35;
    }

    if (eintrag.notiz.trim().isNotEmpty) {
      punkte += 15;
    }

    if (eintrag.mahlzeiten.isNotEmpty) {
      punkte += 15;
    }

    return punkte.clamp(0, 100);
  }

  String bewertung() {
    if (score >= 90) {
      return 'Starker Tag 🔥';
    }

    if (score >= 70) {
      return 'Sehr guter Fortschritt 💪';
    }

    if (score >= 50) {
      return 'Guter Anfang 🚀';
    }

    return 'Morgen wird besser 🌱';
  }

  Color farbe() {
    if (score >= 90) {
      return Colors.green;
    }

    if (score >= 70) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.nightlight_round, color: farbe()),
                const SizedBox(width: 8),
                const Text(
                  'Tagesabschluss',
                  style: AppStyle.titelMittel,
                ),
              ],
            ),

            AppStyle.abstandMittel,

            LinearProgressIndicator(
              value: score / 100,
              color: farbe(),
              minHeight: 12,
              borderRadius: BorderRadius.circular(12),
            ),

            AppStyle.abstandMittel,

            Text(
              '$score / 100 Punkte',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            AppStyle.abstandKlein,

            Text(
              bewertung(),
              style: TextStyle(
                color: farbe(),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}