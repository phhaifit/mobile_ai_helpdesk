import 'package:freezed_annotation/freezed_annotation.dart';

part 'react_message_params.freezed.dart';
part 'react_message_params.g.dart';

@freezed
class ReactMessageParams with _$ReactMessageParams {
  const factory ReactMessageParams({
    @JsonKey(name: 'messageID') required String messageId,
    @JsonKey(name: 'zaloMessageID') required String zaloMessageId,
    required String reactIcon,
    @JsonKey(name: 'zaloAccountID') required String zaloAccountId,
    @JsonKey(name: 'chatRoomID') required String chatRoomId,
    @JsonKey(name: 'socketID', includeIfNull: false) String? socketId,
    @JsonKey(name: 'channelID', includeIfNull: false) String? channelId,
  }) = _ReactMessageParams;

  factory ReactMessageParams.fromJson(Map<String, dynamic> json) => 
      _$ReactMessageParamsFromJson(json);
}