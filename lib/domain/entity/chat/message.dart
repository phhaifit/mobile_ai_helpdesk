class Message {
  final int id;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String senderName;
  final bool isPending;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isMe,
    required this.senderName,
    required this.isPending,
  });
}
