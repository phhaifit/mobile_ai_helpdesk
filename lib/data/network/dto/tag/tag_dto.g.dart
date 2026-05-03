// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagDto _$TagDtoFromJson(Map<String, dynamic> json) => TagDto(
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  tagID: json['tagID'] as String?,
  tagName: json['tagName'] as String?,
  tenantId: json['tenantId'] as String?,
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TagDtoToJson(TagDto instance) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'tagID': instance.tagID,
  'tagName': instance.tagName,
  'tenantId': instance.tenantId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

ListTagDto _$ListTagDtoFromJson(Map<String, dynamic> json) => ListTagDto(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  message: json['message'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$ListTagDtoToJson(ListTagDto instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };
