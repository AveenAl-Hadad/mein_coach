import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class KiTagesanalyseKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const KiTagesanalyseKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  String analyseText() {
    final texte = <String>[];

    if (eintrag.wasser >= wasserZiel) {
      texte.add('💧 Super! Dein Wasserziel wurde erreicht.');
    } else if (eintrag.wasser >= wasserZiel * 0.7) {
      texte.add('💧 Fast geschafft beim Wasserziel.');
    } else {
      texte.add('💧 Du solltest heute mehr trinken.');
    }

    if (eintrag.schritte >= schritteZiel) {
      texte.add('🚶 Stark! Dein Schrittziel wurde erreicht.');
    } else if (eintrag.schritte >= schritteZiel * 0.7) {
      texte.add('🚶 Du bist nah an deinem Schrittziel.');
    } else {
      texte.add('🚶 Ein kleiner Spaziergang würde helfen.');
    }

    if (eintrag.stimmung.contains('😊')) {
      texte.add('😄 Deine Stimmung sieht heute positiv aus.');
    }

    if (eintrag.notiz.trim().isNotEmpty) {
      texte.add('📝 Gut gemacht! Du reflektierst deinen Tag.');
    }

    return texte.join('\n\n');
  }

  Color analyseFarbe() {
    final wasserOk = eintrag.wasser >= wasserZiel;
    final schritteOk = eintrag.schritte >= schritteZiel;

    if (wasserOk && schritteOk) {
      return Colors.green;
    }

    if (wasserOk || schritteOk) {
      return Colors.orange;
    }

    return Colors.red;
  }

  IconData analyseIcon() {
    final wasserOk = eintrag.wasser >= wasserZiel;
    final schritteOk = eintrag.schritte >= schritteZiel;

    if (wasserOk && schritteOk) {
      return Icons.auto_awesome;
    }

    if (wasserOk || schritteOk) {
      return Icons.insights;
    }

    return Icons.warning_amber_rounded;
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
                Icon(
                  analyseIcon(),
                  color: analyseFarbe(),
                ),
                const SizedBox(width: 8),
                const Text(
                  'KI Tagesanalyse',
                  style: AppStyle.titelMittel,
                ),
              ],
            ),

            AppStyle.abstandMittel,

            Text(
              analyseText(),
              style: const TextStyle(
                height: 1.5,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}