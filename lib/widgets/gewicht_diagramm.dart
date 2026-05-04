import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';

/// Diagramm für den Gewichtsverlauf.
/// Diese Klasse zeigt gespeicherte Gewichtswerte über mehrere Tage.
class GewichtDiagramm extends StatelessWidget {
  final List<TagesEintrag> tage;

  const GewichtDiagramm({
    super.key,
    required this.tage,
  });

  @override
  Widget build(BuildContext context) {
    final sortierteTage = [...tage]
      ..sort((a, b) => a.datum.compareTo(b.datum));

    if (sortierteTage.isEmpty) {
      return const Card(
        child: Padding(
          padding: AppStyle.standardPadding,
          child: Text(AppTexte.keineDiagrammDaten),
        ),
      );
    }

    final spots = _diagrammPunkteErstellen(sortierteTage);
    final werte = sortierteTage.map((tag) => tag.gewicht).toList();

    final minGewicht = werte.reduce(min);
    final maxGewicht = werte.reduce(max);

    final minY = (minGewicht - 2).floorToDouble();
    final maxY = (maxGewicht + 2).ceilToDouble();

    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppTexte.gewichtDiagrammTitel,
              style: AppStyle.titelMittel,
            ),
            AppStyle.abstandKlein,
            SizedBox(
              height: AppStyle.diagrammHoehe,
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: AppStyle.diagrammRandLinks,
                        getTitlesWidget: (wert, meta) {
                          return Text(
                            '${wert.toStringAsFixed(0)} kg',
                            style: AppStyle.kleinText,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: AppStyle.diagrammRandUnten,
                        getTitlesWidget: (wert, meta) {
                          final index = wert.toInt();

                          if (index < 0 || index >= sortierteTage.length) {
                            return const SizedBox.shrink();
                          }

                          return Text(
                            _kurzesDatum(sortierteTage[index].datum),
                            style: AppStyle.kleinText,
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppStyle.hauptFarbe,
                      barWidth: AppStyle.diagrammLinienBreite,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, prozent, balken, index) {
                          return FlDotCirclePainter(
                            radius: AppStyle.diagrammPunktGroesse,
                            color: AppStyle.hauptFarbe,
                          );
                        },
                      ),
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

  /// Erstellt die Punkte für das Diagramm.
  /// X ist der Index des Tages, Y ist das Gewicht.
  List<FlSpot> _diagrammPunkteErstellen(List<TagesEintrag> sortierteTage) {
    return sortierteTage.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final gewicht = entry.value.gewicht;

      return FlSpot(index, gewicht);
    }).toList();
  }

  /// Wandelt ein Datum von yyyy-mm-dd zu dd.mm um.
  String _kurzesDatum(String datum) {
    final teile = datum.split('-');

    if (teile.length != 3) {
      return datum;
    }

    return '${teile[2]}.${teile[1]}';
  }
}