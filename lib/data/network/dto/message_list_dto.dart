class MessageListDto {
  final List<MessageItemDto> messages;
  final Map<String, SenderEntityDto> senders;

  MessageListDto({
    required this.messages,
    required this.senders,
  });

  factory MessageListDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      return MessageListDto(messages: const [], senders: const {});
    }

    final dataMap = data.cast<String, dynamic>();
    final rawMessages = dataMap['messages'];
    final messages = (rawMessages is List)
        ? rawMessages
            .whereType<Map<dynamic, dynamic>>()
            .map((m) => MessageItemDto.fromJson(m.cast<String, dynamic>()))
            .toList()
        : <MessageItemDto>[];

    final entities = dataMap['entities'];
    final senders = <String, SenderEntityDto>{};
    if (entities is Map) {
      final entitiesMap = entities.cast<String, dynamic>();
      final rawSenders = entitiesMap['senders'];
      if (rawSenders is Map) {
        rawSenders.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            senders[key.toString()] =
                SenderEntityDto.fromJson(value.cast<String, dynamic>());
          }
        });
      }
    }

    return MessageListDto(messages: messages, senders: senders);
  }
}

class MessageItemDto {
  final String messageId;
  final String chatRoomId;
  final String? sender;
  final int? messageOrder;
  final DateTime? createdAt;
  final Map<String, dynamic>? contentInfo;
  final String? content;
  final List<MessageReactionDto> reactions;

  MessageItemDto({
    required this.messageId,
    required this.chatRoomId,
    required this.sender,
    required this.messageOrder,
    required this.createdAt,
    required this.contentInfo,
    required this.content,
    required this.reactions,
  });

  factory MessageItemDto.fromJson(Map<String, dynamic> json) {
    final rawReactions = json['reaction'];
    final reactions = (rawReactions is List)
        ? rawReactions
            .whereType<Map<dynamic, dynamic>>()
            .map((r) => MessageReactionDto.fromJson(r.cast<String, dynamic>()))
            .toList()
        : <MessageReactionDto>[];

    return MessageItemDto(
      messageId: (json['messageID'] ?? '').toString(),
      chatRoomId: (json['chatRoomID'] ?? '').toString(),
      sender: json['sender']?.toString(),
      messageOrder:
          json['messageOrder'] is num ? (json['messageOrder'] as num).toInt() : null,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      contentInfo: json['contentInfo'] is Map<String, dynamic>
          ? (json['contentInfo'] as Map).cast<String, dynamic>()
          : null,
      content: json['content']?.toString(),
      reactions: reactions,
    );
  }

  String get displayContent {
    final content = this.content;
    if (content != null && content.isNotEmpty) {
      return content;
    }
    final ci = contentInfo;
    final nested = ci?['content'];
    if (nested is String) {
      return nested;
    }
    return '';
  }
}

class SenderEntityDto {
  final String customerSupportId;
  final String? fullname;

  SenderEntityDto({required this.customerSupportId, required this.fullname});

  factory SenderEntityDto.fromJson(Map<String, dynamic> json) {
    return SenderEntityDto(
      customerSupportId: (json['customerSupportID'] ?? '').toString(),
      fullname: json['fullname']?.toString(),
    );
  }
}

class MessageReactionDto {
  final String messageReactionId;
  final String emoji;
  final int amount;
  final String? customerSupportId;
  final String? customerSupportName;
  final String? customerName;

  MessageReactionDto({
    required this.messageReactionId,
    required this.emoji,
    required this.amount,
    required this.customerSupportId,
    required this.customerSupportName,
    required this.customerName,
  });

  factory MessageReactionDto.fromJson(Map<String, dynamic> json) {
    return MessageReactionDto(
      messageReactionId: (json['messageReactionID'] ?? '').toString(),
      emoji: (json['emoji'] ?? '').toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
      customerSupportId: json['customerSupportID']?.toString(),
      customerSupportName: json['customerSupportName']?.toString(),
      customerName: json['customerName']?.toString(),
    );
  }
}

