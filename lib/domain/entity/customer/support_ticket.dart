enum TicketStatus {
  pending,
  inProgress,
  resolved,
  waitingForInfo,
  aiProcessing,
}

enum TicketPriority { low, medium, high }

class SupportTicket {
  final String id;
  final String title;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;

  SupportTicket({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  SupportTicket copyWith({
    String? title,
    TicketStatus? status,
    TicketPriority? priority,
    DateTime? createdAt,
  }) {
    return SupportTicket(
      id: id,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
