import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_dto.g.dart';

@JsonSerializable()
class TagDto {
  final DateTime? createdAt;
  final String? tagID;
  final String? tagName;
  final String? tenantId;
  final DateTime? updatedAt;

  const TagDto({
    this.createdAt,
    this.tagID,
    this.tagName,
    this.tenantId,
    this.updatedAt,
  });

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TagDtoToJson(this);

  Tag toEntity() {
    return Tag(
      id: tagID ?? '',
      name: tagName ?? '',
      tenantId: tenantId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@JsonSerializable()
class ListTagDto {
  @JsonKey(defaultValue: [])
  final List<TagDto> data;
  final String? message;
  final String? status;

  const ListTagDto({
    required this.data,
    this.message,
    this.status,
  });

  factory ListTagDto.fromJson(Map<String, dynamic> json) => _$ListTagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ListTagDtoToJson(this);
}
