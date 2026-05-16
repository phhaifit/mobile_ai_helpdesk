class SocketInAppNotificationEvent {
  static const String name = 'SOCKET_NOTI';

  final String id;
  final String title;
  final String body;
  final String? customerSupportId;
  final String? url;
  final bool seen;
  final String type;
  final DateTime? createdAt;
  final String? chatRoomId;

  SocketInAppNotificationEvent({
    required this.id,
    required this.title,
    required this.body,
    required this.seen,
    required this.type,
    this.customerSupportId,
    this.url,
    this.createdAt,
    this.chatRoomId,
  });

  static SocketInAppNotificationEvent? parse(dynamic payload) {
    if (payload is! Map) return null;
    final Map<String, dynamic> m = payload.cast<String, dynamic>();

    final String title = (m['title'] ?? '').toString();
    final String body = (m['content'] ?? m['body'] ?? '').toString();
    final String url = (m['url'] ?? '').toString();
    final String createdAtRaw = (m['createdAt'] ?? '').toString();

    final String id = (m['id'] ?? '').toString().trim().isNotEmpty
        ? (m['id'] ?? '').toString()
        : '$url|$createdAtRaw';

    if (id.isEmpty || (title.isEmpty && body.isEmpty)) return null;

    final String? chatRoomId = _parseChatRoomIdFromUrl(url);

    return SocketInAppNotificationEvent(
      id: id,
      title: title,
      body: body,
      customerSupportId: m['customerSupportID']?.toString(),
      url: url.isEmpty ? null : url,
      seen: m['seen'] == true,
      type: (m['type'] ?? '').toString(),
      createdAt: createdAtRaw.isNotEmpty
          ? DateTime.tryParse(createdAtRaw)
          : null,
      chatRoomId: chatRoomId,
    );
  }

  /// True for in-app notifications that indicate a new chat message arrived.
  bool get isNewMessage {
    final String normalized =
        type.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '_');
    return normalized == 'NEW_MESSAGE';
  }

  static String? _parseChatRoomIdFromUrl(String url) {
    if (url.isEmpty) return null;
    final Uri? uri = Uri.tryParse(url.startsWith('/') ? 'https://x$url' : url);
    if (uri == null) return null;
    final String? fromChat = uri.queryParameters['chat'];
    if (fromChat != null && fromChat.isNotEmpty) return fromChat;
    return null;
  }
}
