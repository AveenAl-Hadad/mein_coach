import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../modelle/chat_nachricht.dart';

class ChatSpeicherService {
  static const String _chatKey = 'ki_chat_verlauf';

  Future<List<ChatNachricht>> chatLaden() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_chatKey);

    if (text == null || text.isEmpty) return [];

    final liste = jsonDecode(text) as List;

    return liste
        .map((eintrag) => ChatNachricht.vonMap(Map<String, dynamic>.from(eintrag)))
        .toList();
  }

  Future<void> chatSpeichern(List<ChatNachricht> nachrichten) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _chatKey,
      jsonEncode(nachrichten.map((n) => n.zuMap()).toList()),
    );
  }

  Future<void> chatLoeschen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatKey);
  }
}