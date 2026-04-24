class SendTypingIndicatorEvent {
  static const String name = 'SOCKET_TYPING';

  final String chatRoomId;

  SendTypingIndicatorEvent({required this.chatRoomId});

  Map<String, dynamic> toJson() => {'chatRoomID': chatRoomId};
}

