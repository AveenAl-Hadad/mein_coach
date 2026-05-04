import 'package:flutter/material.dart';

/// Eingabefeld für neue Mahlzeiten.
/// Der Nutzer kann Text und Kategorie auswählen.
class MahlzeitEingabe extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text, String kategorie) beimHinzufuegen;

  const MahlzeitEingabe({
    super.key,
    required this.controller,
    required this.beimHinzufuegen,
  });

  @override
  State<MahlzeitEingabe> createState() => _MahlzeitEingabeStatus();
}

class _MahlzeitEingabeStatus extends State<MahlzeitEingabe> {
  String ausgewaehlteKategorie = 'Sonstiges';

  final List<String> kategorien = const [
    'Frühstück',
    'Mittagessen',
    'Abendessen',
    'Snack',
    'Getränk',
    'Sonstiges',
  ];

  /// Gibt Text und Kategorie an die Startseite weiter.
  void mahlzeitHinzufuegen() {
    widget.beimHinzufuegen(
      widget.controller.text,
      ausgewaehlteKategorie,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
         initialValue: ausgewaehlteKategorie,
          decoration: const InputDecoration(
            labelText: 'Kategorie',
          ),
          items: kategorien.map((kategorie) {
            return DropdownMenuItem(
              value: kategorie,
              child: Text(kategorie),
            );
          }).toList(),
          onChanged: (wert) {
            if (wert == null) return;

            setState(() {
              ausgewaehlteKategorie = wert;
            });
          },
        ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: 'z.B. Haferflocken mit Banane',
                ),
              ),
            ),
            IconButton(
              onPressed: mahlzeitHinzufuegen,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),
      ],
    );
  }
}