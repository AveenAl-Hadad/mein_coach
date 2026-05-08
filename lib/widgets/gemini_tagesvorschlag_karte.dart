import 'package:flutter/material.dart';

import '../modelle/tages_eintrag.dart';
import '../services/gemini_service.dart';
import '../style/app_style.dart';
import '../services/gemini_vorschlag_speicher_service.dart';
import 'package:flutter/services.dart';
import '../services/gemini_pdf_service.dart';

class GeminiTagesvorschlagKarte extends StatefulWidget {
  final TagesEintrag eintrag;
  final int wasserZiel;
  final int schritteZiel;

  const GeminiTagesvorschlagKarte({
    super.key,
    required this.eintrag,
    required this.wasserZiel,
    required this.schritteZiel,
  });

  @override
  State<GeminiTagesvorschlagKarte> createState() =>
      _GeminiTagesvorschlagKarteState();
}

class _GeminiTagesvorschlagKarteState extends State<GeminiTagesvorschlagKarte> {
  final GeminiService geminiService = GeminiService();
  final GeminiVorschlagSpeicherService speicherService = GeminiVorschlagSpeicherService();
  final GeminiPdfService pdfService = GeminiPdfService();
  bool wirdGeladen = false;
  String antwort = '';

  @override
  void initState() {
    super.initState();
    vorschlagLaden();
  }

  Future<void> vorschlagLaden() async {
    final gespeicherteAntwort =
        await speicherService.laden(widget.eintrag.datum);

    if (!mounted) return;

    setState(() {
      antwort = gespeicherteAntwort;
    });
  }

  Future<void> vorschlagErstellen() async {
    setState(() {
      wirdGeladen = true;
      antwort = '';
    });

    final mahlzeiten = widget.eintrag.mahlzeiten
        .map((m) => '${m.kategorie}: ${m.text}')
        .join(', ');

    final prompt = '''
      Analysiere meinen heutigen Tag kurz auf Deutsch.

      Daten:
      - Datum: ${widget.eintrag.datum}
      - Gewicht: ${widget.eintrag.gewicht.toStringAsFixed(1)} kg
      - Wasser: ${widget.eintrag.wasser} von ${widget.wasserZiel} Gläsern
      - Schritte: ${widget.eintrag.schritte} von ${widget.schritteZiel}
      - Stimmung: ${widget.eintrag.stimmung}
      - Notiz: ${widget.eintrag.notiz}
      - Mahlzeiten: ${mahlzeiten.isEmpty ? 'Keine Mahlzeiten gespeichert' : mahlzeiten}

      Gib mir:
      1. kurzes Lob
      2. einen Verbesserungstipp
      3. eine kleine Challenge für heute
      ''';

    try {
      final neueAntwort = await geminiService.nachrichtSenden(prompt);
      await speicherService.speichern(datum: widget.eintrag.datum, text: neueAntwort,);

      if (!mounted) return;

      setState(() {
        antwort = neueAntwort;
      });
    } catch (fehler) {
      if (!mounted) return;

      setState(() {
        antwort = 'Fehler: $fehler';
      });
    } 
    finally {
      if (mounted) {
        setState(() {
          wirdGeladen = false;
        });
      }
    }
  }

  Future<void> vorschlagLoeschen() async {
    await speicherService.loeschen(widget.eintrag.datum);

    if (!mounted) return;

    setState(() {
      antwort = '';
    });
  }

  Future<void> vorschlagKopieren() async {
    await Clipboard.setData(
      ClipboardData(text: antwort),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tagesvorschlag wurde kopiert.'),
      ),
    );
  }
  
  Future<void> pdfExportieren() async {
    await pdfService.pdfExportieren(
      datum: widget.eintrag.datum,
      text: antwort,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppStyle.standardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gemini Tagesvorschlag', style: AppStyle.titelMittel),
            AppStyle.abstandKlein,
            const Text(
              'Lass deinen Tag automatisch von Gemini analysieren.',
            ),
            AppStyle.abstandKlein,
            ElevatedButton.icon(
              onPressed: wirdGeladen ? null : vorschlagErstellen,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('KI Vorschlag erstellen'),
            ),
            if (wirdGeladen) ...[
              AppStyle.abstandMittel,
              const Center(child: CircularProgressIndicator()),
            ],
            if (antwort.isNotEmpty) ...[
              AppStyle.abstandMittel,
              Text(antwort),
              AppStyle.abstandKlein,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: antwort.isEmpty ? null : vorschlagKopieren,
                      icon: const Icon(Icons.copy),
                      label: const Text('Kopieren'),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: wirdGeladen ? null : vorschlagLoeschen,
                      icon: const Icon(Icons.delete),
                      label: const Text('Löschen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: wirdGeladen ? null : vorschlagErstellen,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Neu erstellen'),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: antwort.isEmpty
                          ? null
                          : pdfExportieren,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('PDF'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}