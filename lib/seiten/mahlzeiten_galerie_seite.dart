import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelle/mahlzeit.dart';
import '../provider/historie_provider.dart';
import '../style/app_style.dart';
import 'foto_detail_seite.dart';

class MahlzeitenGalerieSeite extends StatelessWidget {
  const MahlzeitenGalerieSeite({super.key});

  List<_GalerieEintrag> _eintraegeAusHistorie(
    HistorieProvider provider,
  ) {
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

    return eintraege.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final historie = context.watch<HistorieProvider>();

    final eintraege = _eintraegeAusHistorie(historie);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahlzeiten Galerie'),
        centerTitle: true,
      ),
      body: eintraege.isEmpty
          ? const Center(
              child: Text(
                'Noch keine Fotos vorhanden 🍽️',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: AppStyle.standardPadding,
              itemCount: eintraege.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final eintrag = eintraege[index];
                final mahlzeit = eintrag.mahlzeit;

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
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
                  child: Card(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: mahlzeit.bildPfad!,
                            child: Image.file(
                              File(mahlzeit.bildPfad!),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                mahlzeit.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                mahlzeit.kategorie,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                eintrag.datum,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
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