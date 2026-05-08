import 'package:shared_preferences/shared_preferences.dart';

class GeminiVorschlagSpeicherService {
  static const String _prefix = 'gemini_tagesvorschlag_';

  Future<void> speichern({
    required String datum,
    required String text,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$datum', text);
  }

  Future<String> laden(String datum) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_prefix$datum') ?? '';
  }

  Future<void> loeschen(String datum) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$datum');
  }
}