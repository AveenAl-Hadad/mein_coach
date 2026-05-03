import 'package:flutter/material.dart';
import '../style/app_style.dart';

/// Karte für eine einzelne Mahlzeit.
/// Zeigt den Namen der Mahlzeit und optional einen Lösch-Button.
class MahlzeitKarte extends StatelessWidget {
  final String mahlzeit;
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
        leading: AppStyle.mahlzeitIcon,
        title: Text(mahlzeit),
        trailing: beimLoeschen == null
            ? null
            : IconButton(
                icon: AppStyle.loeschenIcon,
                onPressed: beimLoeschen,
              ),
      ),
    );
  }
}