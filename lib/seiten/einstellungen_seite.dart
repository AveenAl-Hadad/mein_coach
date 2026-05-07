import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/einstellungen_provider.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';
import '../services/erinnerung_service.dart';
import 'cloud_sync_seite.dart';
import 'dart:io';
import '../services/profilbild_service.dart';
import '../services/ki_erinnerung_service.dart';
import '../provider/tages_provider.dart';
import '../services/firebase_sync_service.dart';

/// Einstellungsseite der App.
/// Hier kann der Nutzer persönliche Werte ändern.
class EinstellungenSeite extends StatefulWidget {
  const EinstellungenSeite({super.key});

  @override
  State<EinstellungenSeite> createState() => _EinstellungenSeiteStatus();
}

class _EinstellungenSeiteStatus extends State<EinstellungenSeite> {
  final TextEditingController zielGewichtController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController groesseController = TextEditingController();
  final TextEditingController startGewichtController = TextEditingController();
  final TextEditingController wasserZielController = TextEditingController();
  final TextEditingController schritteZielController = TextEditingController();
  final ErinnerungService erinnerungService = ErinnerungService();
  final ProfilbildService profilbildService = ProfilbildService();
  final KiErinnerungService kiErinnerungService = KiErinnerungService();
  final FirebaseSyncService firebaseSyncService = FirebaseSyncService();
  String? profilbildPfad;

@override
void initState() {
  super.initState();
  profilbildLaden();
  kiErinnerungService.initialisieren();
}
  @override
  void dispose() {
    zielGewichtController.dispose();
    nameController.dispose();
    groesseController.dispose();
    startGewichtController.dispose();
    wasserZielController.dispose();
    schritteZielController.dispose();
    super.dispose();
  }

  Future<void> profilbildLaden() async {
    final pfad = await profilbildService.profilbildLaden();

    if (!mounted) return;

    setState(() {
      profilbildPfad = pfad;
    });
  }

  Future<void> profilbildAuswaehlen() async {
    final pfad = await profilbildService.profilbildAuswaehlen();

    if (!mounted) return;

    setState(() {
      profilbildPfad = pfad;
    });
  }

  Future<void> profilbildLoeschen() async {
    await profilbildService.profilbildLoeschen();

    if (!mounted) return;

    setState(() {
      profilbildPfad = null;
    });
  }
  /// Öffnet einen Dialog zum Ändern des Zielgewichts.
  Future<void> zielGewichtAendern() async {
    final provider = context.read<EinstellungenProvider>();

    zielGewichtController.text = provider.zielGewicht.toStringAsFixed(1);

    final neuesZielGewicht = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.zielGewichtAendern),
          content: TextField(
            controller: zielGewichtController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: AppTexte.zielGewicht,
              hintText: 'z.B. 75.0',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () {
                final wert = double.tryParse(
                  zielGewichtController.text.replaceAll(',', '.'),
                );

                if (wert == null || wert <= 0) {
                  return;
                }

                Navigator.pop(context, wert);
              },
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neuesZielGewicht == null) return;

    await provider.zielGewichtSpeichern(neuesZielGewicht);
  }

  /// Ändert den Namen.
  Future<void> nameAendern() async {
    final provider = context.read<EinstellungenProvider>();
    nameController.text = provider.name;

    final neuerName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.name),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: AppTexte.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, nameController.text.trim()),
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neuerName == null) return;
    await provider.nameSpeichern(neuerName);
  }

  /// Ändert die Körpergröße.
  Future<void> groesseAendern() async {
    final provider = context.read<EinstellungenProvider>();
    groesseController.text = provider.groesse.toString();

    final neueGroesse = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.groesse),
          content: TextField(
            controller: groesseController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Größe in cm'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () {
                final wert = int.tryParse(groesseController.text);
                if (wert == null || wert <= 0) return;
                Navigator.pop(context, wert);
              },
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neueGroesse == null) return;
    await provider.groesseSpeichern(neueGroesse);
  }

  /// Ändert das Startgewicht.
  Future<void> startGewichtAendern() async {
    final provider = context.read<EinstellungenProvider>();
    startGewichtController.text = provider.startGewicht.toStringAsFixed(1);

    final neuesStartGewicht = await showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.startGewicht),
          content: TextField(
            controller: startGewichtController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Startgewicht in kg'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () {
                final wert = double.tryParse(
                  startGewichtController.text.replaceAll(',', '.'),
                );

                if (wert == null || wert <= 0) return;
                Navigator.pop(context, wert);
              },
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neuesStartGewicht == null) return;
    await provider.startGewichtSpeichern(neuesStartGewicht);
  }

  /// Ändert das tägliche Wasserziel.
  Future<void> wasserZielAendern() async {
    final provider = context.read<EinstellungenProvider>();
    wasserZielController.text = provider.wasserZiel.toString();

    final neuesZiel = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.wasserZielAendern),
          content: TextField(
            controller: wasserZielController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: AppTexte.wasserZiel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () {
                final wert = int.tryParse(wasserZielController.text);
                if (wert == null || wert <= 0) return;
                Navigator.pop(context, wert);
              },
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neuesZiel == null) return;
    await provider.wasserZielSpeichern(neuesZiel);
  }

  /// Ändert das tägliche Schritteziel.
  Future<void> schritteZielAendern() async {
    final provider = context.read<EinstellungenProvider>();
    schritteZielController.text = provider.schritteZiel.toString();

    final neuesZiel = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppTexte.schritteZielAendern),
          content: TextField(
            controller: schritteZielController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: AppTexte.schritteZiel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppTexte.abbrechen),
            ),
            ElevatedButton(
              onPressed: () {
                final wert = int.tryParse(schritteZielController.text);
                if (wert == null || wert <= 0) return;
                Navigator.pop(context, wert);
              },
              child: const Text(AppTexte.speichern),
            ),
          ],
        );
      },
    );

    if (neuesZiel == null) return;
    await provider.schritteZielSpeichern(neuesZiel);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EinstellungenProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexte.einstellungen),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(AppTexte.profil, style: AppStyle.titelMittel),

          AppStyle.abstandKlein,

          Card(
            child: Padding(
              padding: AppStyle.standardPadding,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: profilbildPfad == null
                        ? null
                        : FileImage(File(profilbildPfad!)),
                    child: profilbildPfad == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                  AppStyle.abstandKlein,
                  Text(
                    provider.name.isEmpty ? 'Dein Profil' : provider.name,
                    style: AppStyle.titelMittel,
                  ),
                  AppStyle.abstandKlein,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: profilbildAuswaehlen,
                          icon: const Icon(Icons.photo),
                          label: const Text('Bild wählen'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: profilbildLoeschen,
                          icon: const Icon(Icons.delete),
                          label: const Text('Löschen'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          AppStyle.abstandKlein,

          Card(
            child: ListTile(
              title: const Text(AppTexte.name),
              subtitle: Text(
                provider.name.isEmpty ? 'Nicht gesetzt' : provider.name,
              ),
              trailing: AppStyle.weiterIcon,
              onTap: nameAendern,
            ),
          ),
          AppStyle.abstandKlein,

          Card(
            child: ListTile(
              title: const Text(AppTexte.groesse),
              subtitle: Text('${provider.groesse} cm'),
              trailing: AppStyle.weiterIcon,
              onTap: groesseAendern,
            ),
          ),
          AppStyle.abstandKlein,

          Card(
            child: ListTile(
              title: const Text(AppTexte.startGewicht),
              subtitle: Text('${provider.startGewicht.toStringAsFixed(1)} kg'),
              trailing: AppStyle.weiterIcon,
              onTap: startGewichtAendern,
            ),
          ),

          AppStyle.abstandMittel,
          Card(
            child: ListTile(
              leading: AppStyle.zielIcon,
              title: const Text(AppTexte.zielGewicht),
              subtitle: Text('${provider.zielGewicht.toStringAsFixed(1)} kg'),
              trailing: AppStyle.weiterIcon,
              onTap: zielGewichtAendern,
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              title: const Text(AppTexte.wasserZiel),
              subtitle: Text('${provider.wasserZiel} Gläser'),
              trailing: AppStyle.weiterIcon,
              onTap: wasserZielAendern,
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              title: const Text(AppTexte.schritteZiel),
              subtitle: Text('${provider.schritteZiel} Schritte'),
              trailing: AppStyle.weiterIcon,
              onTap: schritteZielAendern,
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Test-Erinnerung'),
              subtitle: const Text('Benachrichtigung sofort anzeigen'),
              trailing: AppStyle.weiterIcon,
              onTap: erinnerungService.testErinnerungAnzeigen,
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text('Wasser-Erinnerung starten'),
              subtitle: const Text('Alle 2 Stunden (Test: jede Minute)'),
              onTap: erinnerungService.wasserErinnerungStarten,
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('Erinnerung stoppen'),
              onTap: () async {
                await erinnerungService.stopAlleErinnerungen();
              },
            ),
          ),
          AppStyle.abstandKlein,

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active),
              title: const Text('Wasser-Erinnerungen'),
              subtitle: const Text('08:00 bis 20:00 alle 2 Stunden'),
              value: provider.wasserErinnerungAktiv,
              onChanged: (aktiv) async {
                if (aktiv) {
                  await erinnerungService
                      .wasserErinnerungenZuEchtenZeitenStarten();
                } else {
                  await erinnerungService.stopAlleErinnerungen();
                }

                await provider.wasserErinnerungAktivSpeichern(aktiv);
              },
            ),
          ),

          AppStyle.abstandMittel,

          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_sync),
              title: const Text('Cloud Sync'),
              subtitle: const Text('Firebase Login und Daten synchronisieren'),
              trailing: AppStyle.weiterIcon,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CloudSyncSeite(),
                  ),
                );
              },
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('KI Erinnerung testen'),
              subtitle: const Text(
                'Motivations Nachricht anzeigen',
              ),
              trailing: AppStyle.weiterIcon,
              onTap: () async {
                final tagesProvider = context.read<TagesProvider>();
                final einstellungenProvider =
                    context.read<EinstellungenProvider>();

                await kiErinnerungService.motivationSenden(
                  eintrag: tagesProvider.eintrag,
                  wasserZiel: einstellungenProvider.wasserZiel,
                  schritteZiel:
                      einstellungenProvider.schritteZiel,
                );
              },
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Profil in Cloud speichern'),
              subtitle: const Text('Name, Ziele und Körperdaten sichern'),
              trailing: AppStyle.weiterIcon,
              onTap: () async {
                final provider = context.read<EinstellungenProvider>();
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await firebaseSyncService.profilUpload(
                    name: provider.name,
                    groesse: provider.groesse,
                    startGewicht: provider.startGewicht,
                    zielGewicht: provider.zielGewicht,
                    wasserZiel: provider.wasserZiel,
                    schritteZiel: provider.schritteZiel,
                  );

                  if (!mounted) return;

                     messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Profil wurde in der Cloud gespeichert.'),
                    ),
                  );
                } catch (fehler) {
                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Fehler: $fehler'),
                    ),
                  );
                }
              },
            ),
          ),
          AppStyle.abstandKlein,
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_download),
              title: const Text('Profil aus Cloud laden'),
              subtitle: const Text('Name, Ziele und Körperdaten wiederherstellen'),
              trailing: AppStyle.weiterIcon,
              onTap: () async {
                final provider = context.read<EinstellungenProvider>();
                final messenger = ScaffoldMessenger.of(context);

                try {
                  final profil = await firebaseSyncService.profilDownload();

                  if (profil == null) {
                    if (!mounted) return;

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Kein Cloud Profil gefunden.'),
                      ),
                    );

                    return;
                  }

                  await provider.nameSpeichern(profil['name'] ?? '');
                  await provider.groesseSpeichern(profil['groesse'] ?? 170);
                  await provider.startGewichtSpeichern(
                    (profil['startGewicht'] as num).toDouble(),
                  );
                  await provider.zielGewichtSpeichern(
                    (profil['zielGewicht'] as num).toDouble(),
                  );
                  await provider.wasserZielSpeichern(profil['wasserZiel'] ?? 8);
                  await provider.schritteZielSpeichern(profil['schritteZiel'] ?? 8000);

                  if (!mounted) return;

                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Profil wurde aus der Cloud geladen.'),
                    ),
                  );
                } catch (fehler) {
                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Fehler: $fehler'),
                    ),
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}
