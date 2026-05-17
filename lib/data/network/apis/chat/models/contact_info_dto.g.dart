// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessengerContactInfoDtoImpl _$$MessengerContactInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessengerContactInfoDtoImpl(
  contactId: json['contactID'] as String? ?? '',
  customerId: json['customerID'] as String? ?? '',
  messengerAccountId: json['messengerAccountID'] as String? ?? '',
  messengerAccountName: json['messengerAccountName'] as String? ?? '',
  messengerAccountAvatar: json['messengerAccountAvatar'] as String? ?? '',
  messengerPageId: json['messengerPageID'] as String? ?? '',
  $type: json['name'] as String?,
);

Map<String, dynamic> _$$MessengerContactInfoDtoImplToJson(
  _$MessengerContactInfoDtoImpl instance,
) => <String, dynamic>{
  'contactID': instance.contactId,
  'customerID': instance.customerId,
  'messengerAccountID': instance.messengerAccountId,
  'messengerAccountName': instance.messengerAccountName,
  'messengerAccountAvatar': instance.messengerAccountAvatar,
  'messengerPageID': instance.messengerPageId,
  'name': instance.$type,
};

_$ZaloContactInfoDtoImpl _$$ZaloContactInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ZaloContactInfoDtoImpl(
  contactId: json['contactID'] as String? ?? '',
  customerId: json['customerID'] as String? ?? '',
  zaloAccountId: json['zaloAccountID'] as String? ?? '',
  zaloPhone: json['zalophone'] as String? ?? '',
  zaloAccountName: json['zaloAccountName'] as String? ?? '',
  zaloAccountAvatar: json['zaloAccountAvatar'] as String? ?? '',
  zaloAppId: json['zaloAppID'] as String? ?? '',
  channelId: json['channelID'] as String? ?? '',
  $type: json['name'] as String?,
);

Map<String, dynamic> _$$ZaloContactInfoDtoImplToJson(
  _$ZaloContactInfoDtoImpl instance,
) => <String, dynamic>{
  'contactID': instance.contactId,
  'customerID': instance.customerId,
  'zaloAccountID': instance.zaloAccountId,
  'zalophone': instance.zaloPhone,
  'zaloAccountName': instance.zaloAccountName,
  'zaloAccountAvatar': instance.zaloAccountAvatar,
  'zaloAppID': instance.zaloAppId,
  'channelID': instance.channelId,
  'name': instance.$type,
};

_$PhoneContactInfoDtoImpl _$$PhoneContactInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PhoneContactInfoDtoImpl(
  contactId: json['contactID'] as String? ?? '',
  customerId: json['customerID'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  isSpam: json['isSpam'] as bool? ?? false,
  $type: json['name'] as String?,
);

Map<String, dynamic> _$$PhoneContactInfoDtoImplToJson(
  _$PhoneContactInfoDtoImpl instance,
) => <String, dynamic>{
  'contactID': instance.contactId,
  'customerID': instance.customerId,
  'phone': instance.phone,
  'isSpam': instance.isSpam,
  'name': instance.$type,
};

_$UnknownContactInfoDtoImpl _$$UnknownContactInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UnknownContactInfoDtoImpl($type: json['name'] as String?);

Map<String, dynamic> _$$UnknownContactInfoDtoImplToJson(
  _$UnknownContactInfoDtoImpl instance,
) => <String, dynamic>{'name': instance.$type};
