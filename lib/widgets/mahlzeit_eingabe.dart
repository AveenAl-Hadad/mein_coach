import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  String ausgewaehlteKategorie = 'Sonstiges';
  String ausgewaehlteEinheit = 'gramm';
  String ausgewaehlteGroesse = 'normal';
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

  void fotoEntfernen() {
    setState(() {
      bildPfad = null;
    });
  }

  void mahlzeitHinzufuegen() {
    final text = widget.controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib zuerst eine Mahlzeit ein.'),
        ),
      );
      return;
    }

    final menge = double.tryParse(
          mengeController.text.replaceAll(',', '.'),
        ) ??
        0;

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

    widget.controller.clear();
    mengeController.clear();
    kalorienProEinheitController.clear();

    setState(() {
      bildPfad = null;
      ausgewaehlteEinheit = 'gramm';
      ausgewaehlteGroesse = 'normal';
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

        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            labelText: 'Mahlzeit',
            hintText: 'z.B. Haferflocken mit Banane',
          ),
        ),

        Row(
          children: [
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
          ],
        ),

        Row(
          children: [
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
          ],
        ),

        Row(
          children: [
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