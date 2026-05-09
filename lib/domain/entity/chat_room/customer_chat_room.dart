import 'package:json_annotation/json_annotation.dart';

part 'customer_chat_room.g.dart';

@JsonSerializable()
class CustomerChatRoom {
  final String id;
  final String customerId;

  /// Raw channel identifier from backend (e.g. messenger/zalo/webchat/email/...)
  final String channel;

  final int totalMessage;
  final int unreadCount;

  /// Preview extracted from last message content.
  final String lastMessagePreview;

  final DateTime? lastMessageAt;

  @JsonKey(defaultValue: [])
  final List<String> linkedTicketIds;

  const CustomerChatRoom({
    required this.id,
    required this.customerId,
    required this.channel,
    required this.totalMessage,
    required this.unreadCount,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    this.linkedTicketIds = const [],
  });

  factory CustomerChatRoom.fromJson(Map<String, dynamic> json) =>
      _$CustomerChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerChatRoomToJson(this);
}
