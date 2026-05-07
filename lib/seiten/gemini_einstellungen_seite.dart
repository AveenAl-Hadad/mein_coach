import 'package:flutter/material.dart';

import '../services/gemini_service.dart';
import '../style/app_style.dart';

class GeminiEinstellungenSeite extends StatefulWidget {
  const GeminiEinstellungenSeite({super.key});

  @override
  State<GeminiEinstellungenSeite> createState() =>
      _GeminiEinstellungenSeiteState();
}

class _GeminiEinstellungenSeiteState extends State<GeminiEinstellungenSeite> {
  final TextEditingController apiKeyController = TextEditingController();
  final GeminiService geminiService = GeminiService();

  Future<void> speichern() async {
    await geminiService.apiKeySpeichern(apiKeyController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gemini API-Key gespeichert.'),
      ),
    );

    apiKeyController.clear();
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Einstellungen'),
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            'Gemini API-Key',
            style: AppStyle.titelMittel,
          ),
          AppStyle.abstandKlein,
          const Text(
            'AIzaSyCJ2SlSi9YJOWfA3m932ASPKRtrlOyy4oU',
          ),
          AppStyle.abstandMittel,
          TextField(
            controller: apiKeyController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'API-Key',
              border: OutlineInputBorder(),
            ),
          ),
          AppStyle.abstandKlein,
          ElevatedButton.icon(
            onPressed: speichern,
            icon: const Icon(Icons.save),
            label: const Text('Speichern'),
          ),
        ],
      ),
    );
  }
}