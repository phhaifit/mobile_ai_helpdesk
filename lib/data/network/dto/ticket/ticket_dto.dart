import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

/// DTO for the ticket schema returned by the backend.
///
/// The BE schema is intentionally narrower than the mobile [Ticket] entity:
/// fields the BE does not return (description, category, customer name/email,
/// notes, attachments, ...) are populated with sensible defaults by
/// [toEntity]. Callers (e.g. customer detail) can override `customerName`
/// and `customerEmail` from their own context.
class TicketDto {
  final String? id;
  final String? title;
  final String? status;
  final String? priority;
  final String? assigneeId;
  final String? customerId;
  final String? chatRoomId;
  final String? channelType;
  final String? customerSupportName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TicketDto({
    this.id,
    this.title,
    this.status,
    this.priority,
    this.assigneeId,
    this.customerId,
    this.chatRoomId,
    this.channelType,
    this.customerSupportName,
    this.createdAt,
    this.updatedAt,
  });

  factory TicketDto.fromJson(Map<String, dynamic> json) {
    return TicketDto(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      status: json['status']?.toString(),
      priority: json['priority']?.toString(),
      assigneeId: json['assigneeId']?.toString(),
      customerId: json['customerId']?.toString(),
      chatRoomId: json['chatRoomId']?.toString(),
      channelType: json['channelType']?.toString(),
      customerSupportName: json['customerSupportName']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  /// Builds a domain [Ticket]. Fields not provided by the BE fall back to
  /// safe defaults; pass [customerName] / [customerEmail] when known from
  /// surrounding context (e.g. the customer detail screen).
  Ticket toEntity({String customerName = '', String customerEmail = ''}) {
    final now = DateTime.now();
    return Ticket(
      id: id ?? '',
      title: title ?? '',
      description: '',
      status: _parseStatus(status),
      priority: _parsePriority(priority),
      category: TicketCategory.general,
      source: _parseSource(channelType),
      customerId: customerId ?? '',
      customerName: customerName,
      customerEmail: customerEmail,
      createdByID: '',
      createdByName: '',
      chatRoomId: chatRoomId,
      assignedAgentId: assigneeId,
      assignedAgentName: null,
      customerSupportName: customerSupportName,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? createdAt ?? now,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}

TicketStatus _parseStatus(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'open':
      return TicketStatus.open;
    case 'pending':
      return TicketStatus.pending;
    case 'solved':
    case 'resolved':
      return TicketStatus.resolved;
    case 'closed':
      return TicketStatus.closed;
    default:
      return TicketStatus.open;
  }
}

TicketPriority _parsePriority(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'urgent':
      return TicketPriority.urgent;
    case 'high':
      return TicketPriority.high;
    case 'low':
      return TicketPriority.low;
    case 'medium':
    default:
      return TicketPriority.medium;
  }
}

TicketSource _parseSource(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'messenger':
    case 'facebook':
      return TicketSource.messenger;
    case 'zalo':
    case 'zalo_personal':
      return TicketSource.zalo;
    case 'email':
      return TicketSource.email;
    case 'phone':
      return TicketSource.phone;
    case 'web':
    case 'webchat':
    default:
      return TicketSource.web;
  }
}
