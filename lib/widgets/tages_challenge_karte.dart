import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class TagesChallengeKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const TagesChallengeKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  String get challenge {
    if (eintrag.wasser < wasserZiel) {
      return 'Trinke heute noch ${wasserZiel - eintrag.wasser} Gläser Wasser.';
    }

    if (eintrag.schritte < schritteZiel) {
      return 'Gehe heute noch ${schritteZiel - eintrag.schritte} Schritte.';
    }

    if (eintrag.mahlzeiten.isEmpty) {
      return 'Speichere heute mindestens eine Mahlzeit.';
    }

    if (eintrag.notiz.trim().isEmpty) {
      return 'Schreibe eine kurze Tagesnotiz.';
    }

    return 'Alle Tages-Challenges geschafft 🔥';
  }

  IconData get icon {
    if (eintrag.wasser < wasserZiel) return Icons.water_drop;
    if (eintrag.schritte < schritteZiel) return Icons.directions_walk;
    if (eintrag.mahlzeiten.isEmpty) return Icons.restaurant;
    if (eintrag.notiz.trim().isEmpty) return Icons.edit_note;
    return Icons.emoji_events;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tages-Challenge', style: AppStyle.titelMittel),
                  AppStyle.abstandKlein,
                  Text(challenge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}