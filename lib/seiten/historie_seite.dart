import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import 'tag_detail_seite.dart';

/// Zeigt alle gespeicherten TagesEinträge an.
class HistorieSeite extends StatefulWidget {
  const HistorieSeite({super.key});

  @override
  State<HistorieSeite> createState() => _HistorieSeiteStatus();
}

class _HistorieSeiteStatus extends State<HistorieSeite> {
  final LokalerSpeicher lokalerSpeicher = LokalerSpeicher();

  List<TagesEintrag> tage = [];
  bool wirdGeladen = true;

  @override
  void initState() {
    super.initState();
    tageLaden();
  }

  /// Lädt alle gespeicherten Tage aus dem lokalen Speicher.
  Future<void> tageLaden() async {
    final geladeneTage = await lokalerSpeicher.alleTageLaden();

    setState(() {
      tage = geladeneTage.reversed.toList();
      wirdGeladen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (wirdGeladen) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historie'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'Gespeicherte Tage',
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

          if (tage.isEmpty)
            const Text('Noch keine Tage gespeichert.'),

          for (final tag in tage)
            Card(
              child: ListTile(
                title: Text(tag.datum),
                subtitle: Text(
                  '${tag.gewicht.toStringAsFixed(1)} kg • '
                  '${tag.wasser} Gläser • '
                  '${tag.schritte} Schritte • '
                  '${tag.mahlzeiten.length} Mahlzeiten',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagDetailSeite(tag: tag),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}