/// Preview of the message being replied to, for quote UI in bubbles and composer.
class MessageReplyPreview {
  final String messageId;
  final String senderName;
  final String content;
  final bool isMe;

  const MessageReplyPreview({
    required this.messageId,
    required this.senderName,
    required this.content,
    required this.isMe,
  });
}
