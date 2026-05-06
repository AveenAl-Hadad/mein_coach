import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../modelle/tages_eintrag.dart';

class PdfExportService {
  Future<void> tagesberichtExportieren({
    required TagesEintrag eintrag,
    required int wasserZiel,
    required int schritteZiel,
  }) async {
    final dokument = pw.Document();

    dokument.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Mein Coach Tagesbericht',
                style: pw.TextStyle(fontSize: 24),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Datum: ${eintrag.datum}'),
              pw.Text('Gewicht: ${eintrag.gewicht.toStringAsFixed(1)} kg'),
              pw.Text('Wasser: ${eintrag.wasser} / $wasserZiel Gläser'),
              pw.Text('Schritte: ${eintrag.schritte} / $schritteZiel'),
              pw.Text('Stimmung: ${eintrag.stimmung}'),
              pw.SizedBox(height: 16),
              pw.Text('Notiz:'),
              pw.Text(eintrag.notiz.isEmpty ? '-' : eintrag.notiz),
              pw.SizedBox(height: 16),
              pw.Text('Mahlzeiten:'),
              for (final mahlzeit in eintrag.mahlzeiten)
                pw.Text('- ${mahlzeit.kategorie}: ${mahlzeit.text}'),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await dokument.save(),
      filename: 'mein_coach_tagesbericht_${eintrag.datum}.pdf',
    );
  }
}