import 'package:flutter/material.dart';

void main() {
  runApp(const MeineApp());
}

class MeineApp extends StatelessWidget {
  const MeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mein Coach',
      home: const StartSeite(),
    );
  }
}

class StartSeite extends StatefulWidget {
  const StartSeite({super.key});

  @override
  State<StartSeite> createState() => _StartSeiteState();
}

class _StartSeiteState extends State<StartSeite> {
  int wasser = 0;
  int schritte = 0;
  double gewicht = 80.0;

  List<String> mahlzeiten = [];
  final TextEditingController eingabeController = TextEditingController();

  void mahlzeitHinzufuegen() {
    if (eingabeController.text.isEmpty) return;

    setState(() {
      mahlzeiten.add(eingabeController.text);
      eingabeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mein Coach")),
      body: Column(
        children: [
          Text("Gewicht: $gewicht kg"),
          ElevatedButton(
            onPressed: () => setState(() => gewicht += 0.1),
            child: const Text("Gewicht +"),
          ),

          TextField(controller: eingabeController),

          ElevatedButton(
            onPressed: mahlzeitHinzufuegen,
            child: const Text("Mahlzeit hinzufügen"),
          ),

          for (var m in mahlzeiten) Text(m),
        ],
      ),
    );
  }
}