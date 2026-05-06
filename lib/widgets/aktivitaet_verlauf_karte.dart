import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class AktivitaetVerlaufKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const AktivitaetVerlaufKarte({
    super.key,
    required this.tage,
  });

  @override
  Widget build(BuildContext context) {
    final daten = [...tage]..sort((a, b) => a.datum.compareTo(b.datum));
    final letzte7 = daten.length > 7 ? daten.sublist(daten.length - 7) : daten;

    if (letzte7.isEmpty) {
      return const SizedBox.shrink();
    }

    final wasserPunkte = <BarChartGroupData>[];
    final schrittePunkte = <BarChartGroupData>[];

    for (int i = 0; i < letzte7.length; i++) {
      wasserPunkte.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: letzte7[i].wasser.toDouble(),
              width: 14,
            ),
          ],
        ),
      );

      schrittePunkte.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: letzte7[i].schritte / 1000,
              width: 14,
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aktivität letzte 7 Tage', style: AppStyle.titelMittel),
            AppStyle.abstandMittel,

            const Text('Wasser'),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: wasserPunkte,
                ),
              ),
            ),

            AppStyle.abstandMittel,

            const Text('Schritte in Tausend'),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: schrittePunkte,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}