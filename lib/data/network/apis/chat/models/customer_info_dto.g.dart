// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerInfoDtoImpl _$$CustomerInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerInfoDtoImpl(
  customerId: json['customerID'] as String? ?? '',
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$$CustomerInfoDtoImplToJson(
  _$CustomerInfoDtoImpl instance,
) => <String, dynamic>{
  'customerID': instance.customerId,
  'name': instance.name,
};
