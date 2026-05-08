class ChatNachricht {
  final String text;
  final bool istNutzer;
  final String zeit;

  ChatNachricht({
    required this.text,
    required this.istNutzer,
    required this.zeit,
  });

  Map<String, dynamic> zuMap() {
    return {
      'text': text,
      'istNutzer': istNutzer,
      'zeit': zeit,
    };
  }

  factory ChatNachricht.vonMap(Map<String, dynamic> map) {
    return ChatNachricht(
      text: map['text'] ?? '',
      istNutzer: map['istNutzer'] ?? false,
      zeit: map['zeit'] ?? '',
    );
  }
}