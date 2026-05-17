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
  customerSupportName: json['customerSupportName'] as String?,
  customerSupportAvatar: json['customerSupportAvatar'] as String?,
  customerName: json['customerName'] as String?,
  customerAvatar: json['customerAvatar'] as String?,
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
  'customerSupportName': instance.customerSupportName,
  'customerSupportAvatar': instance.customerSupportAvatar,
  'customerName': instance.customerName,
  'customerAvatar': instance.customerAvatar,
};
