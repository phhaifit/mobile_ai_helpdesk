import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_info_dto.dart';
import 'group_info_dto.dart';
import 'message_dto.dart';
import 'seen_info_dto.dart';

part 'chat_room_dto.freezed.dart';
part 'chat_room_dto.g.dart';

@freezed
class ChatRoomDto with _$ChatRoomDto {
  const factory ChatRoomDto({
    @JsonKey(name: 'chatRoomID') @Default('') String chatRoomId,
    @JsonKey(name: 'customerID') @Default('') String customerId,
    @JsonKey(name: 'groupID') String? groupId,
    @JsonKey(name: 'lastMessageID') String? lastMessageId,
    @Default(0) int totalMessage,
    @Default(0) int followupCount,
    required DateTime createdAt,
    required DateTime updatedAt,
    MessageDto? lastMessage,
    CustomerInfoDto? customerInfo,
    GroupInfoDto? groupInfo,
    Map<String, dynamic>? myCurrentTicket,
    @Default([]) List<Map<String, dynamic>> tickets,
    @Default([]) List<SeenInfoDto> seenInfo,
    @Default(0) int seenMessageOrder,
  }) = _ChatRoomDto;

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) => 
      _$ChatRoomDtoFromJson(json);
}