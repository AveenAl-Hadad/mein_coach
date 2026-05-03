import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import '../widgets/tracking_karte.dart';
import '../widgets/mahlzeit_karte.dart';
import '../widgets/mahlzeit_eingabe.dart';
import '../style/app_texte.dart';

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
           const Text(AppTexte.appName),
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
            AppTexte.heute,
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

         TrackingKarte(
            titel: 'Gewicht',
            untertitel: '${eintrag.gewicht.toStringAsFixed(1)} kg',
            aktionMinus: gewichtVerringern,
            aktionPlus: gewichtErhoehen,
          ),

          TrackingKarte(
            titel: 'Wasser',
            untertitel: '${eintrag.wasser} Gläser',
            aktionPlus: wasserErhoehen,
          ),

          TrackingKarte(
            titel: 'Schritte',
            untertitel: '${eintrag.schritte} Schritte',
            aktionPlus: schritteErhoehen,
          ),

        AppStyle.abstandGross,

          const Text(
            'Mahlzeiten',
            style: AppStyle.titelMittel,
          ),

          MahlzeitEingabe(
            controller: eingabeController,
            beimHinzufuegen: mahlzeitHinzufuegen,
          ),

         AppStyle.abstandMittel,

          for (int i = 0; i < eintrag.mahlzeiten.length; i++)
            MahlzeitKarte(
              mahlzeit: eintrag.mahlzeiten[i],
              beimLoeschen: () => mahlzeitLoeschen(i),
            ),
        ],
      ),
    );
  }
}