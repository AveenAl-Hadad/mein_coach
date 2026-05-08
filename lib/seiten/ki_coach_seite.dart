import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../modelle/chat_nachricht.dart';
import '../services/chat_speicher_service.dart';

class KiCoachSeite extends StatefulWidget {
  const KiCoachSeite({super.key});

  @override
  State<KiCoachSeite> createState() => _KiCoachSeiteState();
}

class _KiCoachSeiteState extends State<KiCoachSeite> {
  final TextEditingController controller = TextEditingController();
  final GeminiService geminiService = GeminiService();
  final List<ChatNachricht> nachrichten = [];
  final ChatSpeicherService chatSpeicherService = ChatSpeicherService();

  @override
  void initState() {
    super.initState();
    chatLaden();
  }

  Future<void> chatLaden() async {
    final geladeneNachrichten = await chatSpeicherService.chatLaden();

    if (!mounted) return;

    setState(() {
      nachrichten.clear();

      if (geladeneNachrichten.isEmpty) {
        nachrichten.add(
          ChatNachricht(
            text:
                'Hallo 👋 Ich bin dein KI Coach. Frag mich z.B.: Was kann ich heute besser machen?',
            istNutzer: false,
            zeit: DateTime.now().toIso8601String(),
          ),
        );
      } else {
        nachrichten.addAll(geladeneNachrichten);
      }
    });
  }
  bool wirdGeladen = false;

  Future<void> senden() async {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      nachrichten.add(
        ChatNachricht(
          text: text,
          istNutzer: true,
          zeit: DateTime.now().toIso8601String(),
        ),
      );
      wirdGeladen = true;
   });
   await chatSpeicherService.chatSpeichern(nachrichten);
    controller.clear();

    try {
      final antwort =
          await geminiService.nachrichtSenden(text);

      setState(() {
        nachrichten.add(
          ChatNachricht(
            text: antwort,
            istNutzer: false,
            zeit: DateTime.now().toIso8601String(),
          ),
        );
      });
      await chatSpeicherService.chatSpeichern(nachrichten);
    } catch (fehler) {
      setState(() {
        nachrichten.add(
          ChatNachricht(
            text: 'Fehler: $fehler',
            istNutzer: false,
            zeit: DateTime.now().toIso8601String(),
          ),
        );
      });
      await chatSpeicherService.chatSpeichern(nachrichten);
    }

    setState(() {
      wirdGeladen = false;
    });
  }
  Future<void> chatLoeschen() async {
  await chatSpeicherService.chatLoeschen();

  setState(() {
    nachrichten.clear();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KI Coach'),
        actions: [
          IconButton(
            tooltip: 'Chat löschen',
            icon: const Icon(Icons.delete),
            onPressed: chatLoeschen,
          ),
        ],
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

