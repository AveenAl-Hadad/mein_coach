import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import 'package:fl_chart/fl_chart.dart';

/// Karte für die Kalorien-Wochenanalyse.
/// Zeigt Durchschnitt, höchsten Tag und niedrigsten Tag.
class KalorienWochenanalyseKarte extends StatelessWidget {
  final List<TagesEintrag> tage;

  const KalorienWochenanalyseKarte({
    super.key,
    required this.tage,
  });

  List<TagesEintrag> letzteSiebenTage() {
    final sortiert = [...tage]
      ..sort((a, b) => b.datum.compareTo(a.datum));

    return sortiert.take(7).toList();
  }

Widget infoZeile(String titel, String wert) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titel),
        Text(
          wert,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
String wochentagKurz(String datumText) {
  final datum = DateTime.tryParse(datumText);

  if (datum == null) {
    return '';
  }

  const tage = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  return tage[datum.weekday - 1];
}
  @override
  Widget build(BuildContext context) {
    final letzteTage = letzteSiebenTage();

    if (letzteTage.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Noch keine Kalorien-Daten vorhanden.'),
        ),
      );
    }

    final kalorienListe = letzteTage.map((tag) => tag.gesamtKalorien()).toList();

    final durchschnitt =
        kalorienListe.reduce((a, b) => a + b) / kalorienListe.length;

    final hoechsterWert = kalorienListe.reduce((a, b) => a > b ? a : b);
    final niedrigsterWert = kalorienListe.reduce((a, b) => a < b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kalorien-Wochenanalyse',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            infoZeile('Durchschnitt:', '${durchschnitt.round()} kcal'),
            infoZeile('Höchster Tag:', '$hoechsterWert kcal'),
            infoZeile('Niedrigster Tag:', '$niedrigsterWert kcal'),

            const SizedBox(height: 16),

            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (hoechsterWert + 300).toDouble(),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= letzteTage.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              wochentagKurz(letzteTage[index].datum),
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                  barGroups: List.generate(
                    kalorienListe.length,
                    (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: kalorienListe[index].toDouble(),
                            width: 16,
                            color: kalorienListe[index] <= durchschnitt
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}