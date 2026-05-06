import 'dart:io';

import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(titel),
      ),
      body: Center(
        child: Hero(
          tag: bildPfad,
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Image.file(
              File(bildPfad),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}