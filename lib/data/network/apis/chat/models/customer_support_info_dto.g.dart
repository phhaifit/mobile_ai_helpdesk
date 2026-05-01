// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_support_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerSupportInfoDtoImpl _$$CustomerSupportInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerSupportInfoDtoImpl(
  customerSupportId: json['customerSupportID'] as String? ?? '',
  fullname: json['fullname'] as String? ?? '',
  avatar: json['avatar'] as String? ?? '',
);

Map<String, dynamic> _$$CustomerSupportInfoDtoImplToJson(
  _$CustomerSupportInfoDtoImpl instance,
) => <String, dynamic>{
  'customerSupportID': instance.customerSupportId,
  'fullname': instance.fullname,
  'avatar': instance.avatar,
};
