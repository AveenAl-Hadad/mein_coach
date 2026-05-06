import 'dart:convert';
import 'dart:io';


import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../daten/lokaler_speicher.dart';


class BackupService {
  final LokalerSpeicher _speicher = LokalerSpeicher();

  Future<void> backupExportieren() async {
    final tage = await _speicher.alleTageLaden();

    final jsonText = const JsonEncoder.withIndent(
      '  ',
    ).convert(tage.map((tag) => tag.zuMap()).toList());

    final ordner = await getTemporaryDirectory();
    final datei = File('${ordner.path}/mein_coach_backup.json');

    await datei.writeAsString(jsonText);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(datei.path)], text: 'Mein Coach Backup'),
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

      buffer.writeln(
        [
          tag.datum,
          tag.gewicht.toStringAsFixed(1),
          tag.wasser,
          tag.schritte,
          tag.stimmung,
          _csv(tag.notiz),
          _csv(mahlzeiten),
        ].join(';'),
      );
    }

    final ordner = await getTemporaryDirectory();
    final datei = File('${ordner.path}/mein_coach_export.csv');

    await datei.writeAsString(buffer.toString());

    await SharePlus.instance.share(
      ShareParams(files: [XFile(datei.path)], text: 'Mein Coach CSV Export'),
    );
  }

  
  String _csv(String text) {
    if (text.contains(';') || text.contains('"') || text.contains('\n')) {
      return '"${text.replaceAll('"', '""')}"';
    }
    return text;
  }
}
