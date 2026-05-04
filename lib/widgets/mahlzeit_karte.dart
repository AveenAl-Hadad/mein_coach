import 'package:flutter/material.dart';

import '../modelle/mahlzeit.dart';

/// Karte für eine einzelne Mahlzeit.
/// Zeigt den Namen der Mahlzeit und optional einen Lösch-Button.
class MahlzeitKarte extends StatelessWidget {
  final Mahlzeit mahlzeit;
  final VoidCallback? beimLoeschen;

  const MahlzeitKarte({
    super.key,
    required this.mahlzeit,
    this.beimLoeschen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(mahlzeit.text),
        subtitle: Text('${mahlzeit.kategorie} • ${mahlzeit.uhrzeit}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: beimLoeschen,
        ),
      )
    );
  }
}