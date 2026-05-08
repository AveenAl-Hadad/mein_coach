import 'package:shared_preferences/shared_preferences.dart';

class FavoritService {
  static const String _prefix = 'favorit_gemini_vorschlag_';

  Future<bool> istFavorit(String datum) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$datum') ?? false;
  }

  Future<void> favoritSpeichern({
    required String datum,
    required bool istFavorit,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$datum', istFavorit);
  }
}