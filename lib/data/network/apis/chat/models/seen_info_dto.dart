import 'package:freezed_annotation/freezed_annotation.dart';

part 'seen_info_dto.freezed.dart';
part 'seen_info_dto.g.dart';

@freezed
class SeenInfoDto with _$SeenInfoDto {
  const factory SeenInfoDto({
    @JsonKey(name: 'chatRoomSeenID') @Default('') String chatRoomSeenId,
    @JsonKey(name: 'chatRoomID') @Default('') String chatRoomId,
    @JsonKey(name: 'customerSupportID') @Default('') String customerSupportId,
    @JsonKey(name: 'messageID') @Default('') String messageId,
    @Default(0) int messageOrder,
    @Default(0) int numberMessageSeen,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SeenInfoDto;

  factory SeenInfoDto.fromJson(Map<String, dynamic> json) => 
      _$SeenInfoDtoFromJson(json);
}