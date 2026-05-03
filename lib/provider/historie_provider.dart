import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

/// Provider für die Historie.
/// Lädt und verwaltet alle gespeicherten TagesEinträge.
class HistorieProvider extends ChangeNotifier {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  List<TagesEintrag> tage = [];
  bool wirdGeladen = true;

  /// Lädt alle Tage aus dem lokalen Speicher.
  Future<void> tageLaden() async {
    wirdGeladen = true;
    notifyListeners();

    final geladeneTage = await _speicher.alleTageLaden();

    tage = geladeneTage.reversed.toList();
    wirdGeladen = false;

    notifyListeners();
  }
}