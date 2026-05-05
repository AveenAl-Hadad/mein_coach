import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Karte für Erfolge.
/// Zeigt einfache Badges basierend auf Tagesdaten.
class ErfolgeKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const ErfolgeKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  List<String> erfolgeBerechnen() {
    final erfolge = <String>[];

    if (eintrag.wasser >= wasserZiel) {
      erfolge.add('💧 Wasserziel erreicht');
    }

    if (eintrag.schritte >= schritteZiel) {
      erfolge.add('🚶 Schritteziel erreicht');
    }

    if (eintrag.mahlzeiten.length >= 3) {
      erfolge.add('🍽️ 3 Mahlzeiten eingetragen');
    }

    if (eintrag.notiz.isNotEmpty) {
      erfolge.add('📝 Tagesnotiz geschrieben');
    }

    if (erfolge.isEmpty) {
      erfolge.add('Noch keine Erfolge heute');
    }

    return erfolge;
  }

  @override
  Widget build(BuildContext context) {
    final erfolge = erfolgeBerechnen();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Erfolge heute', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,

            for (final erfolg in erfolge)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(erfolg),
              ),
          ],
        ),
      ),
    );
  }
}