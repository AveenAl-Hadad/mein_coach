import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelle/mahlzeit.dart';
import '../provider/historie_provider.dart';
import '../seiten/foto_detail_seite.dart';
import '../style/app_style.dart';

class MahlzeitenGalerieSeite extends StatelessWidget {
  const MahlzeitenGalerieSeite({super.key});

  List<_GalerieEintrag> _eintraegeAusHistorie(HistorieProvider provider) {
    final eintraege = <_GalerieEintrag>[];

    for (final tag in provider.tage) {
      for (final mahlzeit in tag.mahlzeiten) {
        final pfad = mahlzeit.bildPfad;

        if (pfad == null || pfad.isEmpty) continue;

        eintraege.add(
          _GalerieEintrag(
            datum: tag.datum,
            mahlzeit: mahlzeit,
          ),
        );
      }
    }

    return eintraege;
  }

  @override
  Widget build(BuildContext context) {
    final historie = context.watch<HistorieProvider>();
    final eintraege = _eintraegeAusHistorie(historie);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahlzeiten-Galerie'),
        centerTitle: true,
      ),
      body: eintraege.isEmpty
          ? const Center(
              child: Text('Noch keine Mahlzeitenfotos gespeichert.'),
            )
          : GridView.builder(
              padding: AppStyle.standardPadding,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: eintraege.length,
              itemBuilder: (context, index) {
                final eintrag = eintraege[index];
                final mahlzeit = eintrag.mahlzeit;

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FotoDetailSeite(
                            bildPfad: mahlzeit.bildPfad!,
                            titel: mahlzeit.text,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: kIsWeb
                                ? const Icon(Icons.image_not_supported, size: 48)
                                : Image.file(
                                    File(mahlzeit.bildPfad!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mahlzeit.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${mahlzeit.kategorie} • ${eintrag.datum}',
                                style: AppStyle.kleinText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _GalerieEintrag {
  final String datum;
  final Mahlzeit mahlzeit;

  _GalerieEintrag({
    required this.datum,
    required this.mahlzeit,
  });
}