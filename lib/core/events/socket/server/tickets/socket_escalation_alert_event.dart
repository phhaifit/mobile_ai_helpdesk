class SocketEscalationAlertEvent {
  static const String name = 'SOCKET_ESCALATION_ALERT';

  final String ticketId;
  final String chatRoomId;
  final String reason;

  SocketEscalationAlertEvent({
    required this.ticketId,
    required this.chatRoomId,
    required this.reason,
  });

  static SocketEscalationAlertEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final ticketId = (m['ticketID'] ?? '').toString();
    final chatRoomId = (m['chatRoomID'] ?? '').toString();
    final reason = (m['reason'] ?? '').toString();
    if (ticketId.isEmpty || chatRoomId.isEmpty || reason.isEmpty) return null;
    return SocketEscalationAlertEvent(
      ticketId: ticketId,
      chatRoomId: chatRoomId,
      reason: reason,
    );
  }
}

