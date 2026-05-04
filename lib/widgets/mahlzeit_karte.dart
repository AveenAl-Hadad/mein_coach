import 'dart:io';
import 'package:flutter/material.dart';
import '../modelle/mahlzeit.dart';
import 'package:flutter/foundation.dart';
import '../seiten/foto_detail_seite.dart';

/// Karte für eine gespeicherte Mahlzeit.
/// Zeigt Text, Kategorie, Uhrzeit und optional ein Foto.
class MahlzeitKarte extends StatelessWidget {
  final Mahlzeit mahlzeit;
  final VoidCallback? beimLoeschen;

  const MahlzeitKarte({
    super.key,
    required this.mahlzeit,
    this.beimLoeschen,
  });

  /// Prüft, ob ein Foto vorhanden ist.
  bool get hatFoto {
    return mahlzeit.bildPfad != null && mahlzeit.bildPfad!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
         onTap: hatFoto
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FotoDetailSeite(
                      bildPfad: mahlzeit.bildPfad!,
                      titel: mahlzeit.text,
                    ),
                  ),
                );
              }
            : null,
       leading: hatFoto
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: kIsWeb
                  ? const Icon(Icons.image_not_supported)
                  : Image.file(
                      File(mahlzeit.bildPfad!),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            )
          : const Icon(Icons.restaurant),
       
        title: Text(mahlzeit.text),
        subtitle: Text('${mahlzeit.kategorie} • ${mahlzeit.uhrzeit}'),
        trailing: beimLoeschen == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: beimLoeschen,
              ),
      ),
    );
  }
}