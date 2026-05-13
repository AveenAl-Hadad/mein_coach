import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Eingabefeld für neue Mahlzeiten.
/// Der Nutzer kann Text, Kategorie und optional ein Foto auswählen.
class MahlzeitEingabe extends StatefulWidget {
  final TextEditingController controller;
  final void Function(
  String text,
  String kategorie,
  String? bildPfad,
  double menge,
  String einheit,
  String groesse,
  int kalorienProEinheit,
) beimHinzufuegen;

  const MahlzeitEingabe({
    super.key,
    required this.controller,
    required this.beimHinzufuegen,
  });

  @override
  State<MahlzeitEingabe> createState() => _MahlzeitEingabeStatus();
}

class _MahlzeitEingabeStatus extends State<MahlzeitEingabe> {
  final ImagePicker bildAuswahl = ImagePicker();
  final TextEditingController mengeController = TextEditingController();
  final TextEditingController kalorienProEinheitController =
      TextEditingController();

  String ausgewaehlteEinheit = 'gramm';
  String ausgewaehlteGroesse = 'normal';
  String ausgewaehlteKategorie = 'Sonstiges';
  String? bildPfad;

  final List<String> kategorien = const [
    'Frühstück',
    'Mittagessen',
    'Abendessen',
    'Snack',
    'Getränk',
    'Sonstiges',
  ];

  @override
  void dispose() {
    mengeController.dispose();
    kalorienProEinheitController.dispose();
    super.dispose();
  }

  /// Öffnet die Galerie und speichert den Bildpfad.
  Future<void> fotoAuswaehlen() async {
    final bild = await bildAuswahl.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (bild == null) return;

    setState(() {
      bildPfad = bild.path;
    });
  }

  /// Entfernt das ausgewählte Foto wieder.
  void fotoEntfernen() {
    setState(() {
      bildPfad = null;
    });
  }

  /// Gibt Text, Kategorie und Bildpfad an die Startseite weiter.  
  void mahlzeitHinzufuegen() {
    final text = widget.controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib zuerst eine Mahlzeit ein.'),
        ),
      );
      return;
    } // ende if

    final menge = double.tryParse(
      mengeController.text.replaceAll(',', '.'),
    ) ?? 0;

    final kalorienProEinheit =
        int.tryParse(kalorienProEinheitController.text) ?? 0;

    if (menge <= 0 || kalorienProEinheit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte Menge und Kalorien richtig eingeben.'),
        ),
      );
      return;
    }

    widget.beimHinzufuegen(
      text,
      ausgewaehlteKategorie,
      bildPfad,
      menge,
      ausgewaehlteEinheit,
      ausgewaehlteGroesse,
      kalorienProEinheit,
    );

    if (kalorien < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kalorien dürfen nicht negativ sein.'),
        ),
      );
      return;
    }
    if (kalorien == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hinweis: Du hast 0 Kalorien eingetragen.'),
        ),
      );
    }

    widget.beimHinzufuegen(text, ausgewaehlteKategorie, bildPfad, menge, ausgewaehlteEinheit, ausgewaehlteGroesse, kalorienProEinheit);

    widget.controller.clear();
    mengeController.clear();
    kalorienProEinheitController.clear();

    setState(() {
      bildPfad = null;
    });
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
            Expanded(
              child: TextField(
                controller: mengeController,
                decoration: const InputDecoration(
                  labelText: 'Menge',
                  hintText: 'z.B. 150',
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: ausgewaehlteEinheit,
                decoration: const InputDecoration(
                  labelText: 'Einheit',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'gramm',
                    child: Text('Gramm'),
                  ),
                  DropdownMenuItem(
                    value: 'stueck',
                    child: Text('Stück'),
                  ),
                ],
                onChanged: (wert) {
                  if (wert == null) return;
                  setState(() {
                    ausgewaehlteEinheit = wert;
                  });
                },
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: ausgewaehlteGroesse,
                decoration: const InputDecoration(
                  labelText: 'Größe',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'klein',
                    child: Text('Klein'),
                  ),
                  DropdownMenuItem(
                    value: 'normal',
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: 'gross',
                    child: Text('Groß'),
                  ),
                ],
                onChanged: (wert) {
                  if (wert == null) return;
                  setState(() {
                    ausgewaehlteGroesse = wert;
                  });
                },
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: TextField(
                controller: kalorienProEinheitController,
                decoration: InputDecoration(
                  labelText: ausgewaehlteEinheit == 'gramm'
                      ? 'kcal pro 100g'
                      : 'kcal pro Stück',
                  hintText: 'z.B. 250',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(
              onPressed: fotoAuswaehlen,
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: mahlzeitHinzufuegen,
              icon: const Icon(Icons.add_circle),
            ),
          ],
        ),

        if (bildPfad != null)
          Card(
            child: ListTile(
              leading: Image.file(
                File(bildPfad!),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: const Text('Foto ausgewählt'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: fotoEntfernen,
              ),
            ),
          ),
      ],
    );
  }
}