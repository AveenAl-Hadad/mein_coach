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
import 'dart:html' as html; // für Web
import '../services/backup_service.dart';

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

  Future<void> datenExportieren(TagesProvider provider) async {
  final json = await provider.exportieren();

  final blob = html.Blob([json]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "mein_coach_backup.json")
    ..click();

  html.Url.revokeObjectUrl(url);
}
Future<void> backupExportieren() async {
  await backupService.backupExportieren();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(AppTexte.backupExportiert)),
  );
}

Future<void> backupImportieren() async {
  await backupService.backupImportieren();

  if (!mounted) return;

  await context.read<TagesProvider>().datenLaden();

  ScaffoldMessenger.of(context).showSnackBar(
   const SnackBar(content: Text(AppTexte.backupImportiert)),
  );
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TagesProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final eintrag = provider.eintrag;

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

          AppStyle.abstandMittel,

          TrackingKarte(
            titel: AppTexte.gewicht,
            untertitel: '${eintrag.gewicht.toStringAsFixed(1)} kg',
            aktionMinus: provider.gewichtVerringern,
            aktionPlus: provider.gewichtErhoehen,
            beimTippen: () => gewichtEingeben(provider),
          ),

          TrackingKarte(
            titel: AppTexte.wasser,
            untertitel: '${eintrag.wasser} Gläser',
            aktionPlus: provider.wasserErhoehen,
          ),

          TrackingKarte(
            titel: AppTexte.schritte,
            untertitel: '${eintrag.schritte} Schritte',
            aktionPlus: provider.schritteErhoehen,
          ),

          AppStyle.abstandGross,

          const Text(
            AppTexte.mahlzeiten,
            style: AppStyle.titelMittel,
          ),

          MahlzeitEingabe(
            controller: eingabeController,
            beimHinzufuegen: () {
              provider.mahlzeitHinzufuegen(eingabeController.text);
              eingabeController.clear();
            },
          ),

          AppStyle.abstandMittel,

          for (int i = 0; i < eintrag.mahlzeiten.length; i++)
            MahlzeitKarte(
              mahlzeit: eintrag.mahlzeiten[i],
              beimLoeschen: () => provider.mahlzeitLoeschen(i),
            ),
        ],
      ),
    );
  }
}