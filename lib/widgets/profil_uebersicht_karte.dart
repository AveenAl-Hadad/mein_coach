import 'package:flutter/material.dart';

import '../style/app_style.dart';
import '../style/app_texte.dart';

/// Karte für persönliche Gesundheitswerte.
/// Zeigt BMI und Fortschritt zwischen Startgewicht und Zielgewicht.
class ProfilUebersichtKarte extends StatelessWidget {
  final int groesse;
  final double aktuellesGewicht;
  final double startGewicht;
  final double zielGewicht;

  const ProfilUebersichtKarte({
    super.key,
    required this.groesse,
    required this.aktuellesGewicht,
    required this.startGewicht,
    required this.zielGewicht,
  });

  /// Berechnet den BMI.
  double bmiBerechnen() {
    final groesseInMeter = groesse / 100;
    return aktuellesGewicht / (groesseInMeter * groesseInMeter);
  }

  /// Berechnet den Fortschritt zum Zielgewicht.
  double fortschrittBerechnen() {
    final gesamterWeg = (startGewicht - zielGewicht).abs();
    final geschaffterWeg = (startGewicht - aktuellesGewicht).abs();

    if (gesamterWeg == 0) return 0;

    final fortschritt = geschaffterWeg / gesamterWeg;

    return fortschritt.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final bmi = bmiBerechnen();
    final fortschritt = fortschrittBerechnen();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppTexte.profilUebersicht, style: AppStyle.titelMittel),

            AppStyle.abstandKlein,

            Text('BMI: ${bmi.toStringAsFixed(1)}'),

            AppStyle.abstandKlein,

            Text('Fortschritt: ${(fortschritt * 100).toStringAsFixed(0)} %'),

            AppStyle.abstandKlein,

            LinearProgressIndicator(value: fortschritt),
          ],
        ),
      ),
    );
  }
}