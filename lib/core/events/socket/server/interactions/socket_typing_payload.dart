class SocketTypingPayload {
  static const String nameTyping = 'SOCKET_TYPING';
  static const String nameStopTyping = 'SOCKET_STOP_TYPING';

  final String chatRoomId;

  SocketTypingPayload({required this.chatRoomId});

  factory SocketTypingPayload.fromJson(Map<String, dynamic> json) {
    return SocketTypingPayload(chatRoomId: (json['chatRoomID'] ?? '').toString());
  }
}

