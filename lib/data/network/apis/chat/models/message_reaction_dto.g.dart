// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageReactionDtoImpl _$$MessageReactionDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessageReactionDtoImpl(
  messageReactionId: json['messageReactionID'] as String? ?? '',
  messageId: json['messageID'] as String? ?? '',
  emoji: json['emoji'] as String? ?? '',
  amount: (json['amount'] as num?)?.toInt() ?? 0,
  customerId: json['customerID'] as String?,
  customerSupportId: json['customerSupportID'] as String?,
  customerInfo:
      json['customerInfo'] == null
          ? null
          : CustomerInfoDto.fromJson(
            json['customerInfo'] as Map<String, dynamic>,
          ),
  customerSupportInfo:
      json['customerSupportInfo'] == null
          ? null
          : CustomerSupportInfoDto.fromJson(
            json['customerSupportInfo'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$$MessageReactionDtoImplToJson(
  _$MessageReactionDtoImpl instance,
) => <String, dynamic>{
  'messageReactionID': instance.messageReactionId,
  'messageID': instance.messageId,
  'emoji': instance.emoji,
  'amount': instance.amount,
  'customerID': instance.customerId,
  'customerSupportID': instance.customerSupportId,
  'customerInfo': instance.customerInfo,
  'customerSupportInfo': instance.customerSupportInfo,
};
