import 'package:flutter/material.dart';
import '../style/app_style.dart';
import 'start_seite.dart';
import 'historie_seite.dart';
import '../style/app_texte.dart';
import 'einstellungen_seite.dart';
import 'mahlzeiten_galerie_seite.dart';
import 'ki_coach_seite.dart';


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
    EinstellungenSeite(),
    KiCoachSeite(),
    MahlzeitenGalerieSeite(),
   
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
        type: AppStyle.navigationTyp,
        iconSize: AppStyle.navigationIconGroesse,
        currentIndex: ausgewaehlterIndex,
        onTap: seiteWechseln,
        items: const [
          BottomNavigationBarItem(
            icon: AppStyle.heuteIcon,
            label: AppTexte.heute,
          ),
          BottomNavigationBarItem(
            icon: AppStyle.navigationHistorieIcon,
            label: AppTexte.historie,
          ),
          BottomNavigationBarItem(
            icon: AppStyle.einstellungenIcon,
            label: AppTexte.einstellungen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Galerie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'KI Coach',
          ),

      ],
      ),
    );
  }
}