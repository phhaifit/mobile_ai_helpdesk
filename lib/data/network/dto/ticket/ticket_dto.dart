import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_dto.g.dart';

@JsonSerializable()
class TicketDto {
  final String? id;

  @JsonKey(name: 'ticketID')
  final String? ticketID;

  final String? title;
  final String? description;

  /// Backend status value (string/number depending on BE).
  final Object? status;

  /// Backend priority value (string/number depending on BE).
  final Object? priority;

  /// Backend category value (string/number depending on BE).
  final Object? category;

  /// Backend channel type (e.g. messenger/zalo/webchat/email/...).
  @JsonKey(name: 'channelType')
  final String? channelType;

  @JsonKey(name: 'createdByID')
  final String? createdByID;

  @JsonKey(name: 'createdByName')
  final String? createdByName;

  @JsonKey(name: 'customerID')
  final String? customerID;

  final String? customerId;
  final String? customerName;
  final String? customerEmail;

  final String? assignedAgentId;
  final String? assignedAgentName;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? resolvedAt;

  final String? notes;

  @JsonKey(defaultValue: [])
  final List<dynamic> attachments;

  final int? unreadCount;

  /// Optional linkage to a chat room.
  final String? chatRoomId;

  const TicketDto({
    this.id,
    this.ticketID,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.category,
    this.channelType,
    this.createdByID,
    this.createdByName,
    this.customerID,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.assignedAgentId,
    this.assignedAgentName,
    this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.notes,
    this.attachments = const [],
    this.unreadCount,
    this.chatRoomId,
  });

  factory TicketDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDtoToJson(this);

  Ticket toEntity() {
    final now = DateTime.now();

    return Ticket(
      id: id ?? ticketID ?? '',
      title: title ?? '',
      description: description ?? '',
      status: _parseStatus(status),
      priority: _parsePriority(priority),
      category: _parseCategory(category),
      source: _parseSource(channelType),
      customerId: customerId ?? customerID ?? '',
      customerName: customerName ?? '',
      customerEmail: customerEmail ?? '',
      createdByID: createdByID ?? '',
      createdByName: createdByName ?? '',
      chatRoomId: chatRoomId,
      assignedAgentId: assignedAgentId,
      assignedAgentName: assignedAgentName,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? createdAt ?? now,
      resolvedAt: resolvedAt,
      notes: notes,
      attachments: _parseAttachments(attachments),
      unreadCount: unreadCount ?? 0,
    );
  }

  static TicketStatus _parseStatus(Object? raw) {
    final normalized = raw?.toString().trim().toLowerCase();
    switch (normalized) {
      case 'open':
        return TicketStatus.open;
      case 'in_progress':
      case 'inprogress':
      case 'processing':
        return TicketStatus.inProgress;
      case 'pending':
        return TicketStatus.pending;
      case 'processing_by_ai':
      case 'processingbyai':
      case 'ai':
      case 'ai_processing':
      case 'processing_ai':
        return TicketStatus.processingByAI;
      case 'solved':
      case 'resolved':
        return TicketStatus.resolved;
      case 'closed':
        return TicketStatus.closed;
      default:
        return TicketStatus.open;
    }
  }

  static TicketPriority _parsePriority(Object? raw) {
    if (raw is num) {
      final n = raw.toInt();
      switch (n) {
        case 1:
          return TicketPriority.low;
        case 2:
          return TicketPriority.medium;
        case 3:
          return TicketPriority.high;
        case 4:
          return TicketPriority.urgent;
      }
    }

    final normalized = raw?.toString().trim().toLowerCase();
    switch (normalized) {
      case 'low':
        return TicketPriority.low;
      case 'medium':
      case 'normal':
        return TicketPriority.medium;
      case 'high':
        return TicketPriority.high;
      case 'urgent':
      case 'critical':
        return TicketPriority.urgent;
      default:
        return TicketPriority.medium;
    }
  }

  static TicketCategory _parseCategory(Object? raw) {
    final normalized = raw?.toString().trim().toLowerCase();
    switch (normalized) {
      case 'technical':
      case 'tech':
        return TicketCategory.technical;
      case 'billing':
      case 'payment':
        return TicketCategory.billing;
      case 'general':
        return TicketCategory.general;
      case 'account':
        return TicketCategory.account;
      case 'other':
        return TicketCategory.other;
      default:
        return TicketCategory.other;
    }
  }

  static TicketSource _parseSource(String? channelType) {
    final normalized = (channelType ?? '').trim().toLowerCase();
    switch (normalized) {
      case 'messenger':
        return TicketSource.messenger;
      case 'zalo':
      case 'zalo_personal':
      case 'zalo_oa':
        return TicketSource.zalo;
      case 'email':
        return TicketSource.email;
      case 'phone':
        return TicketSource.phone;
      case 'web':
      case 'webchat':
      case 'website':
        return TicketSource.web;
      default:
        return TicketSource.web;
    }
  }

  static List<String> _parseAttachments(List<dynamic> raw) {
    final result = <String>[];
    for (final item in raw) {
      if (item == null) continue;
      if (item is String) {
        result.add(item);
        continue;
      }
      if (item is Map) {
        final url = item['url']?.toString();
        final name = item['name']?.toString();
        if (url != null && url.isNotEmpty) {
          result.add(url);
        } else if (name != null && name.isNotEmpty) {
          result.add(name);
        }
      }
    }
    return result;
  }

  static DateTime? _dateTimeFromJson(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input;
    if (input is num) {
      return DateTime.fromMillisecondsSinceEpoch(input.toInt());
    }

    final raw = input.toString().trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static dynamic _dateTimeToJson(DateTime? dateTime) =>
      dateTime?.toIso8601String();
}
