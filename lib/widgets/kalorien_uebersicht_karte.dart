import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/kalorien_service.dart';

/// Karte für Kalorienübersicht.
/// Zeigt Tagesziel, gegessene Kalorien und geschätzte Abnehmzeit.
class KalorienUebersichtKarte extends StatelessWidget {
  final TagesEintrag eintrag;
  final int alter;
  final int groesse;
  final double zielGewicht;
  final bool istMaennlich;
  final double aktivitaetsFaktor;

  const KalorienUebersichtKarte({
    super.key,
    required this.eintrag,
    required this.alter,
    required this.groesse,
    required this.zielGewicht,
    required this.istMaennlich,
    required this.aktivitaetsFaktor,
  });

  int gegesseneKalorien() {
    return eintrag.mahlzeiten.fold<int>(
      0,
      (summe, mahlzeit) => summe + mahlzeit.kalorien,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grundumsatz = KalorienService.grundumsatz(
      istMaennlich: istMaennlich,
      alter: alter,
      gewicht: eintrag.gewicht,
      groesse: groesse.toDouble(),
    );

    final tagesbedarf = KalorienService.tagesbedarf(
      grundumsatz: grundumsatz,
      aktivitaetsFaktor: aktivitaetsFaktor,
    );

    final kalorienZiel = KalorienService.abnehmKalorien(
      tagesbedarf: tagesbedarf,
    );

    final gegessen = gegesseneKalorien();
    final uebrig = kalorienZiel - gegessen;

    final wochen = KalorienService.wochenBisZiel(
      aktuellesGewicht: eintrag.gewicht,
      zielGewicht: zielGewicht,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalorienziel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text('Tagesziel: ${kalorienZiel.round()} kcal'),
            Text('Gegessen: $gegessen kcal'),
            Text('Übrig: ${uebrig.round()} kcal'),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: kalorienZiel <= 0
                  ? 0
                  : (gegessen / kalorienZiel).clamp(0, 1),
            ),

            const SizedBox(height: 12),

            Text(
              wochen == 0
                  ? 'Zielgewicht erreicht'
                  : 'Geschätzte Abnehmzeit: ca. $wochen Wochen',
            ),
          ],
        ),
      ),
    );
  }
}