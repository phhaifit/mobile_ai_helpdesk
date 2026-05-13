import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';

/// DTO matching the BE `ChatRoom` schema used by `/api/chat-room/*` and the
/// (placeholder) `/api/customer/{id}/conversations` endpoint. Only the
/// fields the customer-detail summary needs are projected through
/// [toEntity]; richer thread data is left for a follow-up.
class ChatRoomDto {
  final String? chatRoomID;
  final String? customerID;
  final int? totalMessage;
  final int? seenMessageOrder;
  final DateTime? updatedAt;
  final LastMessageDto? lastMessage;
  final List<String> linkedTicketIds;

  const ChatRoomDto({
    this.chatRoomID,
    this.customerID,
    this.totalMessage,
    this.seenMessageOrder,
    this.updatedAt,
    this.lastMessage,
    this.linkedTicketIds = const [],
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    final rawTickets = json['tickets'];
    final ticketIds = <String>[];
    if (rawTickets is List) {
      for (final t in rawTickets) {
        if (t is Map && t['ticketID'] != null) {
          ticketIds.add(t['ticketID'].toString());
        }
      }
    }

    return ChatRoomDto(
      chatRoomID: json['chatRoomID']?.toString(),
      customerID: json['customerID']?.toString(),
      totalMessage: _readInt(json['totalMessage']),
      seenMessageOrder: _readInt(json['seenMessageOrder']),
      updatedAt: _parseDate(json['updatedAt']),
      lastMessage: json['lastMessage'] is Map
          ? LastMessageDto.fromJson(
              Map<String, dynamic>.from(json['lastMessage'] as Map),
            )
          : null,
      linkedTicketIds: ticketIds,
    );
  }

  CustomerChatRoom toEntity() {
    final total = totalMessage ?? 0;
    final seen = seenMessageOrder ?? 0;
    final unread = total - seen;
    final channel = lastMessage?.channel ?? 'unknown';
    return CustomerChatRoom(
      id: chatRoomID ?? '',
      customerId: customerID ?? '',
      channel: channel,
      totalMessage: total,
      unreadCount: unread > 0 ? unread : 0,
      lastMessagePreview: lastMessage?.contentPreview,
      lastMessageAt: lastMessage?.createdAt ?? updatedAt,
      linkedTicketIds: linkedTicketIds,
    );
  }
}

class LastMessageDto {
  final String? messageID;
  final String? channel;
  final String? contentPreview;
  final DateTime? createdAt;

  const LastMessageDto({this.messageID, this.channel, this.contentPreview, this.createdAt});

  factory LastMessageDto.fromJson(Map<String, dynamic> json) {
    final contactInfo = json['contactInfo'];
    final channelName = contactInfo is Map ? contactInfo['name']?.toString() : null;

    final contentInfo = json['contentInfo'];
    String? preview;
    if (contentInfo is Map) {
      final v = contentInfo['content'] ?? contentInfo['text'] ?? contentInfo['body'];
      preview = v?.toString();
    } else if (json['content'] is String) {
      preview = json['content'] as String;
    }

    return LastMessageDto(
      messageID: json['messageID']?.toString(),
      channel: channelName,
      contentPreview: preview,
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

int? _readInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  if (raw is String) return int.tryParse(raw);
  return null;
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw;
  if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
  return null;
}
