class SocketNewTicketCreatedEvent {
  static const String name = 'SOCKET_NEW_TICKET';

  final String ticketId;
  final String chatRoomId;
  final String customerId;
  final String title;
  final String status;

  SocketNewTicketCreatedEvent({
    required this.ticketId,
    required this.chatRoomId,
    required this.customerId,
    required this.title,
    required this.status,
  });

  static SocketNewTicketCreatedEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final ticketId = (m['ticketID'] ?? '').toString();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    final customerId = (m['customerID'] ?? '').toString();
    if (ticketId.isEmpty || chatRoomId.isEmpty || customerId.isEmpty) return null;
    return SocketNewTicketCreatedEvent(
      ticketId: ticketId,
      chatRoomId: chatRoomId,
      customerId: customerId,
      title: (m['title'] ?? '').toString(),
      status: (m['status'] ?? '').toString(),
    );
  }
}

