import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class WochenUebersichtKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const WochenUebersichtKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  @override
  Widget build(BuildContext context) {
    final sortiert = [...tage]..sort((a, b) => b.datum.compareTo(a.datum));
    final letzte7 = sortiert.take(7).toList();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wochenübersicht', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,

            if (letzte7.isEmpty)
              const Text('Noch keine Daten vorhanden.'),

            for (final tag in letzte7)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(tag.datum),
                subtitle: Text(
                  '${tag.wasser}/$wasserZiel Gläser • ${tag.schritte}/$schritteZiel Schritte',
                ),
                trailing: Icon(
                  tag.wasser >= wasserZiel && tag.schritte >= schritteZiel
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
          ],
        ),
      ),
    );
  }
}