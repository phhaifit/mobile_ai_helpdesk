import 'package:freezed_annotation/freezed_annotation.dart';
import 'customer_info_dto.dart';
import 'customer_support_info_dto.dart';

part 'message_reaction_dto.freezed.dart';
part 'message_reaction_dto.g.dart';

@freezed
class MessageReactionDto with _$MessageReactionDto {
  const factory MessageReactionDto({
    @JsonKey(name: 'messageReactionID') @Default('') String messageReactionId,
    @JsonKey(name: 'messageID') @Default('') String messageId,
    @Default('') String emoji,
    @Default(0) int amount,
    @JsonKey(name: 'customerID') String? customerId,
    @JsonKey(name: 'customerSupportID') String? customerSupportId,
    CustomerInfoDto? customerInfo,
    CustomerSupportInfoDto? customerSupportInfo,
  }) = _MessageReactionDto;

  factory MessageReactionDto.fromJson(Map<String, dynamic> json) => 
      _$MessageReactionDtoFromJson(json);
}