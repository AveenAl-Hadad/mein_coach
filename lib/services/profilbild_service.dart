import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilbildService {
  static const String _profilbildKey = 'profilbild_pfad';

  final ImagePicker _picker = ImagePicker();

  Future<String?> profilbildLaden() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilbildKey);
  }

  Future<String?> profilbildAuswaehlen() async {
    final bild = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (bild == null) return null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilbildKey, bild.path);

    return bild.path;
  }

  Future<void> profilbildLoeschen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profilbildKey);
  }
}