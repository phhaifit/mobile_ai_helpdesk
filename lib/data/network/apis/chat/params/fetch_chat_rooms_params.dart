import 'package:freezed_annotation/freezed_annotation.dart';

part 'fetch_chat_rooms_params.freezed.dart';
part 'fetch_chat_rooms_params.g.dart';

@freezed
class FetchChatRoomsParams with _$FetchChatRoomsParams {
  const factory FetchChatRoomsParams({
    @JsonKey(includeIfNull: false) String? customerName,
    @Default(20) int limit,
    @JsonKey(name: 'lastMessageID', includeIfNull: false) String? lastMessageId,
    @JsonKey(name: 'lastChatRoomID', includeIfNull: false) String? lastChatRoomId,
    @JsonKey(includeIfNull: false) String? lastChatRoomUpdatedAt,
    @JsonKey(includeIfNull: false) String? status,
    @JsonKey(includeIfNull: false) List<String>? statuses,
    @JsonKey(name: 'channel', includeIfNull: false) List<String>? channels, 
    @JsonKey(name: 'channelIDs', includeIfNull: false) List<String>? channelIds,
    DateTime? updatedAtFrom, // Note: This was missing in your original toJson, but json_serializable will now handle it!
    DateTime? updatedAtTo,   // Note: This was missing in your original toJson, but json_serializable will now handle it!
    @Default(false) bool getCounter,
    @Default(false) bool getAll,
  }) = _FetchChatRoomsParams;

  factory FetchChatRoomsParams.fromJson(Map<String, dynamic> json) => 
      _$FetchChatRoomsParamsFromJson(json);
}