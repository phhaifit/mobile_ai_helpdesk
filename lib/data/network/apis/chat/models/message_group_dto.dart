import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_dto.dart';

part 'message_group_dto.freezed.dart';
part 'message_group_dto.g.dart';

@freezed
class MessageGroupDto with _$MessageGroupDto {
  const factory MessageGroupDto({
    required DateTime date,
    @Default([]) List<MessageDto> messages,
  }) = _MessageGroupDto;

  factory MessageGroupDto.fromJson(Map<String, dynamic> json) => 
      _$MessageGroupDtoFromJson(json);
}