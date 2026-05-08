import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeminiPdfService {
  Future<void> pdfExportieren({
    required String datum,
    required String text,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Mein Coach KI Tagesvorschlag',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  'Datum: $datum',
                  style: const pw.TextStyle(fontSize: 14),
                ),

                pw.Divider(),

                pw.SizedBox(height: 16),

                pw.Text(
                  text,
                  style: const pw.TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );

    final Uint8List daten = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (format) async => daten,
    );
  }
}