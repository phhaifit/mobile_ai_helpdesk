import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/dto/message_list_dto.dart';
import 'package:ai_helpdesk/data/sharedpref/shared_preference_helper.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';

class ChatRepositoryNetworkImpl implements ChatRepository {
  final ChatApi _chatApi;
  final SharedPreferenceHelper _prefs;

  ChatRepositoryNetworkImpl(this._chatApi, this._prefs);

  @override
  Future<List<Message>> getMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final raw = await _chatApi.getMessageList(
      chatRoomId: chatRoomId,
      lastMessageId: lastMessageId,
      limit: limit,
    );
    final dto = MessageListDto.fromJson(raw);
    return _mapMessages(dto);
  }

  @override
  Future<List<Message>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final raw = await _chatApi.getNewerMessages(
      chatRoomId: chatRoomId,
      lastMessageId: lastMessageId,
      limit: limit,
    );
    final dto = MessageListDto.fromJson(raw);
    return _mapMessages(dto);
  }

  @override
  Future<Message> sendMessageFromAgentToCustomer({
    required String chatRoomId,
    required String channelId,
    required String contactId,
    required String content,
    String? replyMessageId,
    String? socketId,
  }) async {
    final raw = await _chatApi.sendMessageFromAgentToCustomer(
      chatRoomId: chatRoomId,
      channelId: channelId,
      contactId: contactId,
      content: content,
      replyMessageId: replyMessageId,
      socketId: socketId,
    );
    final data = raw['data'];
    if (data is! Map) {
      throw StateError('Invalid response shape: missing data');
    }
    final msg = MessageItemDto.fromJson(data.cast<String, dynamic>());
    final dto = MessageListDto(messages: [msg], senders: const {});
    return (await _mapMessages(dto)).first;
  }

  Future<List<Message>> _mapMessages(MessageListDto dto) async {
    final me = await _prefs.getUser();
    final myId = me?.id;

    // API returns newest-first for getMessageList; our UI expects list order as-is.
    // We'll keep the server order for now (it already renders fine) and later we can
    // enforce ordering in the UI based on messageOrder if needed.
    return dto.messages.map((m) {
      final isMe = myId != null && m.sender != null && m.sender == myId;
      final senderName = _resolveSenderName(m, dto, isMe: isMe);
      final reactions = _mapReactions(m);
      return Message(
        id: m.messageId,
        chatRoomId: m.chatRoomId,
        content: m.displayContent,
        timestamp: m.createdAt ?? DateTime.now(),
        isMe: isMe,
        senderName: senderName,
        isPending: false,
        readStatus: MessageReadStatus.delivered,
        reactions: reactions,
      );
    }).toList();
  }

  String _resolveSenderName(
    MessageItemDto m,
    MessageListDto dto, {
    required bool isMe,
  }) {
    if (isMe) {
      return 'You';
    }
    final senderId = m.sender;
    if (senderId == null || senderId.isEmpty) {
      return 'Customer';
    }
    final sender = dto.senders[senderId];
    return sender?.fullname?.isNotEmpty == true ? sender!.fullname! : 'Agent';
  }

  List<Reaction> _mapReactions(MessageItemDto m) {
    final grouped = <String, List<String>>{};
    for (final r in m.reactions) {
      final emoji = r.emoji;
      if (emoji.isEmpty) continue;
      final names = grouped.putIfAbsent(emoji, () => <String>[]);
      final who = r.customerSupportName ?? r.customerName;
      if (who != null && who.isNotEmpty) {
        names.add(who);
      } else {
        // Fallback to count-based placeholder labels when names aren’t present.
        for (var i = 0; i < r.amount; i++) {
          names.add('User');
        }
      }
    }
    return grouped.entries
        .map((e) => Reaction(emoji: e.key, userNames: e.value))
        .toList();
  }
}

