import 'package:flutter/material.dart';

import '../services/gemini_service.dart';

class KiCoachSeite extends StatefulWidget {
  const KiCoachSeite({super.key});

  @override
  State<KiCoachSeite> createState() => _KiCoachSeiteState();
}

class _KiCoachSeiteState extends State<KiCoachSeite> {
  final TextEditingController controller =
      TextEditingController();

  final GeminiService geminiService = GeminiService();

  final List<_ChatNachricht> nachrichten = [];

  bool wirdGeladen = false;

  Future<void> senden() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      nachrichten.add(
        _ChatNachricht(
          text: text,
          istNutzer: true,
        ),
      );

      wirdGeladen = true;
    });

    controller.clear();

    try {
      final antwort =
          await geminiService.nachrichtSenden(text);

      setState(() {
        nachrichten.add(
          _ChatNachricht(
            text: antwort,
            istNutzer: false,
          ),
        );
      });
    } catch (fehler) {
      setState(() {
        nachrichten.add(
          _ChatNachricht(
            text: 'Fehler: $fehler',
            istNutzer: false,
          ),
        );
      });
    }

    setState(() {
      wirdGeladen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KI Coach'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: nachrichten.length,
              itemBuilder: (context, index) {
                final nachricht = nachrichten[index];

                return Align(
                  alignment: nachricht.istNutzer
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                    ),
                    decoration: BoxDecoration(
                      color: nachricht.istNutzer
                          ? Colors.green
                          : Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Text(
                      nachricht.text,
                      style: TextStyle(
                        color: nachricht.istNutzer
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (wirdGeladen)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Frage deinen KI Coach...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: senden,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatNachricht {
  final String text;
  final bool istNutzer;

  _ChatNachricht({
    required this.text,
    required this.istNutzer,
  });
}