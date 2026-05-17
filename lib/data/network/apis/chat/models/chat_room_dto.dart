import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_info_dto.dart';
import 'group_info_dto.dart';
import 'message_dto.dart';
import 'seen_info_dto.dart';
import 'ticket_info_dto.dart';

part 'chat_room_dto.freezed.dart';
part 'chat_room_dto.g.dart';

@freezed
class ChatRoomDto with _$ChatRoomDto {
  const factory ChatRoomDto({
    @JsonKey(name: 'chatRoomID') required String chatRoomId,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'groupID') String? groupId,
    @JsonKey(name: 'lastMessageID') required String lastMessageId,
    @Default(0) int totalMessage,
    @Default(0) int followupCount,
    @JsonKey(name: 'ticketID') required String ticketId,
    required DateTime createdAt,
    DateTime? updatedAt,
    MessageDto? lastMessage,
    CustomerInfoDto? customerInfo,
    GroupInfoDto? groupInfo,
    Map<String, dynamic>? myCurrentTicket,
    List<TicketInfoDto>? tickets,
    SeenInfoDto? seenInfo,
    @Default(0) int seenMessageOrder,
    Map<String, dynamic>? defaultChannel,
  }) = _ChatRoomDto;

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) => 
      _$ChatRoomDtoFromJson(json);
}