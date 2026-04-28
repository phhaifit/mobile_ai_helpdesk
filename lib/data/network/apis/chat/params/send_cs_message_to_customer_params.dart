import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/file_attachment_dto.dart'; 

part 'send_cs_message_to_customer_params.freezed.dart';
part 'send_cs_message_to_customer_params.g.dart';

@freezed
class SendCsMessageToCustomerParams with _$SendCsMessageToCustomerParams {
  const factory SendCsMessageToCustomerParams({
    @JsonKey(name: 'chatRoomID') required String chatRoomId,
    @JsonKey(name: 'contactID') required String contactId,
    @JsonKey(name: 'channelID') required String channelId,
    @JsonKey(includeIfNull: false) String? groupId,
    @JsonKey(name: 'ticketID', includeIfNull: false) String? ticketId,
    @JsonKey(includeIfNull: false) String? content,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(name: 'replyMessageID', includeIfNull: false) String? replyMessageId,
    @JsonKey(name: 'socketID', includeIfNull: false) String? socketId,
    @JsonKey(includeIfNull: false) List<FileAttachmentDto>? files,
    @JsonKey(includeIfNull: false) bool? isAutoReply,
    @JsonKey(includeIfNull: false) String? messageTag,
    @JsonKey(includeIfNull: false) bool? mentionReply,
  }) = _SendCsMessageToCustomerParams;

  factory SendCsMessageToCustomerParams.fromJson(Map<String, dynamic> json) => 
      _$SendCsMessageToCustomerParamsFromJson(json);
}