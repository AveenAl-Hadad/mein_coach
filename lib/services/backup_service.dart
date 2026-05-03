import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

/// Service für Backup Export und Import.
/// Exportiert und importiert alle gespeicherten Tagesdaten als JSON.
class BackupService {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  /// Exportiert alle gespeicherten Tage als JSON-Datei.
  Future<void> backupExportieren() async {
    final tage = await _speicher.alleTageLaden();

    final jsonText = jsonEncode(
      tage.map((tag) => tag.zuMap()).toList(),
    );

    final ordner = await getTemporaryDirectory();
    final datei = File('${ordner.path}/mein_coach_backup.json');

    await datei.writeAsString(jsonText);

    await Share.shareXFiles(
      [XFile(datei.path)],
      text: 'Mein Coach Backup',
    );
  }

  /// Importiert ein JSON-Backup und speichert die Daten lokal.
  Future<void> backupImportieren() async {
    final ergebnis = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (ergebnis == null) return;

    final pfad = ergebnis.files.single.path;
    if (pfad == null) return;

    final datei = File(pfad);
    final jsonText = await datei.readAsString();

    final List<dynamic> daten = jsonDecode(jsonText);

    final tage = daten
        .map((eintrag) => TagesEintrag.vonMap(eintrag))
        .toList();

    await _speicher.alleTageSpeichern(tage);
  }
}