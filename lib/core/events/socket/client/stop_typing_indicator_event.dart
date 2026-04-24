class StopTypingIndicatorEvent {
  static const String name = 'SOCKET_STOP_TYPING';

  final String chatRoomId;

  StopTypingIndicatorEvent({required this.chatRoomId});

  Map<String, dynamic> toJson() => {'chatRoomID': chatRoomId};
}

