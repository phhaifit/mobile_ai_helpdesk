import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_info_dto.freezed.dart';

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

}

class ContentInfoDtoMapper {
  static ContentInfoDto fromJson(
    Map<String, dynamic> json,
    String type,
  ) {
    switch (type) {
      case 'MESSENGER':
        return ContentInfoDto.messenger(
          messageId: json['messageID'] as String? ?? '',
          messengerMessageId: json['messengerMessageID'] as String,
          content: json['content'] as String,
          recipientId: json['recipientID'] as String? ?? '',
          createdAt: _parseDate(json['createdAt']),
          updatedAt: _parseDate(json['updatedAt']),
          deletedAt: _parseDate(json['deletedAt']),
        );

      case 'ZALO':
        return ContentInfoDto.zalo(
          messageId: json['messageID'] as String? ?? '',
          zaloMessageId: json['zaloMessageID'] as String,
          content: json['content'] as String,
          createdAt: _parseDate(json['createdAt']),
          updatedAt: _parseDate(json['updatedAt']),
          deletedAt: _parseDate(json['deletedAt']),
        );

      default:
        return const ContentInfoDto.unknown();
    }
  }

  static DateTime? _parseDate(dynamic value) {
    return value is String ? DateTime.parse(value) : null;
  }
}