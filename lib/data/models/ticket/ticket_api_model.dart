import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

/// Maps the API Ticket JSON response to the domain [Ticket] entity.
///
/// API schema (from GET /api/ticket/{ticketID}):
///   id, title, status, priority, assigneeId, customerId,
///   chatRoomId, channelType, createdAt, updatedAt
///
/// Fields missing from the API are filled with safe defaults so that the
/// existing UI (which expects the full entity) continues to work.
class TicketApiModel {
  final String id;
  final String title;
  final String status;
  final String priority;
  final String? assigneeId;
  final String customerId;
  final String? chatRoomId;
  final String? channelType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TicketApiModel({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.customerId,
    this.chatRoomId,
    this.channelType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketApiModel.fromJson(Map<String, dynamic> json) {
    return TicketApiModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      priority: json['priority'] as String? ?? 'medium',
      assigneeId: json['assigneeId'] as String?,
      customerId: json['customerId'] as String? ?? '',
      chatRoomId: json['chatRoomId'] as String?,
      channelType: json['channelType'] as String?,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Ticket toDomain() {
    return Ticket(
      id: id,
      title: title,
      description: '',
      status: _mapStatus(status),
      priority: _mapPriority(priority),
      category: TicketCategory.general,
      source: _mapChannelType(channelType),
      customerId: customerId,
      customerName: '',
      customerEmail: '',
      createdByID: '',
      createdByName: '',
      assignedAgentId: assigneeId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // ── Mapping helpers ────────────────────────────────────────────────────────

  static TicketStatus _mapStatus(String raw) {
    switch (raw) {
      case 'open':
        return TicketStatus.open;
      case 'pending':
        return TicketStatus.pending;
      case 'solved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.open;
    }
  }

  static TicketPriority _mapPriority(String raw) {
    switch (raw) {
      case 'low':
        return TicketPriority.low;
      case 'medium':
        return TicketPriority.medium;
      case 'high':
        return TicketPriority.high;
      case 'urgent':
        return TicketPriority.urgent;
      default:
        return TicketPriority.medium;
    }
  }

  static TicketSource _mapChannelType(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'messenger':
        return TicketSource.messenger;
      case 'zalo':
        return TicketSource.zalo;
      case 'email':
        return TicketSource.email;
      case 'phone':
        return TicketSource.phone;
      default:
        return TicketSource.web;
    }
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }
}
