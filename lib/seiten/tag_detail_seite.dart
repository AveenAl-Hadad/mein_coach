import 'package:flutter/material.dart';
import 'package:mein_coach/style/app_texte.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import '../widgets/mahlzeit_karte.dart';
import '../widgets/detail_karte.dart';
import '../widgets/erfolge_karte.dart';

/// Detailseite für einen gespeicherten Tag.
/// Diese Seite zeigt alle Daten eines Tages.
class TagDetailSeite extends StatelessWidget {
  final TagesEintrag tag;
  final int wasserZiel;
  final int schritteZiel;

  const TagDetailSeite({
    super.key,
    required this.tag,
    required this.wasserZiel,
    required this.schritteZiel,
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
        AppStyle.abstandMittel,

        ErfolgeKarte(
          eintrag: tag,
          wasserZiel: wasserZiel,
          schritteZiel: schritteZiel,
        ),
        AppStyle.abstandMittel,

        Card(
          child: Padding(
            padding: AppStyle.standardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tagesreflexion',
                  style: AppStyle.titelMittel,
                ),

                AppStyle.abstandKlein,

                Text('Stimmung: ${tag.stimmung}'),

                AppStyle.abstandKlein,

                Text(
                  tag.notiz.isEmpty ? 'Keine Notiz vorhanden' : tag.notiz,
                ),
              ],
            ),
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
            MahlzeitKarte(mahlzeit: mahlzeit),
        ],
      ),
    );
  }
}