import '../enums.dart';

class Ticket {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketSource source;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String? assignedAgentId;
  final String? assignedAgentName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final String? notes;
  final List<String> attachments;
  final int unreadCount;

  const Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.source,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    this.assignedAgentId,
    this.assignedAgentName,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.notes,
    this.attachments = const [],
    this.unreadCount = 0,
  });

  Ticket copyWith({
    String? id,
    String? title,
    String? description,
    TicketStatus? status,
    TicketPriority? priority,
    TicketCategory? category,
    TicketSource? source,
    String? customerId,
    String? customerName,
    String? customerEmail,
    String? assignedAgentId,
    String? assignedAgentName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? notes,
    List<String>? attachments,
    int? unreadCount,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      source: source ?? this.source,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      assignedAgentName: assignedAgentName ?? this.assignedAgentName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  String toString() =>
      'Ticket(id: $id, title: $title, status: ${status.displayName}, priority: ${priority.displayName})';
}
