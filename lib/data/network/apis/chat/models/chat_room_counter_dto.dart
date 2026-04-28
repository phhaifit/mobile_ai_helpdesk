import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_counter_dto.freezed.dart';
part 'chat_room_counter_dto.g.dart';

@freezed
class ChatRoomCounterDto with _$ChatRoomCounterDto {
  const factory ChatRoomCounterDto({
    @Default(0) int open,
    @Default(0) int pending,
    @Default(0) int solved,
    @Default(0) int closed,
  }) = _ChatRoomCounterDto;

  factory ChatRoomCounterDto.fromJson(Map<String, dynamic> json) => 
      _$ChatRoomCounterDtoFromJson(json);
}