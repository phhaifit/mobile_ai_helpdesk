// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileAttachmentDtoImpl _$$FileAttachmentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FileAttachmentDtoImpl(
  url: json['url'] as String? ?? '',
  type: json['type'] as String? ?? '',
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$$FileAttachmentDtoImplToJson(
  _$FileAttachmentDtoImpl instance,
) => <String, dynamic>{
  'url': instance.url,
  'type': instance.type,
  'name': instance.name,
};
