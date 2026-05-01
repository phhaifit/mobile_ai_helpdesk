// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoDtoImpl _$$CustomerInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerInfoDtoImpl(
  customerId: json['customerID'] as String? ?? '',
  contactId: json['contactID'] as String? ?? '',
  name: json['name'] as String? ?? '',
  contactInfo:
      (json['contactInfo'] as List<dynamic>?)
          ?.map((e) => ContactInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerInfoDtoImplToJson(
  _$CustomerInfoDtoImpl instance,
) => <String, dynamic>{
  'customerID': instance.customerId,
  'contactID': instance.contactId,
  'name': instance.name,
  'contactInfo': instance.contactInfo,
};
