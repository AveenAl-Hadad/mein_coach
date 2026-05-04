import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/einstellungen_provider.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';

/// Einstellungsseite der App.
/// Hier kann der Nutzer persönliche Werte ändern.
class EinstellungenSeite extends StatefulWidget {
  const EinstellungenSeite({super.key});

  @override
  State<EinstellungenSeite> createState() => _EinstellungenSeiteStatus();
}

class _EinstellungenSeiteStatus extends State<EinstellungenSeite> {
  final TextEditingController zielGewichtController = TextEditingController();

  @override
  void dispose() {
    zielGewichtController.dispose();
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
          Card(
            child: ListTile(
              leading: AppStyle.zielIcon,
              title: const Text(AppTexte.zielGewicht),
              subtitle: Text('${provider.zielGewicht.toStringAsFixed(1)} kg'),
              trailing: AppStyle.weiterIcon,
              onTap: zielGewichtAendern,
            ),
          ),
        ],
      ),
    );
  }
}