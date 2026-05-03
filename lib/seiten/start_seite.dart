import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/tages_service.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';
import '../widgets/mahlzeit_eingabe.dart';
import '../widgets/mahlzeit_karte.dart';
import '../widgets/tracking_karte.dart';

/// Startseite der App.
/// Zeigt die Tagesdaten und erlaubt Bearbeitung.
class StartSeite extends StatefulWidget {
  const StartSeite({super.key});

  @override
  State<StartSeite> createState() => _StartSeiteStatus();
}

class _StartSeiteStatus extends State<StartSeite> {
  final TextEditingController eingabeController = TextEditingController();
  final TagesService service = TagesService();

  TagesEintrag eintrag = TagesEintrag.heute();
  bool wirdGeladen = true;

  @override
  void initState() {
    super.initState();
    datenLaden();
  }

  /// Lädt den gespeicherten Eintrag für heute.
  Future<void> datenLaden() async {
    final geladenerEintrag = await service.laden();

    setState(() {
      eintrag = geladenerEintrag;
      wirdGeladen = false;
    });
  }

  /// Fügt eine neue Mahlzeit hinzu.
  Future<void> mahlzeitHinzufuegen() async {
    await service.mahlzeitHinzufuegen(
      eintrag,
      eingabeController.text,
    );

    eingabeController.clear();
    setState(() {});
  }

  /// Löscht eine Mahlzeit.
  Future<void> mahlzeitLoeschen(int index) async {
    await service.mahlzeitLoeschen(eintrag, index);
    setState(() {});
  }

  /// Setzt den heutigen Tag zurück.
  Future<void> tagZuruecksetzen() async {
    await service.zuruecksetzen();

    setState(() {
      eintrag = TagesEintrag.heute();
    });
  }

  /// Erhöht das Gewicht.
  Future<void> gewichtErhoehen() async {
    await service.gewichtErhoehen(eintrag);
    setState(() {});
  }

  /// Verringert das Gewicht.
  Future<void> gewichtVerringern() async {
    await service.gewichtVerringern(eintrag);
    setState(() {});
  }

  /// Erhöht Wasser um ein Glas.
  Future<void> wasserErhoehen() async {
    await service.wasserErhoehen(eintrag);
    setState(() {});
  }

  /// Erhöht Schritte um 500.
  Future<void> schritteErhoehen() async {
    await service.schritteErhoehen(eintrag);
    setState(() {});
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
            tooltip: AppTexte.tagZuruecksetzen,
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
            titel: AppTexte.gewicht,
            untertitel: '${eintrag.gewicht.toStringAsFixed(1)} kg',
            aktionMinus: gewichtVerringern,
            aktionPlus: gewichtErhoehen,
          ),

          TrackingKarte(
            titel: AppTexte.wasser,
            untertitel: '${eintrag.wasser} Gläser',
            aktionPlus: wasserErhoehen,
          ),

          TrackingKarte(
            titel: AppTexte.schritte,
            untertitel: '${eintrag.schritte} Schritte',
            aktionPlus: schritteErhoehen,
          ),

          AppStyle.abstandGross,

          const Text(
            AppTexte.mahlzeiten,
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