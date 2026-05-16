import 'dart:async';

import 'package:ai_helpdesk/core/events/socket/server/ai/socket_draft_response_progress_event.dart';
import 'package:ai_helpdesk/core/events/socket/server/interactions/message_reaction_update_event.dart';
import 'package:ai_helpdesk/core/events/socket/server/messages/socket_inapp_notification_event.dart';
import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/contact_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/content_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/file_attachment_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_entities_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_group_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_reaction_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/react_message_params.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/send_cs_message_to_customer_params.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';
import 'package:ai_helpdesk/data/realtime/socket/socket_service.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_typing_event.dart';
import 'package:ai_helpdesk/domain/entity/chat/draft_response_progress.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart' show Message;
import 'package:ai_helpdesk/domain/entity/chat/message_reply_preview.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/entity/chat/message_reaction_update.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/entity/chat/user.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import 'package:dio/dio.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;
  final SocketService _socketService;
  final Map<String, List<Message>> _messageCache = <String, List<Message>>{};
  final Map<String, bool> _hasMoreOlderByRoom = <String, bool>{};

  static const int _pageSize = 30;
  static const int _prefetchConcurrency = 4;

  final StreamController<String> _messagesController =
      StreamController<String>.broadcast();
  final StreamController<Message> _incomingMessagesController =
      StreamController<Message>.broadcast();
  final StreamController<MessageReactionUpdate> _reactionController =
      StreamController<MessageReactionUpdate>.broadcast();
  final StreamController<ChatTypingEvent> _customerTypingController =
      StreamController<ChatTypingEvent>.broadcast();
  final StreamController<DraftResponseProgress> _draftProgressController =
      StreamController<DraftResponseProgress>.broadcast();

  bool _socketListening = false;

  ChatRepositoryImpl(this._chatApi, this._socketService) {
    _listenSocket();
  }

  void _listenSocket() {
    if (_socketListening) return;
    _socketListening = true;

    _socketService.messages.listen(_handleMessage);

    _socketService.reactions.listen(_handleReactionSocket);

    _socketService.customerTyping.listen((String chatRoomId) {
      _customerTypingController.add(
        ChatTypingEvent(chatRoomId: chatRoomId, isTyping: true),
      );
    });

    _socketService.customerStopTyping.listen((String chatRoomId) {
      _customerTypingController.add(
        ChatTypingEvent(chatRoomId: chatRoomId, isTyping: false),
      );
    });

    _socketService.draftProgress.listen(_handleDraftProgressSocket);

    _socketService.notifications.listen(_handleInAppNotificationSocket);
  }

  void _handleInAppNotificationSocket(SocketInAppNotificationEvent event) {
    if (!event.isNewMessage) return;
    final String? roomId = event.chatRoomId;
    if (roomId == null || roomId.isEmpty) return;

    unawaited(_syncNewerMessagesFromNotification(roomId));
  }

  Future<void> _syncNewerMessagesFromNotification(String roomId) async {
    try {
      final List<Message> added = await loadNewerMessages(roomId);
      if (added.isNotEmpty) {
        _incomingMessagesController.add(added.last);
      }
    } catch (_) {
      // Best-effort catch-up; inbox still shows SOCKET_NOTI preview.
    }
  }

  void _handleReactionSocket(MessageReactionUpdateEvent event) {
    final MessageReactionUpdate update = _mapReactionUpdate(event);
    _applyReactionUpdate(update);
    _reactionController.add(update);
  }

  MessageReactionUpdate _mapReactionUpdate(MessageReactionUpdateEvent event) {
    final bool isRemoved =
        event.deletedAt != null || event.amount <= 0;
    return MessageReactionUpdate(
      messageReactionId: event.messageReactionId,
      messageId: event.messageId,
      chatRoomId: event.chatRoomId,
      emoji: event.emoji,
      amount: event.amount,
      customerId: event.customerId,
      customerSupportId: event.customerSupportId,
      customerSupportName: event.customerSupportName,
      customerSupportAvatar: event.customerSupportAvatar,
      isRemoved: isRemoved,
    );
  }

  void _applyReactionUpdate(MessageReactionUpdate update) {
    final List<Message>? list = _messageCache[update.chatRoomId];
    if (list == null) return;

    final int messageIndex =
        list.indexWhere((Message m) => m.id == update.messageId);
    if (messageIndex < 0) return;

    final Message message = list[messageIndex];
    List<Reaction> reactions = List<Reaction>.from(message.reactions);

    if (update.isRemoved) {
      reactions.removeWhere(
        (Reaction r) =>
            r.id == update.messageReactionId ||
            (r.emoji == update.emoji &&
                r.user.id ==
                    (update.customerSupportId ?? update.customerId ?? '')),
      );
    } else {
      final int existingIndex = reactions.indexWhere(
        (Reaction r) => r.id == update.messageReactionId || r.emoji == update.emoji,
      );
      final Reaction mapped = Reaction(
        id: update.messageReactionId,
        user: User(
          id: update.customerSupportId ?? update.customerId ?? '',
          name: update.customerSupportName ?? 'Unknown',
          avatar: update.customerSupportAvatar ?? '',
        ),
        emoji: update.emoji,
        amount: update.amount,
      );
      if (existingIndex >= 0) {
        reactions[existingIndex] = mapped;
      } else {
        reactions.add(mapped);
      }
    }

    list[messageIndex] = message.copyWith(reactions: reactions);
    _notifyRoomChanged(update.chatRoomId);
  }

  void _handleDraftProgressSocket(SocketDraftResponseProgressEvent event) {
    final String? suggestion = event.extractPrimarySuggestionText();
    _draftProgressController.add(
      DraftResponseProgress(
        taskId: event.taskId,
        status: event.status,
        step: event.step,
        suggestionText: suggestion,
        errorMessage: event.status == 'failed' ? 'Draft generation failed' : null,
      ),
    );
  }

  @override
  Stream<Message> watchIncomingMessages() {
    _listenSocket();
    return _incomingMessagesController.stream;
  }

  @override
  Stream<MessageReactionUpdate> watchReactionUpdates() {
    _listenSocket();
    return _reactionController.stream;
  }

  @override
  Stream<ChatTypingEvent> watchCustomerTyping() {
    _listenSocket();
    return _customerTypingController.stream;
  }

  @override
  Stream<DraftResponseProgress> watchDraftProgress() {
    _listenSocket();
    return _draftProgressController.stream;
  }

  @override
  void emitTyping({
    required String chatRoomId,
    String? customerSupportId,
    String? fullname,
    String? profilePicture,
  }) {
    _socketService.emitTyping(
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
      fullname: fullname,
      profilePicture: profilePicture,
    );
  }

  @override
  void emitStopTyping({
    required String chatRoomId,
    String? customerSupportId,
  }) {
    _socketService.emitStopTyping(
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
    );
  }

  void _notifyRoomChanged(String roomId) {
    _messagesController.add(roomId);
  }

  /// Newest-first (`messageOrder` DESC) for reversed chat list (index 0 = latest).
  int _compareMessages(Message a, Message b) {
    final int byOrder = b.order.compareTo(a.order);
    if (byOrder != 0) return byOrder;
    return b.timestamp.compareTo(a.timestamp);
  }

  List<Message> _sortedCopy(List<Message> source) {
    final List<Message> sorted = List<Message>.of(source);
    sorted.sort(_compareMessages);
    return sorted;
  }

  void _handleMessage(Message message) {
    mergeMessage(
      roomId: message.conversationId,
      message: message,
    );
    _notifyRoomChanged(message.conversationId);
    _incomingMessagesController.add(message);
  }

  @override
  Stream<List<Message>> watchMessages(String roomId) {
    _listenSocket();
    return Stream<List<Message>>.multi((controller) {
      controller.add(_sortedCopy(_messageCache[roomId] ?? const <Message>[]));

      final sub = _messagesController.stream
          .where((changedRoomId) => changedRoomId == roomId)
          .listen((_) {
        controller.add(_sortedCopy(_messageCache[roomId] ?? const <Message>[]));
      });

      controller.onCancel = sub.cancel;
    });
  }
  
  @override
  bool hasMoreOlderMessages(String roomId) {
    return _hasMoreOlderByRoom[roomId] ?? true;
  }

  @override
  void resetMessageCache() {
    _messageCache.clear();
    _hasMoreOlderByRoom.clear();
  }

  @override
  Future<void> prefetchMessagesForRooms(Iterable<String> roomIds) async {
    final List<String> pending = roomIds.where((String id) {
      final List<Message>? cached = _messageCache[id];
      return cached == null || cached.isEmpty;
    }).toList(growable: false);

    for (int i = 0; i < pending.length; i += _prefetchConcurrency) {
      final int end = (i + _prefetchConcurrency).clamp(0, pending.length);
      await Future.wait(
        pending.sublist(i, end).map(_prefetchSingleRoom),
        eagerError: false,
      );
    }
  }

  Future<void> _prefetchSingleRoom(String roomId) async {
    try {
      final List<Message> messages = await getMessages(
        chatRoomId: roomId,
        limit: _pageSize,
      );
      _messageCache[roomId] = _sortedCopy(messages);
      _hasMoreOlderByRoom[roomId] = messages.length >= _pageSize;
      _notifyRoomChanged(roomId);
    } catch (_) {
      // Best-effort prefetch: a single failure must not block other rooms.
    }
  }

  @override
  Future<void> loadOlderMessages(String roomId) async {
    final List<Message>? list = _messageCache[roomId];
    if (list == null || list.isEmpty) return;
    if (!(_hasMoreOlderByRoom[roomId] ?? true)) return;

    final String oldestId = list.last.id;
    final List<Message> older = await getMessages(
      chatRoomId: roomId,
      lastMessageId: oldestId,
      limit: _pageSize,
    );

    if (older.isEmpty) {
      _hasMoreOlderByRoom[roomId] = false;
      return;
    }

    final Set<String> existingIds = list.map((Message m) => m.id).toSet();
    final List<Message> deduped = older
        .where((Message m) => !existingIds.contains(m.id))
        .toList(growable: false);

    if (deduped.isNotEmpty) {
      list.addAll(deduped);
    }
    list.sort(_compareMessages);
    _hasMoreOlderByRoom[roomId] = older.length >= _pageSize;
    _notifyRoomChanged(roomId);
  }

  @override
  Future<List<Message>> loadNewerMessages(String roomId) async {
    List<Message>? list = _messageCache[roomId];
    if (list == null || list.isEmpty) {
      await _prefetchSingleRoom(roomId);
      list = _messageCache[roomId];
      if (list == null || list.isEmpty) {
        return const <Message>[];
      }
    }

    final String newestId = list.first.id;
    if (newestId.isEmpty) {
      return const <Message>[];
    }

    final List<Message> newer = await getNewerMessages(
      chatRoomId: roomId,
      lastMessageId: newestId,
      limit: _pageSize,
    );
    if (newer.isEmpty) {
      return const <Message>[];
    }

    final Set<String> existingIds = list.map((Message m) => m.id).toSet();
    final List<Message> deduped = newer
        .where((Message m) => m.id.isNotEmpty && !existingIds.contains(m.id))
        .toList(growable: false);

    if (deduped.isEmpty) {
      return const <Message>[];
    }

    list.insertAll(0, deduped);
    list.sort(_compareMessages);
    _notifyRoomChanged(roomId);
    return deduped;
  }

  @override
  void mergeMessage({
    required String roomId,
    required Message message,
  }) {
    final List<Message> list = _messageCache.putIfAbsent(
      roomId,
      () => <Message>[],
    );

    if (list.isEmpty || message.order > list.first.order) {
      list.insert(0, message);
      _notifyRoomChanged(roomId);
      return;
    }

    final int existingIndex = list.indexWhere((Message m) => m.id == message.id);
    if (existingIndex >= 0) {
      list[existingIndex] = message;
      _notifyRoomChanged(roomId);
      return;
    }

    final int insertIndex =
        list.indexWhere((Message m) => m.order < message.order);
    if (insertIndex == -1) {
      list.add(message);
    } else {
      list.insert(insertIndex, message);
    }
    _notifyRoomChanged(roomId);
  }

  @override
  Future<List<Message>> getMessages({
    String? chatRoomId,
    String? customerId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    try {
      final dto = await _chatApi.getMessageList(
        chatRoomId: chatRoomId,
        customerId: customerId,
        lastMessageId: lastMessageId,
        limit: limit,
      );
      final List<Message> messages =
          dto.messages.map((e) => e.toDomain(dto.entities)).whereType<Message>().toList();
      messages.sort(_compareMessages);
      return messages;
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<List<Message>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    try {
      final dto = await _chatApi.getNewerMessages(
        chatRoomId: chatRoomId,
        lastMessageId: lastMessageId,
        limit: limit,
      );
      final List<Message> messages =
          dto.messages.map((e) => e.toDomain(dto.entities)).whereType<Message>().toList();
      messages.sort(_compareMessages);
      return messages;
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<Message> sendMessageFromAgentToCustomer({
    required SendAgentToCustomerMessageParams params,
  }) async {
    try {
      final dto = await _chatApi.sendMessageFromAgentToCustomer(
        params: SendCsMessageToCustomerParams(
          chatRoomId: params.chatRoomId,
          channelId: params.channelId,
          contactId: params.contactId,
          ticketId: params.ticketId,
          content: params.content,
          groupId: params.groupId,
          replyMessageId: params.replyMessageId,
          socketId: params.socketId,
          files: _mapAttachmentsToDto(params.attachments),
        ),
      );
      return dto.toDomain(null)!;
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<Reaction> reactToMessage(ReactToMessageRequest request) async {
    try {
      final dto = await _chatApi.reactToMessage(params: _mapReactParams(request));
      return dto.toDomain();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<bool> unreactToMessage(ReactToMessageRequest request) async {
    try {
      return await _chatApi.unreactMessage(params: _mapReactParams(request));
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<int> countSearchResultsInChatRoom({
    required String chatRoomId,
    required String keyword,
  }) async {
    try {
      return await _chatApi.countSearchResultsInChatRoom(
        chatRoomId: chatRoomId,
        keyword: keyword,
      );
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<List<MessageGroup>> searchMessagesGroupedByChatRoom({
    required String keyword,
  }) async {
    try {
      final groups = await _chatApi.searchMessagesGroupedByChatRoom(
        keyword: keyword,
      );
      return groups.map((e) => e.toDomain()).toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<List<Message>> flatSearchMessageList({
    required String chatRoomId,
    required String keyword,
  }) async {
    try {
      final messages = await _chatApi.flatSearchMessageList(
        chatRoomId: chatRoomId,
        keyword: keyword,
      );
      return messages.map((e) => e.toDomain(null)).whereType<Message>().toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<Map<String, dynamic>> analyzeTicketInChatRoomAi({
    required String chatRoomId,
    String? ticketId,
  }) async {
    try {
      return await _chatApi.analyzeTicketInChatRoomAi(
        chatRoomId: chatRoomId,
        ticketId: ticketId,
      );
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<Map<String, dynamic>> generateAiDraftResponse({
    required String chatRoomId,
    String? ticketId,
  }) async {
    try {
      return await _chatApi.generateAiDraftResponse(
        chatRoomId: chatRoomId,
        ticketId: ticketId,
      );
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }
}

extension MessageMapper on MessageDto {
  Message? toDomain(MessageEntitiesDto? entities) {
    if (contentInfo.isEmpty) {
      return null;
    }
    final isMe = isMeFromMessageType(messageType);
    final channelName = getChannelName(messageType);
    final contentInfoDto = ContentInfoDtoMapper.fromJson(contentInfo, channelName);

    final messageContent = files.isNotEmpty ? (isMeFromMessageType(messageType) ? 'Sent an attachment' : 'Received an attachment') : contentInfoDto.map(
      messenger: (m) => m.content,
      zalo: (z) => z.content,
      unknown: (u) => 'Unknown',
    );
  
    User senderUser;

    if (sender != null) {
      // sender is a customer support
      final senderUserInfo = entities?.senders[sender!] ?? senderInfo;
      if (senderUserInfo == null) {
        senderUser = const User(id: '', name: 'Unknown', avatar: '');
      } else {
        senderUser = User(id: senderUserInfo.customerSupportId, name: senderUserInfo.fullname, avatar: senderUserInfo.avatar ?? senderUserInfo.profilePicture);
      }
    } else {
      // sender is a customer or the channel
      if (isMe) {
        // sender is the channel
        final channelInfo = entities?.channels[channelId] ?? this.channelInfo;
        final channelName = channelInfo!.name;
        final channelAvatarUrl = channelInfo.config[channelName == 'MESSENGER' ? 'MESSENGER_FANPAGE_IMAGE' : 'ZALO_PROFILE_AVATAR'] as String?;
        senderUser = User(id: channelId, name: channelName, avatar: channelAvatarUrl);
      } else {
        // sender is a customer
        senderUser = contactInfo.map(
          messenger: (m) => User(id: m.contactId, name: m.messengerAccountName, avatar: m.messengerAccountAvatar),
          zalo: (z) => User(id: z.contactId, name: z.zaloAccountName, avatar: z.zaloAccountAvatar),
          phone: (p) => User(id: p.contactId, name: 'Unknown', avatar: ''),
          unknown: (u) => const User(id: '', name: 'Unknown', avatar: ''),
        );
      }
    }

    final bool isZalo = messageType.contains('ZALO');
    final String? zaloMessageId = _resolveZaloMessageId(
      contentInfoDto: contentInfoDto,
      zaloCliMsgId: zaloCliMsgId,
    );
    final String? zaloAccountId = contactInfo.mapOrNull(
      zalo: (ZaloContactInfoDto z) =>
          z.zaloAccountId.isNotEmpty ? z.zaloAccountId : null,
    );

    return Message(
      id: messageId,
      conversationId: chatRoomId,
      order: messageOrder,
      sender: senderUser,
      isMe: isMe,
      content: messageContent,
      attachments: files.map((e) => e.toDomain()).toList(),
      timestamp: createdAt.toLocal(),
      replyMessageId: replyMessageId,
      replyPreview: _parseReplyPreview(replyMessage),
      reactions: reaction.map((e) => e.toDomain()).toList(),
      isZalo: isZalo,
      zaloMessageId: zaloMessageId,
      zaloAccountId: zaloAccountId,
    );
  }
}

String? _resolveZaloMessageId({
  required ContentInfoDto contentInfoDto,
  required String? zaloCliMsgId,
}) {
  final String? fromContent = contentInfoDto.mapOrNull(
    zalo: (ZaloContentInfoDto z) =>
        z.zaloMessageId.isNotEmpty ? z.zaloMessageId : null,
  );
  if (fromContent != null && fromContent.isNotEmpty) {
    return fromContent;
  }
  final String? cli = zaloCliMsgId?.trim();
  if (cli != null && cli.isNotEmpty) {
    return cli;
  }
  return null;
}

MessageReplyPreview? _parseReplyPreview(Map<String, dynamic> replyMessage) {
  if (replyMessage.isEmpty) {
    return null;
  }
  final String? messageId = replyMessage['messageID']?.toString();
  if (messageId == null || messageId.isEmpty) {
    return null;
  }

  final String messageType =
      (replyMessage['messageType'] ?? '').toString();
  final bool isMe = isMeFromMessageType(messageType);

  String content = '';

  final Object? contentInfo = replyMessage['contentInfo'];
  if (contentInfo is Map) {
    final Map<String, dynamic> info = contentInfo.cast<String, dynamic>();
    final String channel = messageType.contains('ZALO')
        ? 'ZALO'
        : messageType.contains('MESSENGER')
            ? 'MESSENGER'
            : 'UNKNOWN';
    final ContentInfoDto parsed =
        ContentInfoDtoMapper.fromJson(info, channel);
    content = parsed.map(
      messenger: (MessengerContentInfoDto m) => m.content,
      zalo: (ZaloContentInfoDto z) => z.content,
      unknown: (_) => '',
    );
  }

  String senderName = 'Unknown';
  final Object? contactInfo = replyMessage['contactInfo'];
  if (contactInfo is Map) {
    final Map<String, dynamic> c = contactInfo.cast<String, dynamic>();
    if (c['zaloAccountName'] != null) {
      senderName = c['zaloAccountName'].toString();
    } else if (c['messengerAccountName'] != null) {
      senderName = c['messengerAccountName'].toString();
    }
  }
  if (replyMessage['sender'] != null) {
    senderName = 'Agent';
  }

  return MessageReplyPreview(
    messageId: messageId,
    senderName: senderName,
    content: content,
    isMe: isMe,
  );
}

String getChannelName(String messageType) {
  if (messageType.contains('MESSENGER')) return 'MESSENGER';
  if (messageType.contains('ZALO')) return 'ZALO';
  return 'UNKNOWN';
}

bool isMeFromMessageType(String type) {
  if (type.contains('_TO_CUSTOMER')) return true;

  return false;
}

extension AttachmentMapper on FileAttachmentDto {
  Attachment toDomain() {
    return Attachment(url: url, name: name, type: _parseType(type, name));
  }
}

AttachmentType _parseType(String mime, String fileName) {
  final lower = mime.toLowerCase();

  if (lower.startsWith('image')) return AttachmentType.image;
  if (lower.startsWith('sticker')) return AttachmentType.sticker;
  if (lower.startsWith('video')) return AttachmentType.video;
  if (lower.startsWith('audio')) return AttachmentType.audio;

  if (lower == 'application/pdf') return AttachmentType.pdf;

  if (lower.contains('word') ||
      lower.contains('officedocument') ||
      lower.contains('msword')) {
    return AttachmentType.document;
  }

  if (lower.contains('zip') || lower.contains('rar')) {
    return AttachmentType.archive;
  }

  final ext = fileName.split('.').last.toLowerCase();

  if (['png', 'jpg', 'jpeg'].contains(ext)) return AttachmentType.image;
  if (ext == 'pdf') return AttachmentType.pdf;

  return AttachmentType.unknown;
}

List<FileAttachmentDto> _mapAttachmentsToDto(List<Attachment>? attachments) {
  if (attachments == null || attachments.isEmpty) {
    return const <FileAttachmentDto>[];
  }
  return attachments
      .map(
        (Attachment a) => FileAttachmentDto(
          url: a.url,
          type: a.type.name,
          name: a.name,
        ),
      )
      .toList(growable: false);
}

ReactMessageParams _mapReactParams(ReactToMessageRequest request) {
  return ReactMessageParams(
    messageId: request.messageId,
    zaloMessageId: request.zaloMessageId,
    reactIcon: request.reactIcon,
    zaloAccountId: request.zaloAccountId,
    chatRoomId: request.chatRoomId,
    socketId: request.socketId,
    channelId: request.channelId,
  );
}

extension ReactionMapper on MessageReactionDto {
  Reaction toDomain() {
    return Reaction(
      id: messageReactionId,
      user: User(
        id: customerId ?? customerSupportId ?? '',
        name: customerName ?? customerSupportName ?? 'Unknown',
        avatar: customerSupportAvatar ?? customerAvatar ?? ''
        ),
      emoji: emoji,
      amount: amount,
    );
  }
}

extension MessageGroupMapper on MessageGroupDto {
  MessageGroup toDomain() {
    return MessageGroup(
      date: date,
      messages: messages.map((m) => m.toDomain(null)).whereType<Message>().toList(),
    );
  }
}
