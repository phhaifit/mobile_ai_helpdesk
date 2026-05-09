import 'dart:math' as math;

import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room_dto.g.dart';

@JsonSerializable()
class ChatRoomDto {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'chatRoomId')
  final String? chatRoomId;

  @JsonKey(name: 'customerId')
  final String? customerId;

  @JsonKey(name: 'customerID')
  final String? customerID;

  @JsonKey(name: 'channelType')
  final String? channelType;

  @JsonKey(name: 'channel')
  final String? channel;

  @JsonKey(name: 'totalMessage')
  final int? totalMessage;

  @JsonKey(name: 'seenMessageOrder')
  final int? seenMessageOrder;

  @JsonKey(name: 'lastMessage')
  final MessageDto? lastMessage;

  @JsonKey(name: 'tickets', defaultValue: const <TicketRefDto>[])
  final List<TicketRefDto> tickets;

  const ChatRoomDto({
    this.id,
    this.chatRoomId,
    this.customerId,
    this.customerID,
    this.channelType,
    this.channel,
    this.totalMessage,
    this.seenMessageOrder,
    this.lastMessage,
    this.tickets = const <TicketRefDto>[],
  });

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomDtoToJson(this);

  CustomerChatRoom toEntity() {
    final resolvedId = (id ?? chatRoomId ?? '').trim();
    final resolvedCustomerId = (customerId ?? customerID ?? '').trim();
    final resolvedChannel = (channelType ?? channel ?? '').trim();

    final total = totalMessage ?? 0;
    final seen = seenMessageOrder ?? 0;
    final unread = math.max(0, total - seen);

    final preview =
        (lastMessage?.contentInfo?.content ??
                lastMessage?.content ??
                lastMessage?.text ??
                '')
            .trim();

    final linkedTicketIds = tickets
        .map((t) => (t.id ?? t.ticketId ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    return CustomerChatRoom(
      id: resolvedId,
      customerId: resolvedCustomerId,
      channel: resolvedChannel,
      totalMessage: total,
      unreadCount: unread,
      lastMessagePreview: preview,
      lastMessageAt: lastMessage?.createdAt,
      linkedTicketIds: linkedTicketIds,
    );
  }
}

@JsonSerializable()
class TicketRefDto {
  final String? id;

  @JsonKey(name: 'ticketId')
  final String? ticketId;

  const TicketRefDto({this.id, this.ticketId});

  factory TicketRefDto.fromJson(Map<String, dynamic> json) =>
      _$TicketRefDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TicketRefDtoToJson(this);
}

@JsonSerializable()
class MessageDto {
  final String? id;

  @JsonKey(name: 'messageOrder')
  final int? messageOrder;

  final String? content;

  final String? text;

  @JsonKey(name: 'contentInfo')
  final ContentInfoDto? contentInfo;

  @JsonKey(name: 'entities')
  final MessageEntitiesDto? entities;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  const MessageDto({
    this.id,
    this.messageOrder,
    this.content,
    this.text,
    this.contentInfo,
    this.entities,
    this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}

@JsonSerializable()
class ContentInfoDto {
  final String? content;

  const ContentInfoDto({this.content});

  factory ContentInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ContentInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContentInfoDtoToJson(this);
}

@JsonSerializable()
class MessageEntitiesDto {
  @JsonKey(name: 'contact')
  final ContactInfoDto? contact;

  const MessageEntitiesDto({this.contact});

  factory MessageEntitiesDto.fromJson(Map<String, dynamic> json) =>
      _$MessageEntitiesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntitiesDtoToJson(this);
}

@JsonSerializable()
class ContactInfoDto {
  final String? email;
  final String? phone;

  const ContactInfoDto({this.email, this.phone});

  factory ContactInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoDtoToJson(this);
}
