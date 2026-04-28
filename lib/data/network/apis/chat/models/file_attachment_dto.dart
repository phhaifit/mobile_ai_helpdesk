import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_attachment_dto.freezed.dart';
part 'file_attachment_dto.g.dart';

@freezed
class FileAttachmentDto with _$FileAttachmentDto {
  const factory FileAttachmentDto({
    @Default('') String url,
    @Default('') String type,
    @Default('') String name,
  }) = _FileAttachmentDto;

  factory FileAttachmentDto.fromJson(Map<String, dynamic> json) => 
      _$FileAttachmentDtoFromJson(json);
}