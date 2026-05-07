import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

class FirebaseSyncService {
  static const String _apiKeyKey = 'firebase_api_key';
  static const String _databaseUrlKey = 'firebase_database_url';
  static const String _idTokenKey = 'firebase_id_token';
  static const String _emailKey = 'firebase_email';
  static const String _uidKey = 'firebase_uid';

  final LokalerSpeicher _speicher = LokalerSpeicher();

  Future<void> einrichten({
    required String apiKey,
    required String databaseUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey.trim());
    await prefs.setString(
      _databaseUrlKey,
      databaseUrl.trim().replaceAll(RegExp(r'/$'), ''),
    );
  }

  Future<String?> angemeldeteEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<void> registrieren(String email, String passwort) {
    return _auth(email: email, passwort: passwort, registrieren: true);
  }

  Future<void> anmelden(String email, String passwort) {
    return _auth(email: email, passwort: passwort, registrieren: false);
  }

  Future<void> abmelden() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idTokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_uidKey);
  }

  Future<void> cloudUpload() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = _firebaseDaten(prefs);
    final tage = await _speicher.alleTageLaden();

    final response = await http.put(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/tage.json?auth=${daten.idToken}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tage.map((tag) => tag.zuMap()).toList()),
    );

    if (response.statusCode >= 400) {
      throw Exception('Cloud Upload fehlgeschlagen: ${response.body}');
    }
  }

  Future<void> profilUpload({
    required String name,
    required int groesse,
    required double startGewicht,
    required double zielGewicht,
    required int wasserZiel,
    required int schritteZiel,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final daten = _firebaseDaten(prefs);

    final response = await http.put(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/profil.json?auth=${daten.idToken}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'groesse': groesse,
        'startGewicht': startGewicht,
        'zielGewicht': zielGewicht,
        'wasserZiel': wasserZiel,
        'schritteZiel': schritteZiel,
        'aktualisiertAm': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Profil Upload fehlgeschlagen: ${response.body}');
    }
  }
  Future<void> cloudDownload() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = _firebaseDaten(prefs);

    final response = await http.get(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/tage.json?auth=${daten.idToken}',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Cloud Download fehlgeschlagen: ${response.body}');
    }

    if (response.body == 'null') return;

    final List<dynamic> jsonListe = jsonDecode(response.body);
    final tage = jsonListe
        .map((eintrag) => TagesEintrag.vonMap(Map<String, dynamic>.from(eintrag)))
        .toList();

    await _speicher.alleTageSpeichern(tage);
  }

  Future<Map<String, dynamic>?> profilDownload() async {
    final prefs = await SharedPreferences.getInstance();
    final daten = _firebaseDaten(prefs);

    final response = await http.get(
      Uri.parse(
        '${daten.databaseUrl}/users/${daten.uid}/profil.json?auth=${daten.idToken}',
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception('Profil Download fehlgeschlagen: ${response.body}');
    }

    if (response.body == 'null') {
      return null;
    }

    return Map<String, dynamic>.from(jsonDecode(response.body));
  }
  Future<void> _auth({
    required String email,
    required String passwort,
    required bool registrieren,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString(_apiKeyKey) ?? '';

    if (apiKey.isEmpty) {
      throw Exception('Firebase API-Key fehlt.');
    }

    final endpoint = registrieren ? 'signUp' : 'signInWithPassword';

    final response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$endpoint?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': passwort,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Firebase Login fehlgeschlagen: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    await prefs.setString(_idTokenKey, body['idToken']);
    await prefs.setString(_emailKey, body['email']);
    await prefs.setString(_uidKey, body['localId']);
  }

  _FirebaseDaten _firebaseDaten(SharedPreferences prefs) {
    final databaseUrl = prefs.getString(_databaseUrlKey) ?? '';
    final idToken = prefs.getString(_idTokenKey) ?? '';
    final uid = prefs.getString(_uidKey) ?? '';

    if (databaseUrl.isEmpty) throw Exception('Firebase Database URL fehlt.');
    if (idToken.isEmpty || uid.isEmpty) throw Exception('Bitte zuerst anmelden.');

    return _FirebaseDaten(
      databaseUrl: databaseUrl,
      idToken: idToken,
      uid: uid,
    );
  }
}

class _FirebaseDaten {
  final String databaseUrl;
  final String idToken;
  final String uid;

  _FirebaseDaten({
    required this.databaseUrl,
    required this.idToken,
    required this.uid,
  });
}