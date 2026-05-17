class SocketTicketStatusChangedEvent {
  static const String name = 'SOCKET_CHANGE_TICKET_STATUS';

  final String ticketId;
  final String status;
  final String chatRoomId;

  SocketTicketStatusChangedEvent({
    required this.ticketId,
    required this.status,
    required this.chatRoomId,
  });

  static SocketTicketStatusChangedEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final ticketId = (m['ticketID'] ?? '').toString();
    final status = (m['status'] ?? '').toString();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    if (ticketId.isEmpty || status.isEmpty || chatRoomId.isEmpty) return null;
    return SocketTicketStatusChangedEvent(
      ticketId: ticketId,
      status: status,
      chatRoomId: chatRoomId,
    );
  }
}

