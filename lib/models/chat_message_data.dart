class ChatMessageData {
  final String content;
  DateTime createdAt;
  final bool isMe;
  bool isLoading;
  bool hasError;

  ChatMessageData({
    required this.content,
    required this.createdAt,
    required this.isMe,
    this.isLoading = false,
    this.hasError = false,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      content: json['content'] ?? "",
      createdAt:
          DateTime.parse(json['created_at']).add(const Duration(hours: 7)),
      isMe: json['is_me'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_me': isMe,
    };
  }

  ChatMessageData copyWith({
    String? content,
    DateTime? createdAt,
    bool? isMe,
    bool? isLoading,
  }) {
    return ChatMessageData(
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isMe: isMe ?? this.isMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ChatMessageData.dummy() {
    return ChatMessageData(
      content: "Hello, how are you?",
      createdAt: DateTime.now(),
      isMe: true,
    );
  }

  factory ChatMessageData.dummyReceived() {
    return ChatMessageData(
      content: "Hello, I'm fine",
      createdAt: DateTime.now(),
      isMe: false,
    );
  }
}
