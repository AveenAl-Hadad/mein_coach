import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static const String _apiKeyKey = 'gemini_api_key';

  Future<void> apiKeySpeichern(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey.trim());
  }

  Future<String> nachrichtSenden(String nachricht) async {
    //final apiKey = 'AIzaSyCJ2SlSi9YJOWfA3m932ASPKRtrlOyy4oU';
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey) ?? '';
   

    if (apiKey.isEmpty) {
      throw Exception('Gemini API-Key fehlt.');
    }

    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Du bist ein freundlicher Fitness- und Ernährungscoach. Antworte kurz auf Deutsch.\n\n$nachricht',
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gemini Fehler: ${response.body}');
    }

    final daten = jsonDecode(response.body);
    return daten['candidates'][0]['content']['parts'][0]['text']
        .toString()
        .trim();
  }
}