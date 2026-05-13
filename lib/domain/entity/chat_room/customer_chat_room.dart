/// A chat-room summary scoped to a single customer's profile.
///
/// Source: omnichannel chat rooms (Messenger / Zalo / Webchat / ...).
/// The channel string is kept raw (e.g. `messenger`, `zalo`, `webchat`,
/// `zalo_personal`, `lazada`, `zendesk`) so new BE-defined channels render
/// without an enum rebuild — UI maps unknown values to a generic icon.
class CustomerChatRoom {
  final String id;
  final String customerId;
  final String channel;
  final int totalMessage;
  final int unreadCount;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final List<String> linkedTicketIds;

  const CustomerChatRoom({
    required this.id,
    required this.customerId,
    required this.channel,
    this.totalMessage = 0,
    this.unreadCount = 0,
    this.lastMessagePreview,
    this.lastMessageAt,
    this.linkedTicketIds = const [],
  });

  bool get hasUnread => unreadCount > 0;
}
