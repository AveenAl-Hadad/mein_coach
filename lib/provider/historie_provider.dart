import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

/// Provider für die Historie.
/// Diese Klasse verwaltet alle gespeicherten Tage.
class HistorieProvider extends ChangeNotifier {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  List<TagesEintrag> tage = [];
  bool wirdGeladen = true;

  /// Lädt alle gespeicherten Tage aus dem lokalen Speicher.
  Future<void> tageLaden() async {
    wirdGeladen = true;
    notifyListeners();

    final geladeneTage = await _speicher.alleTageLaden();

    tage = geladeneTage.reversed.toList();
    wirdGeladen = false;

    notifyListeners();
  }

  /// Aktualisiert die Historie ohne Ladebildschirm.
  /// Diese Methode benutzen wir nach Änderungen auf der Startseite.
  Future<void> aktualisieren() async {
    final geladeneTage = await _speicher.alleTageLaden();

    tage = geladeneTage.reversed.toList();

    notifyListeners();
  }

 
}