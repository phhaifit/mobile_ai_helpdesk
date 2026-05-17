class StopTypingIndicatorEvent {
  static const String name = 'SOCKET_STOP_TYPING';

  final String chatRoomId;
  final String? customerSupportId;

  StopTypingIndicatorEvent({
    required this.chatRoomId,
    this.customerSupportId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'chatRoomID': chatRoomId,
        if (customerSupportId != null && customerSupportId!.isNotEmpty)
          'customerSupportID': customerSupportId,
      };
}
