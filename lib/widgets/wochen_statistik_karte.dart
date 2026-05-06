import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class WochenStatistikKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const WochenStatistikKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  @override
  Widget build(BuildContext context) {
    final letzte7 = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    final daten = letzte7.take(7).toList();

    final wasserSchnitt = daten.isEmpty
        ? 0
        : daten.map((t) => t.wasser).reduce((a, b) => a + b) / daten.length;

    final schritteSchnitt = daten.isEmpty
        ? 0
        : daten.map((t) => t.schritte).reduce((a, b) => a + b) / daten.length;

    final zielTage = daten.where((tag) {
      return tag.wasser >= wasserZiel && tag.schritte >= schritteZiel;
    }).length;

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wochenstatistik', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
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
              wert: '$zielTage / 7 Tage',
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