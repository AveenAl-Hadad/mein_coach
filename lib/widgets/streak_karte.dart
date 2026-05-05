import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Karte für Streaks.
/// Zeigt, wie viele Tage hintereinander Ziele erreicht wurden.
class StreakKarte extends StatelessWidget {
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const StreakKarte({
    super.key,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  /// Berechnet eine Serie anhand einer Bedingung.
  int streakBerechnen(bool Function(TagesEintrag tag) bedingung) {
    final sortierteTage = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    int streak = 0;

    for (final tag in sortierteTage) {
      if (bedingung(tag)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final wasserStreak = streakBerechnen(
      (tag) => tag.wasser >= wasserZiel,
    );

    final schritteStreak = streakBerechnen(
      (tag) => tag.schritte >= schritteZiel,
    );

    final notizStreak = streakBerechnen(
      (tag) => tag.notiz.isNotEmpty,
    );

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Serien', style: AppStyle.titelMittel),

            AppStyle.abstandKlein,

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.water_drop, size: 18),
                  label: Text('$wasserStreak Tage Wasser'),
                ),
                Chip(
                  avatar: const Icon(Icons.directions_walk, size: 18),
                  label: Text('$schritteStreak Tage Schritte'),
                ),
                Chip(
                  avatar: const Icon(Icons.edit_note, size: 18),
                  label: Text('$notizStreak Tage Notiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}