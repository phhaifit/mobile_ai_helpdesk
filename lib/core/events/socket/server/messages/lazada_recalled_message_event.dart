class LazadaRecalledMessageEvent {
  static const String name = 'SOCKET_LAZADA_RECALLED_MESSAGE';

  final String messageId;
  final String chatRoomId;

  LazadaRecalledMessageEvent({required this.messageId, required this.chatRoomId});

  static LazadaRecalledMessageEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final messageId = (m['messageID'] ?? '').toString();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    if (messageId.isEmpty || chatRoomId.isEmpty) return null;
    return LazadaRecalledMessageEvent(messageId: messageId, chatRoomId: chatRoomId);
  }
}

