import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/einstellungen_provider.dart';
import '../provider/historie_provider.dart';
import '../services/ki_coach_service.dart';
import '../style/app_style.dart';

class KiCoachSeite extends StatefulWidget {
  const KiCoachSeite({super.key});

  @override
  State<KiCoachSeite> createState() => _KiCoachSeiteState();
}

class _KiCoachSeiteState extends State<KiCoachSeite> {
  final TextEditingController apiKeyController = TextEditingController();
  final TextEditingController frageController = TextEditingController();

  final KiCoachService kiCoachService = KiCoachService();

  bool wirdGeladen = false;
  String antwort = '';

  @override
  void dispose() {
    apiKeyController.dispose();
    frageController.dispose();
    super.dispose();
  }

  Future<void> apiKeySpeichern() async {
    await kiCoachService.apiKeySpeichern(apiKeyController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OpenAI API-Key gespeichert'),
      ),
    );
  }

  Future<void> coachFragen() async {
    final historieProvider = context.read<HistorieProvider>();
    final einstellungenProvider = context.read<EinstellungenProvider>();

    setState(() {
      wirdGeladen = true;
      antwort = '';
    });

    try {
      final neueAntwort = await kiCoachService.tippErstellen(
        tage: historieProvider.tage,
        wasserZiel: einstellungenProvider.wasserZiel,
        schritteZiel: einstellungenProvider.schritteZiel,
        zielGewicht: einstellungenProvider.zielGewicht,
        frage: frageController.text,
      );

      setState(() {
        antwort = neueAntwort;
      });
    } catch (fehler) {
      setState(() {
        antwort = 'Fehler: $fehler';
      });
    } finally {
      setState(() {
        wirdGeladen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KI Coach'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'ChatGPT Coach',
            style: AppStyle.titelGross,
          ),
          AppStyle.abstandKlein,
          const Text(
            'Speichere deinen OpenAI API-Key und frage deinen Coach nach Tipps.',
          ),
          AppStyle.abstandMittel,

          TextField(
            controller: apiKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'OpenAI API-Key',
              border: OutlineInputBorder(),
            ),
          ),
          AppStyle.abstandKlein,

          ElevatedButton.icon(
            onPressed: apiKeySpeichern,
            icon: const Icon(Icons.save),
            label: const Text('API-Key speichern'),
          ),

          AppStyle.abstandGross,

          TextField(
            controller: frageController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Deine Frage',
              hintText: 'z.B. Was soll ich heute besser machen?',
              border: OutlineInputBorder(),
            ),
          ),

          AppStyle.abstandKlein,

          ElevatedButton.icon(
            onPressed: wirdGeladen ? null : coachFragen,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Coach fragen'),
          ),

          AppStyle.abstandGross,

          if (wirdGeladen)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (antwort.isNotEmpty)
            Card(
              child: Padding(
                padding: AppStyle.standardPadding,
                child: Text(
                  antwort,
                  style: AppStyle.normalText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}