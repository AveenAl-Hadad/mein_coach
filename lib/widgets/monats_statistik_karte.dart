import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class MonatsStatistikKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const MonatsStatistikKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  @override
  Widget build(BuildContext context) {
    final jetzt = DateTime.now();

    final monatstage = tage.where((tag) {
      final datum = DateTime.tryParse(tag.datum);
      if (datum == null) return false;

      return datum.year == jetzt.year && datum.month == jetzt.month;
    }).toList();

    final anzahl = monatstage.length;

    final wasserGesamt = monatstage.fold<int>(
      0,
      (summe, tag) => summe + tag.wasser,
    );

    final schritteGesamt = monatstage.fold<int>(
      0,
      (summe, tag) => summe + tag.schritte,
    );

    final zielTage = monatstage.where((tag) {
      return tag.wasser >= wasserZiel && tag.schritte >= schritteZiel;
    }).length;

    final wasserSchnitt = anzahl == 0 ? 0 : wasserGesamt / anzahl;
    final schritteSchnitt = anzahl == 0 ? 0 : schritteGesamt / anzahl;

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monatsstatistik', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            _Zeile(
              icon: Icons.calendar_month,
              titel: 'Tage erfasst',
              wert: '$anzahl',
            ),
            _Zeile(
              icon: Icons.water_drop,
              titel: 'Ø Wasser',
              wert: '${wasserSchnitt.toStringAsFixed(1)} Gläser',
            ),
            _Zeile(
              icon: Icons.directions_walk,
              titel: 'Ø Schritte',
              wert: '${schritteSchnitt.toStringAsFixed(0)} Schritte',
            ),
            _Zeile(
              icon: Icons.emoji_events,
              titel: 'Zieltage',
              wert: '$zielTage Tage',
            ),
          ],
        ),
      ),
    );
  }
}

class _Zeile extends StatelessWidget {
  final IconData icon;
  final String titel;
  final String wert;

  const _Zeile({
    required this.icon,
    required this.titel,
    required this.wert,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(titel),
      trailing: Text(
        wert,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}