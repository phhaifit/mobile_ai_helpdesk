import 'package:ai_helpdesk/data/network/apis/chat/models/chat_room_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/contact_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/customer_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/file_attachment_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_group_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_reaction_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/seen_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/fetch_chat_rooms_params.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/react_message_params.dart';
import 'package:ai_helpdesk/domain/entity/chat/attachment.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/entity/chat/message.dart' show Message;
import 'package:ai_helpdesk/domain/entity/chat/message_group.dart';
import 'package:ai_helpdesk/domain/entity/chat/reaction.dart';
import 'package:ai_helpdesk/domain/entity/chat/seen_info.dart';
import 'package:ai_helpdesk/domain/entity/chat/user.dart' show User;
import 'package:ai_helpdesk/domain/repository/chat/chat_repository.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';

ReactMessageParams mapReactParams(ReactToMessageRequest request) {
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

extension MessageMapper on MessageDto {
  Message toDomain() {
    return Message(
      id: messageId,
      conversationId: chatRoomId,
      sender: User(id: sender ?? '', name: sender ?? '', avatar: ''),
      isMe: isMeFromMessageType(messageType),
      content: contentInfo['content'] as String? ?? '',
      attachments: files.map((e) => e.toDomain()).toList(),
      timestamp: createdAt,
      replyMessageId: replyMessageId,
      reactions: reaction.map((e) => e.toDomain()).toList(),
    );
  }
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

extension ReactionMapper on MessageReactionDto {
  Reaction toDomain() {
    return Reaction(
      id: messageReactionId,
      user: User(
        id: customerId ?? customerSupportId ?? '',
        name: customerInfo?.name ?? customerSupportInfo?.fullname ?? '',
        avatar: customerSupportInfo?.avatar ?? _avatarUrlFromCustomer(customerInfo)
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
      messages: messages.map((m) => m.toDomain()).toList(),
    );
  }
}

extension SeenInfoMapper on SeenInfoDto {
  SeenInfo toDomain() {
    return SeenInfo(
      chatRoomSeenId: chatRoomSeenId,
      chatRoomId: chatRoomId,
      customerSupportId: customerSupportId,
      messageId: messageId,
      messageOrder: messageOrder,
      numberMessageSeen: numberMessageSeen,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

FetchChatRoomsParams mapQuery(ChatRoomListQuery q) {
  return FetchChatRoomsParams(
    customerName: q.customerName,
    limit: q.limit,
    lastMessageId: q.lastMessageId,
    lastChatRoomId: q.lastChatRoomId,
    lastChatRoomUpdatedAt: q.lastChatRoomUpdatedAt,
    status: q.status,
    statuses: q.statuses,
    channels: q.channels,
    channelIds: q.channelIds,
    updatedAtFrom: q.updatedAtFrom,
    updatedAtTo: q.updatedAtTo,
    getCounter: q.getCounter,
    getAll: q.getAll,
  );
}

extension ChatRoomMapper on ChatRoomDto {
  ChatRoom toDomain() {
    final bool isGroup = groupId != null;
    final String name = isGroup ? groupInfo?.displayName ?? '' : customerInfo?.name ?? '';
    final String avatarUrl = isGroup ? groupInfo?.avatar ?? '' : _avatarUrlFromCustomer(customerInfo);

    return ChatRoom(
      id: chatRoomId,
      name: name,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage?.contentInfo['content'] as String? ?? '',
      lastMessageIsMe: lastMessage?.sender == customerId,
      lastMessageTime: lastMessage?.createdAt ?? DateTime.now(),
      unreadCount: totalMessage - seenMessageOrder,
      isActive: true,
      isAI: false,
    );
  }
}

String _avatarUrlFromCustomer(CustomerInfoDto? customerInfo) {
  final contacts = customerInfo?.contactInfo;
  if (contacts == null || contacts.isEmpty) return '';
  return _avatarUrlFromContact(contacts);
}

String _avatarUrlFromContact(List<ContactInfoDto> contacts) {
  for (final contact in contacts) {
    final avatar = contact.map(
      messenger: (m) => m.messengerAccountAvatar,
      zalo: (z) => z.zaloAccountAvatar,
      phone: (p) => '',
      unknown: (u) => '',
    );
    if (avatar.isNotEmpty) return avatar;
  }
  return '';
}
