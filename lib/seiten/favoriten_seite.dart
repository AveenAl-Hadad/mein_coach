import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/historie_provider.dart';
import '../services/favorit_service.dart';
import '../services/gemini_vorschlag_speicher_service.dart';
import '../style/app_style.dart';

class FavoritenSeite extends StatefulWidget {
  const FavoritenSeite({super.key});

  @override
  State<FavoritenSeite> createState() => _FavoritenSeiteState();
}

class _FavoritenSeiteState extends State<FavoritenSeite> {
  final FavoritService favoritService = FavoritService();
  final GeminiVorschlagSpeicherService speicherService =
      GeminiVorschlagSpeicherService();

  final List<_FavoritEintrag> favoriten = [];
  final TextEditingController suchController = TextEditingController();
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

      if (!mounted) return;

      setState(() {
        favoriten.remove(eintrag);
      });
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