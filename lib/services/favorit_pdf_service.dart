import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FavoritPdfService {
  Future<void> exportieren({
    required String datum,
    required String text,
  }) async {
    final dokument = pw.Document();

    dokument.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Mein Coach Favorit',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text('Datum: $datum'),
                pw.Divider(),
                pw.SizedBox(height: 16),
                pw.Text(text),
              ],
            ),
          );
        },
      ),
    );

    final Uint8List daten = await dokument.save();

    await Printing.layoutPdf(
      onLayout: (format) async => daten,
    );
  }
}