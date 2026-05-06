import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class BesteLeistungKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const BesteLeistungKarte({
    super.key,
    required this.tage,
  });

  @override
  Widget build(BuildContext context) {
    if (tage.isEmpty) {
      return const SizedBox.shrink();
    }

    final besterWasserTag = [...tage]
      ..sort((a, b) => b.wasser.compareTo(a.wasser));

    final besterSchritteTag = [...tage]
      ..sort((a, b) => b.schritte.compareTo(a.schritte));

    final besterMahlzeitenTag = [...tage]
      ..sort((a, b) => b.mahlzeiten.length.compareTo(a.mahlzeiten.length));

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Beste Leistungen', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,

            _Zeile(
              icon: Icons.water_drop,
              titel: 'Meiste Gläser',
              wert:
                  '${besterWasserTag.first.wasser} Gläser am ${besterWasserTag.first.datum}',
            ),

            _Zeile(
              icon: Icons.directions_walk,
              titel: 'Meiste Schritte',
              wert:
                  '${besterSchritteTag.first.schritte} Schritte am ${besterSchritteTag.first.datum}',
            ),

            _Zeile(
              icon: Icons.restaurant,
              titel: 'Meiste Mahlzeiten',
              wert:
                  '${besterMahlzeitenTag.first.mahlzeiten.length} Einträge am ${besterMahlzeitenTag.first.datum}',
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
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(titel),
      subtitle: Text(wert),
    );
  }
}