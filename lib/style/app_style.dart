import 'package:flutter/material.dart';

/// Zentrale Styles der App.
/// Alle Design-Werte kommen hier rein.
class AppStyle {
  // Farben
  static const Color hauptFarbe = Colors.green;

  // Text Styles
  static const TextStyle titelGross = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titelMittel = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle kleinText = TextStyle(
    fontSize: 12,
  );

  static const TextStyle normalText = TextStyle(
    fontSize: 16,
  );

  // Padding
  static const EdgeInsets standardPadding = EdgeInsets.all(16);

  // Abstände
  static const SizedBox abstandKlein = SizedBox(height: 12);
  static const SizedBox abstandMittel = SizedBox(height: 16);
  static const SizedBox abstandGross = SizedBox(height: 20);

  // Icons
  static const Icon gewichtPlus = Icon(Icons.add);
  static const Icon gewichtMinus = Icon(Icons.remove);
  static const Icon wasserIcon = Icon(Icons.add);
  static const Icon schritteIcon = Icon(Icons.directions_walk);
  static const Icon loeschenIcon = Icon(Icons.delete);
  static const Icon mahlzeitIcon = Icon(Icons.restaurant);
  static const Icon resetIcon = Icon(Icons.refresh);
  static const Icon addIcon = Icon(Icons.add_circle);
  static const Icon historieIcon = Icon(Icons.history);
  static const Icon weiterIcon = Icon(Icons.arrow_forward_ios);
  static const Icon heuteIcon = Icon(Icons.today);
  static const Icon navigationHistorieIcon = Icon(Icons.history);

  // String
  static const String heuteText = 'Heute';
  static const String historieText = 'Historie';
}