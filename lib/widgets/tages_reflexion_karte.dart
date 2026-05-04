import 'package:flutter/material.dart';

import '../style/app_style.dart';

/// Karte für Stimmung und Tagesnotiz.
/// Diese Karte hilft dem Nutzer, den Tag kurz zu reflektieren.
class TagesReflexionKarte extends StatelessWidget {
  final String stimmung;
  final String notiz;
  final void Function(String stimmung) beimStimmungAendern;
  final void Function(String notiz) beimNotizAendern;

  const TagesReflexionKarte({
    super.key,
    required this.stimmung,
    required this.notiz,
    required this.beimStimmungAendern,
    required this.beimNotizAendern,
  });

  @override
  Widget build(BuildContext context) {
    final notizController = TextEditingController(text: notiz);

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tagesreflexion', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,

            Wrap(
              spacing: 8,
              children: ['😃', '🙂', '😐', '😟', '😴'].map((emoji) {
                return ChoiceChip(
                  label: Text(emoji),
                  selected: stimmung == emoji,
                  onSelected: (_) => beimStimmungAendern(emoji),
                );
              }).toList(),
            ),

            AppStyle.abstandKlein,

            TextField(
              controller: notizController,
              decoration: const InputDecoration(
                labelText: 'Notiz',
                hintText: 'Wie lief dein Tag?',
              ),
              maxLines: 3,
              onChanged: beimNotizAendern,
            ),
          ],
        ),
      ),
    );
  }
}