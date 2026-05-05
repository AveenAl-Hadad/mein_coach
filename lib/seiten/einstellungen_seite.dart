import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/einstellungen_provider.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';
import '../services/erinnerung_service.dart';

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
          decoration: const InputDecoration(
            labelText: AppTexte.name,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppTexte.abbrechen),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
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
          decoration: const InputDecoration(
            labelText: 'Größe in cm',
          ),
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
          decoration: const InputDecoration(
            labelText: 'Startgewicht in kg',
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
          const Text(
          AppTexte.profil,
          style: AppStyle.titelMittel,
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

        Card(
          child: ListTile(
            title: const Text(AppTexte.groesse),
            subtitle: Text('${provider.groesse} cm'),
            trailing: AppStyle.weiterIcon,
            onTap: groesseAendern,
          ),
        ),

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
          Card(
            child: ListTile(
              title: const Text(AppTexte.wasserZiel),
              subtitle: Text('${provider.wasserZiel} Gläser'),
              trailing: AppStyle.weiterIcon,
              onTap: wasserZielAendern,
            ),
          ),

          Card(
            child: ListTile(
              title: const Text(AppTexte.schritteZiel),
              subtitle: Text('${provider.schritteZiel} Schritte'),
              trailing: AppStyle.weiterIcon,
              onTap: schritteZielAendern,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Test-Erinnerung'),
              subtitle: const Text('Benachrichtigung sofort anzeigen'),
              trailing: AppStyle.weiterIcon,
              onTap: erinnerungService.testErinnerungAnzeigen,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text('Wasser-Erinnerung starten'),
              subtitle: const Text('Alle 2 Stunden (Test: jede Minute)'),
              onTap: erinnerungService.wasserErinnerungStarten,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('Erinnerung stoppen'),
              onTap: () async {
                await erinnerungService.stopAlleErinnerungen();
              },
            ),
          ),
        ],
      ),
    );
  }
}