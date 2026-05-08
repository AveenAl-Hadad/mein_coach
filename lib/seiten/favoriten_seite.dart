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

  bool wirdGeladen = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriten'),
        centerTitle: true,
      ),
      body: wirdGeladen
          ? const Center(child: CircularProgressIndicator())
          : favoriten.isEmpty
              ? const Center(
                  child: Text('Noch keine Favoriten gespeichert.'),
                )
              : ListView.builder(
                  padding: AppStyle.standardPadding,
                  itemCount: favoriten.length,
                  itemBuilder: (context, index) {
                    final favorit = favoriten[index];

                    return Card(
                      child: Padding(
                        padding: AppStyle.standardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favorit.datum,
                              style: AppStyle.titelMittel,
                            ),
                            AppStyle.abstandKlein,
                            Text(favorit.text),
                          ],
                        ),
                      ),
                    );
                  },
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