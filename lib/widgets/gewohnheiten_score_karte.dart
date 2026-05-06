import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class GewohnheitenScoreKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const GewohnheitenScoreKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  int get score {
    int punkte = 0;

    if (eintrag.wasser >= wasserZiel) punkte += 25;
    if (eintrag.schritte >= schritteZiel) punkte += 25;
    if (eintrag.mahlzeiten.isNotEmpty) punkte += 20;
    if (eintrag.notiz.trim().isNotEmpty) punkte += 15;
    if (eintrag.stimmung.trim().isNotEmpty) punkte += 15;

    return punkte.clamp(0, 100);
  }

  String get bewertung {
    if (score >= 90) return 'Sehr stark 🔥';
    if (score >= 70) return 'Guter Tag 💪';
    if (score >= 50) return 'Solide Basis 👍';
    return 'Heute ist noch Luft nach oben 🚀';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gewohnheiten-Score', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            Text('$score / 100 Punkte'),
            AppStyle.abstandKlein,
            LinearProgressIndicator(value: score / 100),
            AppStyle.abstandKlein,
            Text(bewertung),
          ],
        ),
      ),
    );
  }
}