import 'package:flutter/material.dart';
import '../style/app_style.dart';
import 'start_seite.dart';
import 'historie_seite.dart';

/// Hauptnavigation der App.
/// Hier wird zwischen Heute und Historie gewechselt.
class HauptNavigation extends StatefulWidget {
  const HauptNavigation({super.key});

  @override
  State<HauptNavigation> createState() => _HauptNavigationStatus();
}

class _HauptNavigationStatus extends State<HauptNavigation> {
  int ausgewaehlterIndex = 0;

  final List<Widget> seiten = const [
    StartSeite(),
    HistorieSeite(),
  ];

  /// Ändert die aktive Seite der Bottom Navigation.
  void seiteWechseln(int index) {
    setState(() {
      ausgewaehlterIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: seiten[ausgewaehlterIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ausgewaehlterIndex,
        onTap: seiteWechseln,
        items: const [
          BottomNavigationBarItem(
            icon: AppStyle.heuteIcon,
            label: AppStyle.heuteText,
          ),
          BottomNavigationBarItem(
            icon: AppStyle.navigationHistorieIcon,
            label: AppStyle.historieText,
          ),
        ],
      ),
    );
  }
}