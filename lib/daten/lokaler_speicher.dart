import 'package:shared_preferences/shared_preferences.dart';
import '../modelle/tages_eintrag.dart';

/// Diese Klasse ist für das lokale Speichern zuständig.
/// Sie speichert Daten direkt auf dem Gerät.
class LokalerSpeicher {
  static const String _gewichtSchluessel = 'gewicht';
  static const String _wasserSchluessel = 'wasser';
  static const String _schritteSchluessel = 'schritte';
  static const String _mahlzeitenSchluessel = 'mahlzeiten';

  /// Lädt gespeicherte Tagesdaten.
  /// Wenn nichts gespeichert ist, wird ein Standardwert zurückgegeben.
  Future<TagesEintrag> tagesEintragLaden() async {
    final speicher = await SharedPreferences.getInstance();

    return TagesEintrag(
      gewicht: speicher.getDouble(_gewichtSchluessel) ?? 80.0,
      wasser: speicher.getInt(_wasserSchluessel) ?? 0,
      schritte: speicher.getInt(_schritteSchluessel) ?? 0,
      mahlzeiten: speicher.getStringList(_mahlzeitenSchluessel) ?? [],
    );
  }

  /// Speichert den kompletten TagesEintrag lokal.
  Future<void> tagesEintragSpeichern(TagesEintrag eintrag) async {
    final speicher = await SharedPreferences.getInstance();

    await speicher.setDouble(_gewichtSchluessel, eintrag.gewicht);
    await speicher.setInt(_wasserSchluessel, eintrag.wasser);
    await speicher.setInt(_schritteSchluessel, eintrag.schritte);
    await speicher.setStringList(_mahlzeitenSchluessel, eintrag.mahlzeiten);
  }
}