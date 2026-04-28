import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entities_dto.freezed.dart';
part 'message_entities_dto.g.dart';

@freezed
class MessageEntitiesDto with _$MessageEntitiesDto {
  const factory MessageEntitiesDto({
    @Default({}) Map<String, dynamic> channels,
    @Default({}) Map<String, dynamic> senders,
    @Default({}) Map<String, dynamic> tickets,
  }) = _MessageEntitiesDto;

  factory MessageEntitiesDto.fromJson(Map<String, dynamic> json) => 
      _$MessageEntitiesDtoFromJson(json);
}