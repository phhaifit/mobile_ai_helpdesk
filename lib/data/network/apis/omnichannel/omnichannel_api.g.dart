// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'omnichannel_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZaloQrDto _$ZaloQrDtoFromJson(Map<String, dynamic> json) =>
    ZaloQrDto(code: json['code'] as String, qrUrl: json['qrUrl'] as String);

Map<String, dynamic> _$ZaloQrDtoToJson(ZaloQrDto instance) => <String, dynamic>{
  'code': instance.code,
  'qrUrl': instance.qrUrl,
};

ZaloQrStatusDto _$ZaloQrStatusDtoFromJson(Map<String, dynamic> json) =>
    ZaloQrStatusDto(
      status: json['status'] as String,
      authCode: json['authCode'] as String?,
    );

Map<String, dynamic> _$ZaloQrStatusDtoToJson(ZaloQrStatusDto instance) =>
    <String, dynamic>{'status': instance.status, 'authCode': instance.authCode};
