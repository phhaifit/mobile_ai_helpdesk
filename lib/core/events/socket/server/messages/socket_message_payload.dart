class SocketMessagePayload {
  final String messageId;
  final String chatRoomId;
  final String? sender;
  final String? content;
  final String? channelId;
  final Map<String, dynamic>? contentInfo;
  final DateTime? createdAt;

  SocketMessagePayload({
    required this.messageId,
    required this.chatRoomId,
    required this.sender,
    required this.content,
    required this.channelId,
    required this.contentInfo,
    required this.createdAt,
  });

  factory SocketMessagePayload.fromJson(Map<String, dynamic> json) {
    return SocketMessagePayload(
      messageId: (json['messageID'] ?? '').toString(),
      chatRoomId: (json['chatRoomID'] ?? '').toString(),
      sender: json['sender']?.toString(),
      content: json['content']?.toString(),
      channelId: json['channelID']?.toString(),
      contentInfo: json['contentInfo'] is Map
          ? (json['contentInfo'] as Map).cast<String, dynamic>()
          : null,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  String get displayContent {
    final c = content;
    if (c != null && c.isNotEmpty) return c;
    final nested = contentInfo?['content'];
    if (nested is String) return nested;
    return '';
  }
}

