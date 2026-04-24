class SocketInAppNotificationEvent {
  static const String name = 'SOCKET_NOTI';

  final String id;
  final String title;
  final String body;
  final DateTime? createdAt;

  SocketInAppNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  static SocketInAppNotificationEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final m = payload.cast<String, dynamic>();
    final id = (m['id'] ?? '').toString();
    if (id.isEmpty) return null;
    return SocketInAppNotificationEvent(
      id: id,
      title: (m['title'] ?? '').toString(),
      body: (m['body'] ?? '').toString(),
      createdAt: m['createdAt'] is String
          ? DateTime.tryParse(m['createdAt'] as String)
          : null,
    );
  }
}

