import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_info_dto.freezed.dart';
part 'channel_info_dto.g.dart';

@freezed
class ChannelInfoDto with _$ChannelInfoDto {
  const factory ChannelInfoDto.zalo({
    required String zaloId,
    String? displayName,
  }) = ZaloChannelInfoDto;

  const factory ChannelInfoDto.messenger({
    required String messengerId,
    String? username,
  }) = MessengerChannelInfoDto;

  const factory ChannelInfoDto.unknown() = UnknownChannelInfoDto;

  factory ChannelInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelInfoDtoFromJson(json);
}