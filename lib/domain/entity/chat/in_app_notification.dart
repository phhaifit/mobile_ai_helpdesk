class InAppNotification {
  final String id;
  final String title;
  final String body;
  final String? chatRoomId;
  final String type;
  final bool seen;
  final DateTime? createdAt;

  const InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.seen,
    this.chatRoomId,
    this.createdAt,
  });
}
