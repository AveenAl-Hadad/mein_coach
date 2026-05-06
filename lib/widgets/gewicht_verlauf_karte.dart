import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

class GewichtVerlaufKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const GewichtVerlaufKarte({
    super.key,
    required this.tage,
  });

  @override
  Widget build(BuildContext context) {
    final daten = [...tage]
      ..sort((a, b) => a.datum.compareTo(b.datum));

    final letzte14 = daten.length > 14
        ? daten.sublist(daten.length - 14)
        : daten;

    if (letzte14.isEmpty) {
      return const SizedBox.shrink();
    }

    final punkte = <FlSpot>[];

    for (int i = 0; i < letzte14.length; i++) {
      punkte.add(
        FlSpot(
          i.toDouble(),
          letzte14[i].gewicht,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gewicht-Verlauf', style: AppStyle.titelMittel),
            AppStyle.abstandMittel,
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: punkte,
                      isCurved: true,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}