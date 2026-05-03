import 'package:flutter/material.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';

/// Eingabefeld zum Hinzufügen einer neuen Mahlzeit.
class MahlzeitEingabe extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback beimHinzufuegen;

  const MahlzeitEingabe({
    super.key,
    required this.controller,
    required this.beimHinzufuegen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: AppTexte.mahlzeitHinweis,
            ),
          ),
        ),
        IconButton(
          onPressed: beimHinzufuegen,
          icon: AppStyle.addIcon,
        ),
      ],
    );
  }
}