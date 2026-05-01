import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_info_dto.freezed.dart';
part 'content_info_dto.g.dart';

@freezed
class ContentInfoDto with _$ContentInfoDto {
  const factory ContentInfoDto.messenger({
    @JsonKey(name: 'messageID') @Default('') String messageId,
    @JsonKey(name: 'messengerMessageID') @Default('') String messengerMessageId,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'recipientID') @Default('') String recipientId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = MessengerContentInfoDto;

  const factory ContentInfoDto.zalo({
    @JsonKey(name: 'messageID') @Default('') String messageId,
    @JsonKey(name: 'zaloMessageID') @Default('') String zaloMessageId,
    @JsonKey(name: 'content') @Default('') String content,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = ZaloContentInfoDto;

  const factory ContentInfoDto.unknown() = UnknownContentInfoDto;

  factory ContentInfoDto.fromJson(Map<String, dynamic> json) => 
      _$ContentInfoDtoFromJson(json);
}

extension ContentInfoDtoMapper on ContentInfoDto {
  static ContentInfoDto fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'MESSENGER':
        return ContentInfoDto.messenger(
          messageId: json['messageID'] as String,
          messengerMessageId: json['messengerMessageID'] as String,
          content: json['content'] as String,
          recipientId: json['recipientID'] as String,
          createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt'] as String) : null,
          updatedAt: json['updatedAt'] is String ? DateTime.parse(json['updatedAt'] as String) : null,
          deletedAt: json['deletedAt'] is String ? DateTime.parse(json['deletedAt'] as String) : null,
        );
      case 'ZALO':
        return ContentInfoDto.zalo(
          messageId: json['messageID'] as String,
          zaloMessageId: json['zaloMessageID'] as String,
          content: json['content'] as String,
          createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt'] as String) : null,
          updatedAt: json['updatedAt'] is String ? DateTime.parse(json['updatedAt'] as String) : null,
          deletedAt: json['deletedAt'] is String ? DateTime.parse(json['deletedAt'] as String) : null,
        );
      default:
        return const ContentInfoDto.unknown();
    }
  }
}