import 'package:flutter/material.dart';

import '../style/app_style.dart';

/// Karte mit einfachem Coach-Hinweis.
/// Der Hinweis basiert aktuell auf BMI und Fortschritt.
/// Später kann hier KI oder bessere Logik ergänzt werden.
class CoachHinweisKarte extends StatelessWidget {
  final int groesse;
  final double aktuellesGewicht;
  final double zielGewicht;

  const CoachHinweisKarte({
    super.key,
    required this.groesse,
    required this.aktuellesGewicht,
    required this.zielGewicht,
  });

  /// Berechnet den BMI aus Größe und Gewicht.
  double bmiBerechnen() {
    final groesseInMeter = groesse / 100;
    return aktuellesGewicht / (groesseInMeter * groesseInMeter);
  }

  /// Erstellt einen einfachen Gesundheits-Hinweis.
  String hinweisErstellen() {
    final bmi = bmiBerechnen();

    if (aktuellesGewicht <= zielGewicht) {
      return 'Super! Du hast dein Zielgewicht erreicht oder unterschritten. Achte jetzt auf stabile Gewohnheiten.';
    }

    if (bmi >= 30) {
      return 'Konzentriere dich heute auf kleine Schritte: Wasser trinken, eine bewusste Mahlzeit und etwas Bewegung.';
    }

    if (bmi >= 25) {
      return 'Du bist auf einem guten Weg. Versuche heute eine Mahlzeit bewusst zu planen und regelmäßig Wasser zu trinken.';
    }

    return 'Dein Gewicht liegt im normalen Bereich. Fokus heute: ausgewogene Ernährung und Bewegung beibehalten.';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Coach-Hinweis', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            Text(hinweisErstellen()),
          ],
        ),
      ),
    );
  }
}