import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class BadgeKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const BadgeKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  List<_Badge> get _badges {
    final liste = <_Badge>[];

    if (eintrag.wasser >= wasserZiel) {
      liste.add(_Badge(Icons.water_drop, 'Hydro Held'));
    }

    if (eintrag.schritte >= schritteZiel) {
      liste.add(_Badge(Icons.directions_walk, 'Schritte Star'));
    }

    if (eintrag.mahlzeiten.length >= 3) {
      liste.add(_Badge(Icons.restaurant, 'Meal Master'));
    }

    if (eintrag.notiz.trim().isNotEmpty) {
      liste.add(_Badge(Icons.edit_note, 'Reflexion'));
    }

    if (liste.isEmpty) {
      liste.add(_Badge(Icons.lock, 'Noch kein Badge'));
    }

    return liste;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Badges heute', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _badges.map((badge) {
                return Chip(
                  avatar: Icon(badge.icon, size: 18),
                  label: Text(badge.name),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge {
  final IconData icon;
  final String name;

  _Badge(this.icon, this.name);
}