import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/historie_provider.dart';
import '../services/favorit_service.dart';
import '../services/gemini_vorschlag_speicher_service.dart';
import '../style/app_style.dart';
import 'package:flutter/services.dart';
import '../services/favorit_pdf_service.dart';
import '../services/favoriten_cloud_service.dart';

class FavoritenSeite extends StatefulWidget {
  const FavoritenSeite({super.key});

  @override
  State<FavoritenSeite> createState() => _FavoritenSeiteState();
}

class _FavoritenSeiteState extends State<FavoritenSeite> {
  final FavoritService favoritService = FavoritService();
  final GeminiVorschlagSpeicherService speicherService =
      GeminiVorschlagSpeicherService();
  final FavoritenCloudService favoritenCloudService =
    FavoritenCloudService();

  final List<_FavoritEintrag> favoriten = [];
  final TextEditingController suchController = TextEditingController();
  final FavoritPdfService favoritPdfService = FavoritPdfService();
  String suchText = '';

  bool wirdGeladen = true;

  @override
  void dispose() {
    suchController.dispose();
    super.dispose();
  }
    @override
    void initState() {
      super.initState();
      favoritenLaden();
    }

    Future<void> favoritenLaden() async {
      final historieProvider = context.read<HistorieProvider>();
      final neueFavoriten = <_FavoritEintrag>[];

      for (final tag in historieProvider.tage) {
        final istFavorit = await favoritService.istFavorit(tag.datum);

        if (!istFavorit) continue;

        final text = await speicherService.laden(tag.datum);

        if (text.isEmpty) continue;

        neueFavoriten.add(
          _FavoritEintrag(
            datum: tag.datum,
            text: text,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        favoriten
          ..clear()
          ..addAll(neueFavoriten);

        wirdGeladen = false;
      });
    }
    Future<void> favoritEntfernen(_FavoritEintrag eintrag) async {
      await favoritService.favoritSpeichern(
        datum: eintrag.datum,
        istFavorit: false,
      );

      try {
        await favoritenCloudService.favoritLoeschen(eintrag.datum);
      } catch (_) {
        // Falls keine Cloud eingerichtet ist, wird nur lokal gelöscht.
      }

      if (!mounted) return;

      setState(() {
        favoriten.remove(eintrag);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorit wurde gelöscht.'),
        ),
      );
    }
    Future<void> favoritKopieren(_FavoritEintrag eintrag) async {
      await Clipboard.setData(
        ClipboardData(text: eintrag.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorit wurde kopiert.'),
        ),
      );
    }
    Future<void> favoritAlsPdfExportieren(_FavoritEintrag eintrag) async {
      await favoritPdfService.exportieren(
        datum: eintrag.datum,
        text: eintrag.text,
      );
    }
    Future<void> favoritCloudUpload(_FavoritEintrag eintrag,) async {
    try {
      await favoritenCloudService.favoritHochladen(
        datum: eintrag.datum,
        text: eintrag.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Favorit in Cloud gespeichert.',
          ),
        ),
      );
    } catch (fehler) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $fehler'),
        ),
      );
    }
  }
    Future<void> favoritenCloudDownload() async {
    try {
      final cloudFavoriten =
          await favoritenCloudService.favoritenHerunterladen();

      for (final favorit in cloudFavoriten) {
        final datum = favorit['datum'] ?? '';
        final text = favorit['text'] ?? '';

        if (datum.toString().isEmpty || text.toString().isEmpty) continue;

        await favoritService.favoritSpeichern(
          datum: datum,
          istFavorit: true,
        );

        await speicherService.speichern(
          datum: datum,
          text: text,
        );
      }

      await favoritenLaden();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favoriten aus Cloud geladen.'),
        ),
      );
    } catch (fehler) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $fehler'),
        ),
      );
    }
  }
   
  @override
  Widget build(BuildContext context) {
    final gefilterteFavoriten = favoriten.where((favorit) {
    final suche = suchText.toLowerCase();

    return favorit.datum.toLowerCase().contains(suche) ||
        favorit.text.toLowerCase().contains(suche);
  }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriten'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Favoriten aus Cloud laden',
            icon: const Icon(Icons.cloud_download),
            onPressed: favoritenCloudDownload,
          ),
        ],
      ),
       body: wirdGeladen
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: AppStyle.standardPadding,
                child: TextField(
                  controller: suchController,
                  decoration: const InputDecoration(
                    labelText: 'Favoriten suchen',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (wert) {
                    setState(() {
                      suchText = wert;
                    });
                  },
                ),
              ),

              Expanded(
                child: gefilterteFavoriten.isEmpty
                    ? const Center(
                        child: Text('Keine passenden Favoriten gefunden.'),
                      )
                    : ListView.builder(
                        padding: AppStyle.standardPadding,
                        itemCount: gefilterteFavoriten.length,
                        itemBuilder: (context, index) {
                          final favorit = gefilterteFavoriten[index];

                          return Card(
                            child: Padding(
                              padding: AppStyle.standardPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          favorit.datum,
                                          style: AppStyle.titelMittel,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Favorit entfernen',
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => favoritEntfernen(favorit),
                                      ),
                                      IconButton(
                                        tooltip: 'Favorit kopieren',
                                        icon: const Icon(Icons.copy),
                                        onPressed: () => favoritKopieren(favorit),
                                      ),
                                      IconButton(
                                        tooltip: 'Favorit als PDF',
                                        icon: const Icon(Icons.picture_as_pdf),
                                        onPressed: () => favoritAlsPdfExportieren(favorit),
                                      ),
                                      IconButton(
                                        tooltip: 'In Cloud speichern',
                                        icon: const Icon(Icons.cloud_upload),
                                        onPressed: () => favoritCloudUpload(favorit),
                                      ),
                                    ],
                                  ),
                                  AppStyle.abstandKlein,
                                  Text(favorit.text),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FavoritEintrag {
  final String datum;
  final String text;

  _FavoritEintrag({
    required this.datum,
    required this.text,
  });
}