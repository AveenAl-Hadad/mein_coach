import 'package:flutter/material.dart';

/// Einfache Karte für Detailinformationen.
/// Beispiel: Gewicht, Wasser, Schritte.
class DetailKarte extends StatelessWidget {
  final String titel;
  final String wert;

  const DetailKarte({
    super.key,
    required this.titel,
    required this.wert,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titel),
        subtitle: Text(wert),
      ),
    );
  }
}