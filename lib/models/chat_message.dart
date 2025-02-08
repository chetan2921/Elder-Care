class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String scenario;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.scenario,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'scenario': scenario,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      scenario: json['scenario'] as String,
    );
  }
}