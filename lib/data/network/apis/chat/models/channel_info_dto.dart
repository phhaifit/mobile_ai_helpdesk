import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_info_dto.freezed.dart';
part 'channel_info_dto.g.dart';

@freezed
class ChannelInfoDto with _$ChannelInfoDto {
  const factory ChannelInfoDto ({
    @JsonKey(name: 'appID') required String appId,
    @JsonKey(name: 'channelID') required String channelId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'config') required Map<String, dynamic> config,
    @JsonKey(name: 'appInfo') required Map<String, dynamic> appInfo,
  }) = _ChannelInfoDto;

  factory ChannelInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelInfoDtoFromJson(json);
}