enum TicketStatus {
  unassigned,
  open,
  solved,
  pending,
  aiServing,
  closed
}

enum TicketPriority {
  low,
  medium,
  high,
}

class Ticket {
  final String id;
  final TicketStatus status;
  final TicketPriority priority;
  final String title;
  final String? description;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });
}