import 'package:flutter/material.dart';
import '../daten/lokaler_speicher.dart';
import '../modelle/tages_eintrag.dart';

/// Startseite der App.
/// Hier sieht der Nutzer seine aktuellen Tagesdaten
/// und kann diese bearbeiten.
class StartSeite extends StatefulWidget {
  const StartSeite({super.key});

  @override
  State<StartSeite> createState() => _StartSeiteStatus();
}

class _StartSeiteStatus extends State<StartSeite> {
  final LokalerSpeicher lokalerSpeicher = LokalerSpeicher();
  final TextEditingController eingabeController = TextEditingController();

  TagesEintrag eintrag = TagesEintrag.heute();
  bool wirdGeladen = true;

  @override
  void initState() {
    super.initState();
    datenLaden();
  }

  /// Lädt gespeicherte Daten beim Start der App.
  Future<void> datenLaden() async {
    final geladenerEintrag = await lokalerSpeicher.tagesEintragLaden();

    setState(() {
      eintrag = geladenerEintrag;
      wirdGeladen = false;
    });
  }

  /// Speichert aktuelle Daten lokal.
  Future<void> datenSpeichern() async {
    await lokalerSpeicher.tagesEintragSpeichern(eintrag);
  }

  /// Fügt eine neue Mahlzeit hinzu.
  Future<void> mahlzeitHinzufuegen() async {
    if (eingabeController.text.trim().isEmpty) return;

    setState(() {
      eintrag.mahlzeiten.add(eingabeController.text.trim());
      eingabeController.clear();
    });

    await datenSpeichern();
  }

  /// Löscht eine Mahlzeit anhand des Index.
  Future<void> mahlzeitLoeschen(int index) async {
    setState(() {
      eintrag.mahlzeiten.removeAt(index);
    });

    await datenSpeichern();
  }

  /// Setzt alle Tageswerte zurück.
  Future<void> tagZuruecksetzen() async {
    setState(() {
      eintrag = TagesEintrag.heute();
    });

    await datenSpeichern();
  }

  /// Gewicht erhöhen
  Future<void> gewichtErhoehen() async {
    setState(() {
      eintrag.gewicht += 0.1;
    });

    await datenSpeichern();
  }

  /// Gewicht verringern
  Future<void> gewichtVerringern() async {
    setState(() {
      eintrag.gewicht -= 0.1;
    });

    await datenSpeichern();
  }

  /// Wasser erhöhen
  Future<void> wasserErhoehen() async {
    setState(() {
      eintrag.wasser++;
    });

    await datenSpeichern();
  }

  /// Schritte erhöhen
  Future<void> schritteErhoehen() async {
    setState(() {
      eintrag.schritte += 500;
    });

    await datenSpeichern();
  }

  @override
  Widget build(BuildContext context) {
    if (wirdGeladen) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Coach'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: tagZuruecksetzen,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Heute',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Gewicht
          Card(
            child: ListTile(
              title: const Text('Gewicht'),
              subtitle: Text('${eintrag.gewicht.toStringAsFixed(1)} kg'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: gewichtVerringern,
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: gewichtErhoehen,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),

          // Wasser
          Card(
            child: ListTile(
              title: const Text('Wasser'),
              subtitle: Text('${eintrag.wasser} Gläser'),
              trailing: IconButton(
                onPressed: wasserErhoehen,
                icon: const Icon(Icons.add),
              ),
            ),
          ),

          // Schritte
          Card(
            child: ListTile(
              title: const Text('Schritte'),
              subtitle: Text('${eintrag.schritte} Schritte'),
              trailing: IconButton(
                onPressed: schritteErhoehen,
                icon: const Icon(Icons.directions_walk),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Mahlzeiten',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: eingabeController,
                  decoration: const InputDecoration(
                    hintText: 'z.B. Haferflocken mit Banane',
                  ),
                ),
              ),
              IconButton(
                onPressed: mahlzeitHinzufuegen,
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Liste mit Löschen-Button
          for (int i = 0; i < eintrag.mahlzeiten.length; i++)
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant),
                title: Text(eintrag.mahlzeiten[i]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => mahlzeitLoeschen(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}