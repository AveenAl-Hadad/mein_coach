import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritenCloudService {
  Future<_FirebaseDaten> _firebaseDaten() async {
    final prefs = await SharedPreferences.getInstance();

    final idToken = prefs.getString('firebase_id_token');
    final uid = prefs.getString('firebase_uid');
    final databaseUrl = prefs.getString('firebase_database_url');

    if (idToken == null ||
        uid == null ||
        databaseUrl == null) {
      throw Exception('Nicht angemeldet.');
    }

    return _FirebaseDaten(
      idToken: idToken,
      uid: uid,
      databaseUrl: databaseUrl,
    );
  }

  Future<void> favoritHochladen({
    required String datum,
    required String text,
  }) async {
    final daten = await _firebaseDaten();

    final response = await http.put(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/favoriten/$datum.json?auth=${daten.idToken}',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'datum': datum,
        'text': text,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception(
        'Cloud Upload fehlgeschlagen.',
      );
    }
  }
  Future<List<Map<String, dynamic>>> favoritenHerunterladen() async {
    final daten = await _firebaseDaten();

    final response = await http.get(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/favoriten.json?auth=${daten.idToken}',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Cloud Download fehlgeschlagen.');
    }

    if (response.body == 'null') {
      return [];
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    return body.values
        .map((eintrag) => Map<String, dynamic>.from(eintrag))
        .toList();
  }
  Future<void> favoritLoeschen(String datum) async {
    final daten = await _firebaseDaten();

    final response = await http.delete(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/favoriten/$datum.json?auth=${daten.idToken}',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Cloud Löschen fehlgeschlagen.');
    }
  }

}

class _FirebaseDaten {
  final String idToken;
  final String uid;
  final String databaseUrl;

  _FirebaseDaten({
    required this.idToken,
    required this.uid,
    required this.databaseUrl,
  });
}