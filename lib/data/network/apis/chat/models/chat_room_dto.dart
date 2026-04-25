import 'customer_info_dto.dart';
import 'group_info_dto.dart';
import 'message_dto.dart';
import 'seen_info_dto.dart';

class ChatRoomDto {
  final String chatRoomId;
  final String customerId;
  final String? groupId;
  final String? lastMessageId;
  final int totalMessage;
  final int followupCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageDto? lastMessage;
  final CustomerInfoDto? customerInfo;
  final GroupInfoDto? groupInfo;
  final Map<String, dynamic>? myCurrentTicket;
  final List<Map<String, dynamic>> tickets;
  final List<SeenInfoDto> seenInfo;
  final int seenMessageOrder;

  ChatRoomDto({
    required this.chatRoomId,
    required this.customerId,
    required this.groupId,
    required this.lastMessageId,
    required this.totalMessage,
    required this.followupCount,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.customerInfo,
    required this.groupInfo,
    required this.myCurrentTicket,
    required this.tickets,
    required this.seenInfo,
    required this.seenMessageOrder,
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomDto(
      chatRoomId: (json['chatRoomID'] ?? '').toString(),
      customerId: (json['customerID'] ?? '').toString(),
      groupId: json['groupID']?.toString(),
      lastMessageId: json['lastMessageID']?.toString(),
      totalMessage: (json['totalMessage'] is num)
          ? (json['totalMessage'] as num).toInt()
          : 0,
      followupCount: (json['followupCount'] is num)
          ? (json['followupCount'] as num).toInt()
          : 0,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      customerInfo: json['customerInfo'] is Map<String, dynamic>
          ? CustomerInfoDto.fromJson((json['customerInfo'] as Map).cast<String, dynamic>())
          : null,
      lastMessage: json['lastMessage'] is Map<String, dynamic>
          ? MessageDto.fromJson((json['lastMessage'] as Map).cast<String, dynamic>())
          : null,
      groupInfo: json['groupInfo'] is Map<String, dynamic>
          ? GroupInfoDto.fromJson((json['groupInfo'] as Map).cast<String, dynamic>())
          : null,
      myCurrentTicket: json['myCurrentTicket'] is Map<String, dynamic>
          ? (json['myCurrentTicket'] as Map).cast<String, dynamic>()
          : null,
      tickets: json['tickets'] is List
          ? (json['tickets'] as List).whereType<Map<String, dynamic>>().map((t) => Map<String, dynamic>.from(t)).toList()
          : [],
      seenInfo: json['seenInfo'] is List
          ? (json['seenInfo'] as List).whereType<Map<String, dynamic>>().map((s) => SeenInfoDto.fromJson(s)).toList()
          : [],
      seenMessageOrder: (json['seenMessageOrder'] is num)
          ? (json['seenMessageOrder'] as num).toInt()
          : 0,
    );
  }
}


