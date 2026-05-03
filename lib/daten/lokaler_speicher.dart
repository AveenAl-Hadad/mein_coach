import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelle/tages_eintrag.dart';

/// Diese Klasse speichert und lädt ALLE Tage.
/// Wir speichern eine Liste von TagesEinträgen als JSON.
class LokalerSpeicher {
  static const String _alleTageSchluessel = 'alle_tage';

  /// Lädt alle gespeicherten Tage.
  Future<List<TagesEintrag>> alleTageLaden() async {
    final speicher = await SharedPreferences.getInstance();

    final jsonString = speicher.getString(_alleTageSchluessel);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> daten = jsonDecode(jsonString);

    return daten
        .map((eintrag) => TagesEintrag.vonMap(eintrag))
        .toList();
  }

  /// Speichert alle Tage.
  Future<void> alleTageSpeichern(List<TagesEintrag> tage) async {
    final speicher = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      tage.map((e) => e.zuMap()).toList(),
    );

    await speicher.setString(_alleTageSchluessel, jsonString);
  }

  /// Holt den heutigen Eintrag oder erstellt einen neuen.
  Future<TagesEintrag> heutigenEintragLaden() async {
    final tage = await alleTageLaden();

    final heute = TagesEintrag.heutigesDatum();

    try {
      return tage.firstWhere((e) => e.datum == heute);
    } catch (_) {
      return TagesEintrag.heute();
    }
  }

  /// Speichert oder aktualisiert den heutigen Eintrag.
  Future<void> heutigenEintragSpeichern(TagesEintrag eintrag) async {
    final tage = await alleTageLaden();

    final index = tage.indexWhere((e) => e.datum == eintrag.datum);

    if (index >= 0) {
      tage[index] = eintrag;
    } else {
      tage.add(eintrag);
    }

    await alleTageSpeichern(tage);
  }
}