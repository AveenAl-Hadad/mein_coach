import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

class BackupService {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  Future<void> backupExportieren() async {
    final tage = await _speicher.alleTageLaden();

    final jsonText = const JsonEncoder.withIndent('  ').convert(
      tage.map((tag) => tag.zuMap()).toList(),
    );

    final ordner = await getTemporaryDirectory();
    final datei = File('${ordner.path}/mein_coach_backup.json');

    await datei.writeAsString(jsonText);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(datei.path)],
        text: 'Mein Coach Backup',
      ),
    );
  }

  Future<void> csvExportieren() async {
    final tage = await _speicher.alleTageLaden();

    final buffer = StringBuffer(
      'Datum;Gewicht;Wasser;Schritte;Stimmung;Notiz;Mahlzeiten\n',
    );

    for (final tag in tage) {
      final mahlzeiten = tag.mahlzeiten
          .map((m) => '${m.kategorie}: ${m.text}')
          .join(' | ');

      buffer.writeln([
        tag.datum,
        tag.gewicht.toStringAsFixed(1),
        tag.wasser,
        tag.schritte,
        tag.stimmung,
        _csv(tag.notiz),
        _csv(mahlzeiten),
      ].join(';'));
    }

    final ordner = await getTemporaryDirectory();
    final datei = File('${ordner.path}/mein_coach_export.csv');

    await datei.writeAsString(buffer.toString());

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(datei.path)],
        text: 'Mein Coach CSV Export',
      ),
    );
  }

  Future<void> backupImportieren() async {
    final ergebnis = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (ergebnis == null || ergebnis.files.single.path == null) return;

    final text = await File(ergebnis.files.single.path!).readAsString();
    final daten = jsonDecode(text);

    if (daten is! List) {
      throw Exception('Ungültiges Backup.');
    }

    final tage = daten
        .map((eintrag) => TagesEintrag.vonMap(Map<String, dynamic>.from(eintrag)))
        .toList();

    await _speicher.alleTageSpeichern(tage);
  }

  String _csv(String wert) {
    final escaped = wert.replaceAll('"', '""');
    return '"$escaped"';
  }
}