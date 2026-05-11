import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../services/kalorien_service.dart';
import '../seiten/kalorien_einstellungen_seite.dart';

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
    final prozent = kalorienZiel <= 0 ? 0 : ((gegessen / kalorienZiel) * 100).round();

    final wochen = KalorienService.wochenBisZiel(
      aktuellesGewicht: eintrag.gewicht,
      zielGewicht: zielGewicht,
    );
    final gewichtDifferenz = eintrag.gewicht - zielGewicht;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.local_fire_department),
                SizedBox(width: 8),
                Text(
                  'Kalorienziel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text('Tagesziel: ${kalorienZiel.round()} kcal'),
            Text('Grundumsatz: ${grundumsatz.round()} kcal'),
            Text('Tagesbedarf: ${tagesbedarf.round()} kcal'),
            const SizedBox(height: 8),
            const Text(
              'Das Tagesziel ist dein geschätzter Bedarf minus 500 kcal zum Abnehmen.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            if (kalorienZiel < 1200)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Warnung: Das Kalorienziel ist sehr niedrig. Bitte achte auf deine Gesundheit.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
            Text('Gegessen: $gegessen kcal'),
            Text('Fortschritt: $prozent %'),
            Text(uebrig >= 0 ? 'Übrig: ${uebrig.round()} kcal'
             : 'Zu viel gegessen: ${uebrig.abs().round()} kcal',
              style: TextStyle(
                color: uebrig >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: kalorienZiel <= 0
                  ? 0
                  : (gegessen / kalorienZiel).clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 12),

            Text(
              wochen == 0
                  ? 'Zielgewicht erreicht'
                  : 'Geschätzte Abnehmzeit: ca. $wochen Wochen',
            ),

            const SizedBox(height: 12),
            Text(
              gewichtDifferenz <= 0
                  ? 'Du hast dein Zielgewicht erreicht.'
                  : 'Noch ${gewichtDifferenz.toStringAsFixed(1)} kg bis zum Zielgewicht.',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KalorienEinstellungenSeite(),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('Kalorien-Einstellungen bearbeiten'),
            ),
          ],
        ),
      ),
    );
  }
}