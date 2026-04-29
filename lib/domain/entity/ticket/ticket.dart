import '../enums.dart';

class _TicketFieldUnset {
  const _TicketFieldUnset();
}

const _ticketFieldUnset = _TicketFieldUnset();

enum TicketPendingAction { create, update, delete }

class Ticket {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final TicketCategory category;
  final TicketSource source;
  final String createdByID;
  final String createdByName;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String? assignedAgentId;
  final String? assignedAgentName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final String? chatRoomId;
  final String? notes;
  final List<String> attachments;
  final int unreadCount;
  final String? localId;
  final bool isSynced;
  final TicketPendingAction? pendingAction;
  final DateTime? lastModifiedAt;

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
    required this.createdByID,
    required this.createdByName,
    this.assignedAgentId,
    this.assignedAgentName,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.chatRoomId,
    this.notes,
    this.attachments = const [],
    this.unreadCount = 0,
    this.localId,
    this.isSynced = true,
    this.pendingAction,
    this.lastModifiedAt,
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
    String? createdByID,
    String? createdByName,
    Object? assignedAgentId = _ticketFieldUnset,
    Object? assignedAgentName = _ticketFieldUnset,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? chatRoomId,
    String? notes,
    List<String>? attachments,
    int? unreadCount,
    String? localId,
    bool? isSynced,
    TicketPendingAction? pendingAction,
    DateTime? lastModifiedAt,
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
      createdByID: createdByID ?? this.createdByID,
      createdByName: createdByName ?? this.createdByName,
      assignedAgentId: identical(assignedAgentId, _ticketFieldUnset)
          ? this.assignedAgentId
          : assignedAgentId as String?,
      assignedAgentName: identical(assignedAgentName, _ticketFieldUnset)
          ? this.assignedAgentName
          : assignedAgentName as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      unreadCount: unreadCount ?? this.unreadCount,
      localId: localId ?? this.localId,
      isSynced: isSynced ?? this.isSynced,
      pendingAction: pendingAction ?? this.pendingAction,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }

  @override
  String toString() =>
      'Ticket(id: $id, title: $title, status: ${status.displayName}, priority: ${priority.displayName})';
}
