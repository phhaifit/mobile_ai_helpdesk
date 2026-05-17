import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_info_dto.freezed.dart';
part 'ticket_info_dto.g.dart';

@freezed
class TicketInfoDto with _$TicketInfoDto {
  const factory TicketInfoDto({
    @JsonKey(name: 'ticketID') required String ticketId,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'priority') required String priority,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') @Default('') String? description,
  }) = _TicketInfoDto;

  factory TicketInfoDto.fromJson(Map<String, dynamic> json) => 
      _$TicketInfoDtoFromJson(json);
}