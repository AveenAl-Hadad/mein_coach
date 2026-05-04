import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Eingabefeld für neue Mahlzeiten.
/// Der Nutzer kann Text, Kategorie und optional ein Foto auswählen.
class MahlzeitEingabe extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text, String kategorie, String? bildPfad)
      beimHinzufuegen;

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
    widget.beimHinzufuegen(
      widget.controller.text,
      ausgewaehlteKategorie,
      bildPfad,
    );

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