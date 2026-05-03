import 'package:flutter/material.dart';
import '../style/app_texte.dart';

/// Dialog zum Eingeben des Gewichts.
/// Gibt den eingegebenen Wert als String zurück.
class GewichtDialog extends StatelessWidget {
  final TextEditingController controller;

  const GewichtDialog({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppTexte.gewichtEingebenTitel),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: AppTexte.gewichtEingebenHinweis,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppTexte.abbrechen),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text(AppTexte.speichern),
        ),
      ],
    );
  }
}