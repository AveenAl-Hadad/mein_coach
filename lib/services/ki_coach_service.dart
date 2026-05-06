import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../modelle/tages_eintrag.dart';

class KiCoachService {
  static const String _apiKeyKey = 'openai_api_key';

  Future<void> apiKeySpeichern(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey.trim());
  }

  Future<String> tippErstellen({
    required List<TagesEintrag> tage,
    required int wasserZiel,
    required int schritteZiel,
    required double zielGewicht,
    required String frage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey) ?? '';

    if (apiKey.isEmpty) {
      throw Exception('OpenAI API-Key fehlt.');
    }

    final letzteTage = [...tage]..sort((a, b) => b.datum.compareTo(a.datum));

    final daten = letzteTage.take(14).map((tag) => tag.zuMap()).toList();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': [
          {
            'role': 'system',
            'content':
                'Du bist ein freundlicher Fitness- und Ernährungscoach. Antworte kurz und verständlich auf Deutsch. Gib keine medizinische Diagnose.',
          },
          {
            'role': 'user',
            'content': jsonEncode({
              'frage': frage.trim().isEmpty
                  ? 'Analysiere meine Daten und gib mir 3 konkrete Tipps für heute.'
                  : frage.trim(),
              'wasserZiel': wasserZiel,
              'schritteZiel': schritteZiel,
              'zielGewicht': zielGewicht,
              'tage': daten,
            }),
          },
        ],
        'temperature': 0.7,
        'max_tokens': 450,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('KI Coach Fehler: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    return body['choices'][0]['message']['content'].toString().trim();
  }
}