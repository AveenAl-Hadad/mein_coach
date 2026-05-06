import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../modelle/tages_eintrag.dart';

class KiCoachService {
  static const String _apiKeyKey = 'openai_api_key';
  static const String _modelKey = 'openai_model';

  Future<void> apiKeySpeichern(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey.trim());
  }

  Future<void> modelSpeichern(String model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _modelKey,
      model.trim().isEmpty ? 'gpt-4o-mini' : model.trim(),
    );
  }

  Future<String> tippErstellen({
    required List<TagesEintrag> tage,
    required int wasserZiel,
    required int schritteZiel,
    required double zielGewicht,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey) ?? '';
    final model = prefs.getString(_modelKey) ?? 'gpt-4o-mini';

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
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content':
                'Du bist ein freundlicher Fitness- und Ernährungscoach. Antworte kurz auf Deutsch. Keine medizinische Diagnose.',
          },
          {
            'role': 'user',
            'content': jsonEncode({
              'wasserZiel': wasserZiel,
              'schritteZiel': schritteZiel,
              'zielGewicht': zielGewicht,
              'tage': daten,
              'aufgabe':
                  'Analysiere meine Daten und gib mir 3 konkrete Tipps für heute.',
            }),
          },
        ],
        'temperature': 0.7,
        'max_tokens': 350,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('KI Coach Fehler: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return body['choices'][0]['message']['content'].toString().trim();
  }
}