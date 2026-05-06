import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

class ZielKreisKarte extends StatelessWidget {
  final String titel;
  final double aktuell;
  final double ziel;
  final String einheit;
  final IconData icon;

  const ZielKreisKarte({
    super.key,
    required this.titel,
    required this.aktuell,
    required this.ziel,
    required this.einheit,
    required this.icon,
  });

  double get prozent {
    if (ziel <= 0) return 0;
    return (aktuell / ziel).clamp(0, 1).toDouble();
  }

  Color farbe() {
    if (prozent >= 1) {
      return Colors.green;
    }

    if (prozent >= 0.7) {
      return Colors.orange;
    }

    return Colors.red;
  }

  String motivation() {
    if (prozent >= 1) {
      return 'Ziel erreicht 🔥';
    }

    if (prozent >= 0.7) {
      return 'Fast geschafft 💪';
    }

    return 'Weiter so 🚀';
  }

  @override
  Widget build(BuildContext context) {
    final erreicht = prozent;
    final offen = 1 - erreicht;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: farbe()),
                const SizedBox(width: 8),
                Text(
                  titel,
                  style: AppStyle.titelMittel,
                ),
              ],
            ),

            AppStyle.abstandMittel,

            SizedBox(
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          value: erreicht,
                          color: farbe(),
                          radius: 18,
                          title: '',
                        ),
                        PieChartSectionData(
                          value: offen,
                          color: Colors.grey.shade300,
                          radius: 18,
                          title: '',
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(erreicht * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${aktuell.toStringAsFixed(0)} / ${ziel.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      Text(
                        einheit,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppStyle.abstandKlein,

            Text(
              motivation(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: farbe(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}