import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_dto.dart';
import 'message_entities_dto.dart';

part 'message_list_dto.freezed.dart';
part 'message_list_dto.g.dart';

@freezed
class MessageListDto with _$MessageListDto {
  const factory MessageListDto({
    required MessageEntitiesDto entities, @Default([]) List<MessageDto> messages,
  }) = _MessageListDto;

  factory MessageListDto.fromJson(Map<String, dynamic> json) => 
      _$MessageListDtoFromJson(json);
}