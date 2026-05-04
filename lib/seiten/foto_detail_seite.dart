import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Detailseite für ein Mahlzeitenfoto.
/// Zeigt das gespeicherte Foto groß an.
class FotoDetailSeite extends StatelessWidget {
  final String bildPfad;
  final String titel;

  const FotoDetailSeite({
    super.key,
    required this.bildPfad,
    required this.titel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titel),
        centerTitle: true,
      ),
      body: Center(
        child: kIsWeb
            ? const Text('Fotoanzeige funktioniert aktuell nur in Android/Windows.')
            : InteractiveViewer(
                child: Image.file(
                  File(bildPfad),
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }
}