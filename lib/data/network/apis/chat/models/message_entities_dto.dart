import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel_info_dto.dart';
import 'customer_support_info_dto.dart';
part 'message_entities_dto.freezed.dart';
part 'message_entities_dto.g.dart';

@freezed
class MessageEntitiesDto with _$MessageEntitiesDto {
  const factory MessageEntitiesDto({
    @Default({}) Map<String, ChannelInfoDto> channels,
    @Default({}) Map<String, CustomerSupportInfoDto> senders,
    @Default({}) Map<String, dynamic> tickets,
  }) = _MessageEntitiesDto;

  factory MessageEntitiesDto.fromJson(Map<String, dynamic> json) => 
      _$MessageEntitiesDtoFromJson(json);
}