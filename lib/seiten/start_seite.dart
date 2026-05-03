import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';


/// Startseite der App.
/// Zeigt die Tagesdaten und erlaubt Bearbeitung.
class StartSeite extends StatefulWidget {
  const StartSeite({super.key});

  @override
  State<StartSeite> createState() => _StartSeiteStatus();
}

class _StartSeiteStatus extends State<StartSeite> {
  final LokalerSpeicher lokalerSpeicher = LokalerSpeicher();
  final TextEditingController eingabeController = TextEditingController();

  TagesEintrag eintrag = TagesEintrag.heute();
  bool wirdGeladen = true;

  @override
  void initState() {
    super.initState();
    datenLaden();
  }

  /// Lädt den gespeicherten Eintrag für heute.
  Future<void> datenLaden() async {
    final geladenerEintrag = await lokalerSpeicher.heutigenEintragLaden();

    setState(() {
      eintrag = geladenerEintrag;
      wirdGeladen = false;
    });
  }

  /// Speichert den aktuellen TagesEintrag.
  Future<void> datenSpeichern() async {
    await lokalerSpeicher.heutigenEintragSpeichern(eintrag);
  }

  /// Fügt eine neue Mahlzeit hinzu.
  Future<void> mahlzeitHinzufuegen() async {
    if (eingabeController.text.trim().isEmpty) return;

    setState(() {
      eintrag.mahlzeiten.add(eingabeController.text.trim());
      eingabeController.clear();
    });

    await datenSpeichern();
  }

  /// Löscht eine Mahlzeit.
  Future<void> mahlzeitLoeschen(int index) async {
    setState(() {
      eintrag.mahlzeiten.removeAt(index);
    });

    await datenSpeichern();
  }

  /// Setzt den heutigen Tag zurück.
  Future<void> tagZuruecksetzen() async {
    setState(() {
      eintrag = TagesEintrag.heute();
    });

    await datenSpeichern();
  }

  /// Erhöht das Gewicht.
  Future<void> gewichtErhoehen() async {
    setState(() {
      eintrag.gewicht += 0.1;
    });

    await datenSpeichern();
  }

  /// Verringert das Gewicht.
  Future<void> gewichtVerringern() async {
    setState(() {
      eintrag.gewicht -= 0.1;
    });

    await datenSpeichern();
  }

  /// Erhöht Wasser um ein Glas.
  Future<void> wasserErhoehen() async {
    setState(() {
      eintrag.wasser++;
    });

    await datenSpeichern();
  }

  /// Erhöht Schritte um 500.
  Future<void> schritteErhoehen() async {
    setState(() {
      eintrag.schritte += 500;
    });

    await datenSpeichern();
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
        title: Column(
          children: [
            const Text('Mein Coach'),
            Text(
              eintrag.datum,
              style: AppStyle.kleinText,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Tag zurücksetzen',
            icon: AppStyle.resetIcon,
            onPressed: tagZuruecksetzen,
          ),
        ],
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'Heute',
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

          Card(
            child: ListTile(
              title: const Text('Gewicht'),
              subtitle: Text('${eintrag.gewicht.toStringAsFixed(1)} kg'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: gewichtVerringern,
                    icon: AppStyle.gewichtMinus,
                  ),
                  IconButton(
                    onPressed: gewichtErhoehen,
                    icon: AppStyle.gewichtPlus,
                  ),
                ],
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Wasser'),
              subtitle: Text('${eintrag.wasser} Gläser'),
              trailing: IconButton(
                onPressed: wasserErhoehen,
                icon: AppStyle.gewichtPlus,
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Schritte'),
              subtitle: Text('${eintrag.schritte} Schritte'),
              trailing: IconButton(
                onPressed: schritteErhoehen,
                icon: AppStyle.schritteIcon,
              ),
            ),
          ),

        AppStyle.abstandGross,

          const Text(
            'Mahlzeiten',
            style: AppStyle.titelMittel,
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: eingabeController,
                  decoration: const InputDecoration(
                    hintText: 'z.B. Haferflocken mit Banane',
                  ),
                ),
              ),
              IconButton(
                onPressed: mahlzeitHinzufuegen,
                icon: AppStyle.addIcon,
              ),
            ],
          ),

         AppStyle.abstandMittel,

          for (int i = 0; i < eintrag.mahlzeiten.length; i++)
            Card(
              child: ListTile(
                leading: AppStyle.mahlzeitIcon,
                title: Text(eintrag.mahlzeiten[i]),
                trailing: IconButton(
                  icon: AppStyle.loeschenIcon,
                  onPressed: () => mahlzeitLoeschen(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}