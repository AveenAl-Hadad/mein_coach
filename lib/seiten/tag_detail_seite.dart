import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Detailseite für einen gespeicherten Tag.
/// Diese Seite zeigt alle Daten eines Tages.
class TagDetailSeite extends StatelessWidget {
  final TagesEintrag tag;

  const TagDetailSeite({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tag.datum),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'Tagesdetails',
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

          Card(
            child: ListTile(
              title: const Text('Gewicht'),
              subtitle: Text('${tag.gewicht.toStringAsFixed(1)} kg'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Wasser'),
              subtitle: Text('${tag.wasser} Gläser'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Schritte'),
              subtitle: Text('${tag.schritte} Schritte'),
            ),
          ),

          AppStyle.abstandGross,

          const Text(
            'Mahlzeiten',
            style: AppStyle.titelMittel,
          ),

          AppStyle.abstandKlein,

          if (tag.mahlzeiten.isEmpty)
            const Text('Keine Mahlzeiten gespeichert.'),

          for (final mahlzeit in tag.mahlzeiten)
            Card(
              child: ListTile(
                leading: AppStyle.mahlzeitIcon,
                title: Text(mahlzeit),
              ),
            ),
        ],
      ),
    );
  }
}