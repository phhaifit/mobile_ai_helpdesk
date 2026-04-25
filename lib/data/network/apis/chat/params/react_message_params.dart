class ReactMessageParams {
  final String messageId;
  final String zaloMessageId;
  final String reactIcon;
  final String zaloAccountId;
  final String chatRoomId;
  final String? socketId;
  final String? channelId;

  ReactMessageParams({
    required this.messageId,
    required this.zaloMessageId,
    required this.reactIcon,
    required this.zaloAccountId,
    required this.chatRoomId,
    this.socketId,
    this.channelId,
  });

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageId,
      'zaloMessageID': zaloMessageId,
      'reactIcon': reactIcon,
      'zaloAccountID': zaloAccountId,
      'chatRoomID': chatRoomId,
      if (socketId != null) 'socketID': socketId,
      if (channelId != null) 'channelID': channelId,
    };
  }
}