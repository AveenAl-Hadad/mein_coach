import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/tages_provider.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';
import '../widgets/mahlzeit_eingabe.dart';
import '../widgets/mahlzeit_karte.dart';
import '../widgets/tracking_karte.dart';
import '../widgets/gewicht_dialog.dart';
import '../provider/theme_provider.dart';
import '../services/backup_service.dart';
import '../provider/einstellungen_provider.dart';
import '../widgets/profil_uebersicht_karte.dart';
import '../widgets/coach_hinweis_karte.dart';
import '../widgets/tages_reflexion_karte.dart';
import '../provider/historie_provider.dart';

/// Startseite der App.
/// Zeigt die heutigen Daten und nutzt den TagesProvider
/// für Laden, Speichern und Änderungen.
class StartSeite extends StatefulWidget {
  const StartSeite({super.key});

  @override
  State<StartSeite> createState() => _StartSeiteStatus();
}

class _StartSeiteStatus extends State<StartSeite> {
  final TextEditingController eingabeController = TextEditingController();
  final BackupService backupService = BackupService();

  /// Öffnet einen Dialog, damit der Nutzer das Gewicht manuell eingeben kann.
  Future<void> gewichtEingeben(TagesProvider provider) async {
    final controller = TextEditingController(
      text: provider.eintrag.gewicht.toStringAsFixed(1),
    );
    final eingabe = await showDialog<String>(
      context: context,
      builder: (context) => GewichtDialog(controller: controller),
    );
    if (eingabe == null) return;
    final wert = double.tryParse(eingabe.replaceAll(',', '.'));
    if (wert == null) return;
    await provider.gewichtSetzen(wert);
  }

  /// Öffnet den Kalender und wechselt zum ausgewählten Datum.
  Future<void> datumAuswaehlen(TagesProvider provider) async {
    final ausgewaehltesDatum = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(provider.eintrag.datum),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (ausgewaehltesDatum == null) return;

    final monat = ausgewaehltesDatum.month.toString().padLeft(2, '0');
    final tag = ausgewaehltesDatum.day.toString().padLeft(2, '0');
    final datumText = '${ausgewaehltesDatum.year}-$monat-$tag';

    await provider.datumWechseln(datumText);
  }

  
Future<void> backupExportieren() async {
  await backupService.backupExportieren();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(AppTexte.backupExportiert)),
  );
}

/// Importiert ein Backup und lädt danach die aktuellen Tagesdaten neu.
Future<void> backupImportieren() async {
  final tagesProvider = context.read<TagesProvider>();

  await backupService.backupImportieren();

  if (!mounted) return;

  await tagesProvider.datenLaden();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(AppTexte.backupImportiert)),
  );
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TagesProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final eintrag = provider.eintrag;
    final einstellungenProvider = context.watch<EinstellungenProvider>();
    final historieProvider = context.watch<HistorieProvider>();

    if (provider.wirdGeladen) {
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
            tooltip: AppTexte.backupExportieren,
            icon: AppStyle.backupExportIcon,
            onPressed: backupExportieren,
          ),
          IconButton(
            tooltip: AppTexte.backupImportieren,
            icon: AppStyle.backupImportIcon,
            onPressed: backupImportieren,
          ),
          IconButton(
            icon: themeProvider.istDunkel
                ? AppStyle.hellIcon
                : AppStyle.dunkelIcon,
            onPressed: themeProvider.themeWechseln,
          ),
          IconButton(
            tooltip: AppTexte.datumAuswaehlen,
            icon: AppStyle.kalenderIcon,
            onPressed: () => datumAuswaehlen(provider),
          ),
          IconButton(
            tooltip: AppTexte.tagZuruecksetzen,
            icon: AppStyle.resetIcon,
            onPressed: provider.tagZuruecksetzen,
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
          AppStyle.abstandKlein,

          ProfilUebersichtKarte(
            groesse: einstellungenProvider.groesse,
            aktuellesGewicht: provider.eintrag.gewicht,
            startGewicht: einstellungenProvider.startGewicht,
            zielGewicht: einstellungenProvider.zielGewicht,
          ),
          AppStyle.abstandKlein,

          CoachHinweisKarte(
            groesse: einstellungenProvider.groesse,
            aktuellesGewicht: eintrag.gewicht,
            zielGewicht: einstellungenProvider.zielGewicht,
            tage: historieProvider.tage,
            wasserZiel: einstellungenProvider.wasserZiel,
            schritteZiel: einstellungenProvider.schritteZiel,
          ),
          AppStyle.abstandKlein,

          TagesReflexionKarte(
            stimmung: eintrag.stimmung,
            notiz: eintrag.notiz,
            beimStimmungAendern: provider.stimmungSpeichern,
            beimNotizAendern: provider.notizSpeichern,
          ),
          AppStyle.abstandKlein,
          TrackingKarte(
            titel: AppTexte.gewicht,
            untertitel: '${eintrag.gewicht.toStringAsFixed(1)} kg',
            aktionMinus: provider.gewichtVerringern,
            aktionPlus: provider.gewichtErhoehen,
            beimTippen: () => gewichtEingeben(provider),
          ),

          TrackingKarte(
            titel: AppTexte.wasser,
            untertitel:'${eintrag.wasser} / ${einstellungenProvider.wasserZiel} Gläser',
            aktionPlus: provider.wasserErhoehen,
          ),
            LinearProgressIndicator(
              value: (eintrag.wasser / einstellungenProvider.wasserZiel).clamp(0, 1),
            ),
          TrackingKarte(
            titel: AppTexte.schritte,
            untertitel: '${eintrag.schritte} / ${einstellungenProvider.schritteZiel} Schritte',
            aktionPlus: provider.schritteErhoehen,
          ),
          LinearProgressIndicator(
            value: (eintrag.schritte / einstellungenProvider.schritteZiel).clamp(0, 1),
          ),

          AppStyle.abstandGross,

          const Text(
            AppTexte.mahlzeiten,
            style: AppStyle.titelMittel,
          ),

          MahlzeitEingabe(
            controller: eingabeController,
            beimHinzufuegen: (text, kategorie, bildPfad) {
              provider.mahlzeitHinzufuegen(
                text,
                kategorie: kategorie,
                bildPfad: bildPfad,
              );
              eingabeController.clear();
            },
          ),

          AppStyle.abstandMittel,

          for (final kategorie in [
            'Frühstück',
            'Mittagessen',
            'Abendessen',
            'Snack',
            'Getränk',
            'Sonstiges',
          ])
            ...[
              if (eintrag.mahlzeiten.any((mahlzeit) => mahlzeit.kategorie == kategorie))
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Text(
                    kategorie,
                    style: AppStyle.titelKlein,
                  ),
                ),

              for (int i = 0; i < eintrag.mahlzeiten.length; i++)
                if (eintrag.mahlzeiten[i].kategorie == kategorie)
                  MahlzeitKarte(
                    mahlzeit: eintrag.mahlzeiten[i],
                    beimLoeschen: () => provider.mahlzeitLoeschen(i),
                  ),
            ],
        ],
      ),
    );
  }
}