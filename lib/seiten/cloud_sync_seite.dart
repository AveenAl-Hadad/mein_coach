import 'package:flutter/material.dart';

import '../services/firebase_sync_service.dart';
import '../style/app_style.dart';

class CloudSyncSeite extends StatefulWidget {
  const CloudSyncSeite({super.key});

  @override
  State<CloudSyncSeite> createState() => _CloudSyncSeiteState();
}

class _CloudSyncSeiteState extends State<CloudSyncSeite> {
  final FirebaseSyncService syncService = FirebaseSyncService();

  final TextEditingController apiKeyController = TextEditingController();
  final TextEditingController databaseUrlController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwortController = TextEditingController();

  bool wirdGeladen = false;
  String status = '';

  @override
  void dispose() {
    apiKeyController.dispose();
    databaseUrlController.dispose();
    emailController.dispose();
    passwortController.dispose();
    super.dispose();
  }

  Future<void> ausfuehren(Future<void> Function() aktion) async {
    setState(() {
      wirdGeladen = true;
      status = '';
    });

    try {
      await aktion();

      setState(() {
        status = 'Erfolgreich ausgeführt.';
      });
    } catch (fehler) {
      setState(() {
        status = 'Fehler: $fehler';
      });
    } finally {
      setState(() {
        wirdGeladen = false;
      });
    }
  }

  Future<void> firebaseSpeichern() async {
    await ausfuehren(() {
      return syncService.einrichten(
        apiKey: apiKeyController.text,
        databaseUrl: databaseUrlController.text,
      );
    });
  }

  Future<void> registrieren() async {
    await ausfuehren(() {
      return syncService.registrieren(
        emailController.text,
        passwortController.text,
      );
    });
  }

  Future<void> anmelden() async {
    await ausfuehren(() {
      return syncService.anmelden(
        emailController.text,
        passwortController.text,
      );
    });
  }

  Future<void> upload() async {
    await ausfuehren(syncService.cloudUpload);
  }

  Future<void> download() async {
    await ausfuehren(syncService.cloudDownload);
  }

  Future<void> abmelden() async {
    await ausfuehren(syncService.abmelden);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Sync'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'Firebase Login + Cloud Sync',
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

          TextField(
            controller: apiKeyController,
            decoration: const InputDecoration(
              labelText: 'Firebase API-Key',
              border: OutlineInputBorder(),
            ),
          ),

          AppStyle.abstandKlein,

          TextField(
            controller: databaseUrlController,
            decoration: const InputDecoration(
              labelText: 'Firebase Realtime Database URL',
              hintText: 'https://dein-projekt.firebaseio.com',
              border: OutlineInputBorder(),
            ),
          ),

          AppStyle.abstandKlein,

          ElevatedButton.icon(
            onPressed: wirdGeladen ? null : firebaseSpeichern,
            icon: const Icon(Icons.save),
            label: const Text('Firebase Daten speichern'),
          ),

          AppStyle.abstandGross,

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-Mail',
              border: OutlineInputBorder(),
            ),
          ),

          AppStyle.abstandKlein,

          TextField(
            controller: passwortController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Passwort',
              border: OutlineInputBorder(),
            ),
          ),

          AppStyle.abstandKlein,

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: wirdGeladen ? null : registrieren,
                  child: const Text('Registrieren'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: wirdGeladen ? null : anmelden,
                  child: const Text('Anmelden'),
                ),
              ),
            ],
          ),

          AppStyle.abstandGross,

          ElevatedButton.icon(
            onPressed: wirdGeladen ? null : upload,
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Daten hochladen'),
          ),

          AppStyle.abstandKlein,

          ElevatedButton.icon(
            onPressed: wirdGeladen ? null : download,
            icon: const Icon(Icons.cloud_download),
            label: const Text('Daten herunterladen'),
          ),

          AppStyle.abstandKlein,

          OutlinedButton.icon(
            onPressed: wirdGeladen ? null : abmelden,
            icon: const Icon(Icons.logout),
            label: const Text('Abmelden'),
          ),

          AppStyle.abstandGross,

          if (wirdGeladen)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (status.isNotEmpty)
            Card(
              child: Padding(
                padding: AppStyle.standardPadding,
                child: Text(status),
              ),
            ),
        ],
      ),
    );
  }
}