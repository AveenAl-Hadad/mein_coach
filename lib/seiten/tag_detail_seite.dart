import 'package:flutter/material.dart';
import 'package:mein_coach/style/app_texte.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import '../widgets/mahlzeit_karte.dart';
import '../widgets/detail_karte.dart';

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

         DetailKarte(
          titel: AppTexte.gewicht,
          wert: '${tag.gewicht.toStringAsFixed(1)} kg',
        ),

        DetailKarte(
          titel: AppTexte.wasser,
          wert: '${tag.wasser} Gläser',
        ),

        DetailKarte(
          titel: AppTexte.schritte,
          wert: '${tag.schritte} Schritte',
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
            MahlzeitKarte(mahlzeit: mahlzeit),
        ],
      ),
    );
  }
}