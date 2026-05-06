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

  @override
  Widget build(BuildContext context) {
    final erreicht = prozent;
    final offen = 1 - erreicht;

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(titel, style: AppStyle.titelMittel),
              ],
            ),
            AppStyle.abstandKlein,
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 46,
                      sections: [
                        PieChartSectionData(value: erreicht, title: ''),
                        PieChartSectionData(value: offen, title: ''),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(erreicht * 100).toStringAsFixed(0)} %',
                        style: AppStyle.titelMittel,
                      ),
                      Text(
                        '${aktuell.toStringAsFixed(0)} / ${ziel.toStringAsFixed(0)} $einheit',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}