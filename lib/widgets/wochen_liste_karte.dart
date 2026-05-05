import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import '../seiten/tag_detail_seite.dart';

/// Zeigt die letzten 7 Tage als Liste.
/// Jeder Tag ist klickbar und öffnet die Detailseite.
class WochenListeKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const WochenListeKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  List<TagesEintrag> letzteSiebenTage() {
    final sortiert = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    return sortiert.take(7).toList();
  }

  @override
  Widget build(BuildContext context) {
    final letzteTage = letzteSiebenTage();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Letzte 7 Tage',
              style: AppStyle.titelMittel,
            ),

            AppStyle.abstandKlein,

            if (letzteTage.isEmpty)
              const Text('Keine Daten vorhanden'),

            for (final tag in letzteTage)
              ListTile(
                title: Text(tag.datum),
                subtitle: Text(tag.zusammenfassung()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TagDetailSeite(
                        tag: tag,
                        wasserZiel: wasserZiel,
                        schritteZiel: schritteZiel,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}