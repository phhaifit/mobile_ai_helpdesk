import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

/// Maps the helpdesk BE ticket JSON to the domain [Ticket] entity.
///
/// Real BE payload (from `/ticket/all`, `/ticket/my-ticket`, etc.) uses
/// camelCase IDs with capital suffix and nested objects:
///   ticketID, title, body, status, priority, source,
///   customerID, customerSupportID, chatRoomID,
///   customer: { name, contactInfo: [...] },
///   author / customerSupport: { fullname, ... },
///   createdAt, updatedAt
///
/// We tolerate both the BE shape and the legacy spec shape (id, customerId,
/// assigneeId, chatRoomId, channelType) so older fixtures + mock paths still
/// parse cleanly.
class TicketApiModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String? assigneeId;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String? chatRoomId;
  final String? source;
  final String? customerSupportName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TicketApiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.createdAt,
    required this.updatedAt,
    this.assigneeId,
    this.chatRoomId,
    this.source,
    this.customerSupportName,
  });

  factory TicketApiModel.fromJson(Map<String, dynamic> json) {
    // Customer name: BE detail-response promotes it to a top-level
    // `customerName`; list-response keeps it nested under `customer.name`.
    String customerName = (json['customerName'] as String?) ?? '';
    String customerEmail = '';

    final customer = json['customer'];
    if (customer is Map) {
      if (customerName.isEmpty) {
        customerName = (customer['name'] as String?) ?? '';
      }
      final nestedContacts = customer['contactInfo'];
      if (nestedContacts is List) {
        for (final c in nestedContacts) {
          if (c is Map &&
              (c['name'] as String?)?.toUpperCase() == 'EMAIL') {
            customerEmail = (c['email'] as String?) ?? '';
            break;
          }
        }
      }
    }

    // Detail-response also exposes a top-level `contacts` array. Pick the
    // first entry that has an `email` field.
    if (customerEmail.isEmpty) {
      final contacts = json['contacts'];
      if (contacts is List) {
        for (final c in contacts) {
          if (c is Map && c['email'] is String) {
            final value = c['email'] as String;
            if (value.isNotEmpty) {
              customerEmail = value;
              break;
            }
          }
        }
      }
    }

    // Assigned-agent name. The detail endpoint uses `CustomerSupport`
    // (capital C); list/comment endpoints use `customerSupport`.
    String? customerSupportName;
    final cs = json['CustomerSupport'] ?? json['customerSupport'];
    if (cs is Map) {
      customerSupportName = cs['fullname'] as String?;
    }

    return TicketApiModel(
      id: (json['ticketID'] ?? json['id']) as String? ?? '',
      title: json['title'] as String? ?? '',
      description: (json['body'] ?? json['description']) as String? ?? '',
      status: json['status'] as String? ?? 'open',
      priority: json['priority'] as String? ?? 'medium',
      assigneeId:
          (json['customerSupportID'] ?? json['assigneeId']) as String?,
      customerId: (json['customerID'] ?? json['customerId']) as String? ?? '',
      customerName: customerName,
      customerEmail: customerEmail,
      chatRoomId: (json['chatRoomID'] ?? json['chatRoomId']) as String?,
      source: (json['source'] ?? json['channelType']) as String?,
      customerSupportName: customerSupportName,
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Ticket toDomain() {
    return Ticket(
      id: id,
      title: title,
      description: description,
      status: _mapStatus(status),
      priority: _mapPriority(priority),
      category: TicketCategory.general,
      source: _mapSource(source),
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      createdByID: '',
      createdByName: '',
      assignedAgentId: assigneeId,
      assignedAgentName: customerSupportName,
      chatRoomId: chatRoomId,
      customerSupportName: customerSupportName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // ── Mapping helpers ────────────────────────────────────────────────────────

  static TicketStatus _mapStatus(String raw) {
    switch (raw.toLowerCase()) {
      case 'open':
        return TicketStatus.open;
      case 'in_progress':
      case 'in-progress':
        return TicketStatus.inProgress;
      case 'pending':
        return TicketStatus.pending;
      case 'solved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      case 'processing_by_ai':
      case 'processing-by-ai':
        return TicketStatus.processingByAI;
      default:
        return TicketStatus.open;
    }
  }

  static TicketPriority _mapPriority(String raw) {
    switch (raw.toLowerCase()) {
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

  static TicketSource _mapSource(String? raw) {
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
      case 'webchat':
      case 'web':
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
