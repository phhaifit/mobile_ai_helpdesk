// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactInfoDtoImpl _$$ContactInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoDtoImpl(
      contactId: json['contactID'] as String? ?? '',
      customerId: json['customerID'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isSpam: json['isSpam'] as bool? ?? false,
      zaloAccountId: json['zaloAccountID'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      messengerAccountId: json['messengerAccountID'] as String?,
      zohoAccountId: json['zohoAccountID'] as String?,
    );

Map<String, dynamic> _$$ContactInfoDtoImplToJson(
  _$ContactInfoDtoImpl instance,
) => <String, dynamic>{
  'contactID': instance.contactId,
  'customerID': instance.customerId,
  'name': instance.name,
  'isSpam': instance.isSpam,
  'zaloAccountID': instance.zaloAccountId,
  'email': instance.email,
  'phone': instance.phone,
  'messengerAccountID': instance.messengerAccountId,
  'zohoAccountID': instance.zohoAccountId,
};
