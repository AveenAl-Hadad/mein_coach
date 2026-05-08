import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../modelle/chat_nachricht.dart';
import '../services/chat_speicher_service.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/services.dart';

class KiCoachSeite extends StatefulWidget {
  const KiCoachSeite({super.key});

  @override
  State<KiCoachSeite> createState() => _KiCoachSeiteState();
}

class _KiCoachSeiteState extends State<KiCoachSeite> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GeminiService geminiService = GeminiService();
  final List<ChatNachricht> nachrichten = [];
  final ChatSpeicherService chatSpeicherService = ChatSpeicherService();
  final SpeechToText speechToText = SpeechToText();

  bool hoertZu = false; 
  bool wirdGeladen = false;  

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
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
  Future<void> spracheStarten() async {
    final verfuegbar = await speechToText.initialize();

    if (!verfuegbar) return;

    setState(() {
      hoertZu = true;
    });

    await speechToText.listen(
      onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords;
        });
      },
    );
  }

  Future<void> spracheStoppen() async {
    await speechToText.stop();

    setState(() {
      hoertZu = false;
    });
  }
  Future<void> schnellfrage(String frage) async {
    controller.text = frage;
    await senden();
  }

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
   nachUntenScrollen();
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
      nachUntenScrollen();
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
      nachUntenScrollen();
    }

    setState(() {
      wirdGeladen = false;
    });
  }
  Future<void> chatLoeschen() async {
    final bestaetigt = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chat löschen?'),
          content: const Text(
            'Möchtest du den kompletten KI-Chat wirklich löschen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Löschen'),
            ),
          ],
        );
      },
    );
    if (bestaetigt != true) return;
    await chatSpeicherService.chatLoeschen();
    setState(() {
      nachrichten.clear();
      nachrichten.add(
        ChatNachricht(
          text:
              'Hallo 👋 Ich bin dein KI Coach. Frag mich z.B.: Was kann ich heute besser machen?',
          istNutzer: false,
          zeit: DateTime.now().toIso8601String(),
        ),
      );
    });
  }
  
  void nachUntenScrollen() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String zeitFormatieren(String isoZeit) {
    final datum = DateTime.tryParse(isoZeit);

    if (datum == null) {
      return '';
    }

    final stunde = datum.hour.toString().padLeft(2, '0');
    final minute = datum.minute.toString().padLeft(2, '0');

    return '$stunde:$minute';
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
          SizedBox(
            height: 58,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              children: [
                _SchnellButton(
                  text: '💪 Motiviere mich',
                  onTap: () => schnellfrage(
                    'Motiviere mich für heute.',
                  ),
                ),

                _SchnellButton(
                  text: '🥗 Ernährung',
                  onTap: () => schnellfrage(
                    'Gib mir einen Ernährungstipp.',
                  ),
                ),

                _SchnellButton(
                  text: '🏃 Workout',
                  onTap: () => schnellfrage(
                    'Gib mir einen Workout Tipp.',
                  ),
                ),

                _SchnellButton(
                  text: '📈 Verbessern',
                  onTap: () => schnellfrage(
                    'Wie kann ich meinen Tag verbessern?',
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              controller: scrollController,
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nachricht.text,
                          style: TextStyle(
                           color: nachricht.istNutzer
                            ? Colors.white
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          zeitFormatieren(nachricht.zeit),
                          style: TextStyle(
                            fontSize: 11,
                            color: nachricht.istNutzer
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),

                        if (!nachricht.istNutzer) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              tooltip: 'Antwort kopieren',
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: nachricht.text),
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Antwort wurde kopiert.'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

         if (wirdGeladen)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 12, bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,  
                  borderRadius: BorderRadius.circular(18),
              ),
              child: const Text('KI Coach tippt gerade ...'),
            ),
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
                  
                   IconButton(
                    onPressed: hoertZu
                        ? spracheStoppen
                        : spracheStarten,
                    icon: Icon(
                      hoertZu ? Icons.mic : Icons.mic_none,
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

class _SchnellButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SchnellButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: onTap,
      ),
    );
  }
}

