import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Karte für einen gespeicherten TagesEintrag.
/// Wird in der Historie-Liste angezeigt.
class HistorieKarte extends StatelessWidget {
  final TagesEintrag tag;
  final VoidCallback beimTippen;

  const HistorieKarte({
    super.key,
    required this.tag,
    required this.beimTippen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tag.datum),
        subtitle: Text(
          '${tag.gewicht.toStringAsFixed(1)} kg • '
          '${tag.wasser} Gläser • '
          '${tag.schritte} Schritte • '
          '${tag.mahlzeiten.length} Mahlzeiten',
        ),
        trailing: AppStyle.weiterIcon,
        onTap: beimTippen,
      ),
    );
  }
}