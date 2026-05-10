import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/content_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/file_attachment_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_entities_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_group_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_reaction_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/react_message_params.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/send_cs_message_to_customer_params.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart' show Message;
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/entity/chat/user.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/react_to_message_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/chat/chat_detail/send_message_from_agent_to_customer_usecase.dart';
import 'package:dio/dio.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi _chatApi;

  ChatRepositoryImpl(this._chatApi);

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
      return dto.messages.map((e) => e.toDomain(dto.entities)).toList();
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
      return dto.messages.map((e) => e.toDomain(dto.entities)).toList();
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
        ),
      );
      return dto.toDomain(null);
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
    required String keyword,
    String? chatRoomId,
  }) async {
    try {
      final dto = await _chatApi.flatSearchMessageList(
        keyword: keyword,
        chatRoomId: chatRoomId,
      );
      return dto.messages.map((e) => e.toDomain(dto.entities)).toList();
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
  Message toDomain(MessageEntitiesDto? entities) {
    final isMe = isMeFromMessageType(messageType);
    final channelName = getChannelName(messageType);
    final contentInfoDto = ContentInfoDtoMapper.fromJson(contentInfo, channelName);
  
    User senderUser;

    if (sender != null) {
      // sender is a customer support
      final senderUserInfo = entities?.senders[sender];
      senderUser = User(id: senderUserInfo?.customerSupportId ?? '', name: senderUserInfo?.fullname ?? '', avatar: senderUserInfo?.avatar ?? '');
    } else {
      // sender is a customer or the channel
      if (isMe) {
        // sender is the channel
        final channelInfo = entities?.channels[channelId];
        final channelName = channelInfo?['name'] as String;
        final channelAvatarUrl = channelInfo?['config'][channelName == 'MESSENGER' ? 'MESSENGER_FANPAGE_IMAGE' : 'ZALO_PROFILE_AVATAR'] as String?;
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

    return Message(
      id: messageId,
      conversationId: chatRoomId,
      order: messageOrder,
      sender: senderUser,
      isMe: isMe,
      content: contentInfoDto.map(
        messenger: (m) => m.content,
        zalo: (z) => z.content,
        unknown: (u) => '',
      ),
      attachments: files.map((e) => e.toDomain()).toList(),
      timestamp: createdAt,
      replyMessageId: replyMessageId,
      reactions: reaction.map((e) => e.toDomain()).toList(),
    );
  }
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

  if (lower.startsWith('image/')) return AttachmentType.image;
  if (lower.startsWith('sticker/')) return AttachmentType.sticker;
  if (lower.startsWith('video/')) return AttachmentType.video;
  if (lower.startsWith('audio/')) return AttachmentType.audio;

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
      messages: messages.map((m) => m.toDomain(null)).toList(),
    );
  }
}
