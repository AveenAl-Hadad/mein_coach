import 'package:flutter/material.dart';

import '../style/app_style.dart';
import '../services/coach_service.dart';
import '../modelle/tages_eintrag.dart';

/// Karte mit einfachem Coach-Hinweis.
/// Der Hinweis basiert aktuell auf BMI und Fortschritt.
/// Später kann hier KI oder bessere Logik ergänzt werden.
class CoachHinweisKarte extends StatelessWidget {
  final int groesse;
  final double aktuellesGewicht;
  final double zielGewicht;
  final List<TagesEintrag> tage;
  final int wasserZiel;
  final int schritteZiel;

  const CoachHinweisKarte({
    super.key,
    required this.groesse,
    required this.aktuellesGewicht,
    required this.zielGewicht,
    required this.tage,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  /// Berechnet den BMI aus Größe und Gewicht.
  double bmiBerechnen() {
    final groesseInMeter = groesse / 100;
    return aktuellesGewicht / (groesseInMeter * groesseInMeter);
  }

  /// Erstellt einen einfachen Gesundheits-Hinweis.
 String hinweisErstellen() {
  final service = CoachService();

  return service.erstelleHinweis(
    tage: tage,
    wasserZiel: wasserZiel,
    schritteZiel: schritteZiel,
  );
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