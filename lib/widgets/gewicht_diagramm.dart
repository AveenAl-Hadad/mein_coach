import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';

/// Diagramm für Gewichtsverlauf.
/// Zeigt Gewicht über mehrere Tage.
class GewichtDiagramm extends StatelessWidget {
  final List<TagesEintrag> tage;

  const GewichtDiagramm({
    super.key,
    required this.tage,
  });

  @override
  Widget build(BuildContext context) {
    if (tage.isEmpty) {
      return const Text('Keine Daten für Diagramm');
    }

    final spots = tage.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final gewicht = entry.value.gewicht;
      return FlSpot(index, gewicht);
    }).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppStyle.hauptFarbe,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}