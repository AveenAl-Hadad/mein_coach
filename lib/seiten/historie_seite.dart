import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/historie_provider.dart';
import '../style/app_style.dart';
import '../style/app_texte.dart';
import '../widgets/gewicht_diagramm.dart';
import 'tag_detail_seite.dart';
import '../widgets/historie_karte.dart';

/// Historie-Seite.
/// Zeigt alle gespeicherten Tage und den Gewichtsverlauf.
class HistorieSeite extends StatefulWidget {
  const HistorieSeite({super.key});

  @override
  State<HistorieSeite> createState() => _HistorieSeiteStatus();
}

class _HistorieSeiteStatus extends State<HistorieSeite> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<HistorieProvider>().tageLaden();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistorieProvider>();
    final tage = provider.tage;

    if (provider.wirdGeladen) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexte.historie),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppStyle.standardPadding,
        children: [
          const Text(
            AppTexte.gespeicherteTage,
            style: AppStyle.titelGross,
          ),

          AppStyle.abstandMittel,

          const Text(
            AppTexte.gewichtDiagrammTitel,
            style: AppStyle.titelMittel,
          ),

          AppStyle.abstandKlein,

          GewichtDiagramm(tage: tage),

          AppStyle.abstandGross,

          if (tage.isEmpty)
            const Text(AppTexte.keineTage),

          for (final tag in tage)
              HistorieKarte(
                tag: tag,
                beimTippen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagDetailSeite(tag: tag),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}