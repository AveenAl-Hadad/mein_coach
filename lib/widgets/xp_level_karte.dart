import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class XpLevelKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const XpLevelKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  int get xp {
    int punkte = 0;

    if (eintrag.wasser >= wasserZiel) punkte += 40;
    if (eintrag.schritte >= schritteZiel) punkte += 40;
    if (eintrag.notiz.trim().isNotEmpty) punkte += 20;
    if (eintrag.mahlzeiten.isNotEmpty) punkte += 20;

    return punkte;
  }

  int get level {
    return (xp / 100).floor() + 1;
  }

  double get fortschritt {
    return (xp % 100) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Level Fortschritt', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            Text('Level $level'),
            AppStyle.abstandKlein,
            LinearProgressIndicator(value: fortschritt),
            AppStyle.abstandKlein,
            Text('$xp XP heute gesammelt'),
          ],
        ),
      ),
    );
  }
}