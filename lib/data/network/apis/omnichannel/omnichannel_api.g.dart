// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omnichannel_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


ZaloQrStatusDto _$ZaloQrStatusDtoFromJson(Map<String, dynamic> json) =>
    ZaloQrStatusDto(
      status: json['status'] as String,
      authCode: json['authCode'] as String?,
    );

Map<String, dynamic> _$ZaloQrStatusDtoToJson(ZaloQrStatusDto instance) =>
    <String, dynamic>{'status': instance.status, 'authCode': instance.authCode};
