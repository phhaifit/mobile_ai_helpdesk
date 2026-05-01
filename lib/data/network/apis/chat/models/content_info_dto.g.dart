// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessengerContentInfoDtoImpl _$$MessengerContentInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MessengerContentInfoDtoImpl(
  messageId: json['messageID'] as String? ?? '',
  messengerMessageId: json['messengerMessageID'] as String? ?? '',
  content: json['content'] as String? ?? '',
  recipientId: json['recipientID'] as String? ?? '',
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  deletedAt:
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$MessengerContentInfoDtoImplToJson(
  _$MessengerContentInfoDtoImpl instance,
) => <String, dynamic>{
  'messageID': instance.messageId,
  'messengerMessageID': instance.messengerMessageId,
  'content': instance.content,
  'recipientID': instance.recipientId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'runtimeType': instance.$type,
};

_$ZaloContentInfoDtoImpl _$$ZaloContentInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ZaloContentInfoDtoImpl(
  messageId: json['messageID'] as String? ?? '',
  zaloMessageId: json['zaloMessageID'] as String? ?? '',
  content: json['content'] as String? ?? '',
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  deletedAt:
      json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ZaloContentInfoDtoImplToJson(
  _$ZaloContentInfoDtoImpl instance,
) => <String, dynamic>{
  'messageID': instance.messageId,
  'zaloMessageID': instance.zaloMessageId,
  'content': instance.content,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'runtimeType': instance.$type,
};

_$UnknownContentInfoDtoImpl _$$UnknownContentInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$UnknownContentInfoDtoImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$UnknownContentInfoDtoImplToJson(
  _$UnknownContentInfoDtoImpl instance,
) => <String, dynamic>{'runtimeType': instance.$type};
