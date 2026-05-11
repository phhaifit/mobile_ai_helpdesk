import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/chat_room_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/contact_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/customer_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/message_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/seen_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/fetch_chat_rooms_params.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';
import 'package:ai_helpdesk/data/repository/chat/chat_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/chat/channel.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room.dart';
import 'package:ai_helpdesk/domain/entity/chat/chat_room_counter.dart';
import 'package:ai_helpdesk/domain/entity/chat/seen_info.dart';
import 'package:ai_helpdesk/domain/repository/chat/chat_room_repository.dart';
import 'package:dio/dio.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatApi _chatApi;

  ChatRoomRepositoryImpl(this._chatApi);

  @override
  Future<List<ChatRoom>> getChatRooms({
    ChatRoomListQuery query = ChatRoomListQuery.inboxDefault,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomList(params: mapQuery(query));

      return dto.map((e) => e.toDomain()).toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<ChatRoomCounter> getChatRoomCounters({
    String? customerName,
    bool getAll = false,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomCounters(
        customerName: customerName,
        getAll: getAll,
      );
      return ChatRoomCounter(
        open: dto.open,
        pending: dto.pending,
        solved: dto.solved,
        closed: dto.closed,
      );
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<List<ChatRoom>> getChatRoomDetail({
    String? chatRoomId,
    String? customerId,
  }) async {
    try {
      final dto = await _chatApi.getChatRoomDetail(
        chatRoomId: chatRoomId,
        customerId: customerId,
      );
      return dto.map((e) => e.toDomain()).toList();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
  }

  @override
  Future<SeenInfo> markChatRoomAsSeen({
    required String chatRoomId,
    required String messageId,
    required int messageOrder,
    String? socketId,
  }) async {
    try {
      final dto = await _chatApi.markChatRoomAsSeen(
        chatRoomId: chatRoomId,
        messageId: messageId,
        messageOrder: messageOrder,
        socketId: socketId,
      );
      return dto.toDomain();
    } on DioException catch (e) {
      throw HelpdeskErrorMapper.map(e);
    }
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

    String name, avatarUrl, appName;

    if (isGroup) {
      name = groupInfo!.displayName;
      avatarUrl = groupInfo!.avatar;
      appName = _getAppName(groupInfo!.type);
    } else {
      name = customerInfo!.name;
      avatarUrl = _avatarUrlFromCustomer(customerInfo);
      appName = _getAppName(lastMessage?.channelInfo?.appInfo['type'] as String);
    }
    final String appAvatarUrl = appName == 'MESSENGER' ? 'https://helpdesk.jarvis.cx/images/messenger_colored.png' : 'https://helpdesk.jarvis.cx/images/zalo_colored.png';
    
    return ChatRoom(
      id: chatRoomId,
      name: name,
      avatarUrl: avatarUrl,
      appAvatarUrl: appAvatarUrl,
      ticketId: ticketId,
      contactId: lastMessage!.contactId,
      lastMessage: lastMessage!.toDomain(null)!,
      lastMessageTime: lastMessage?.createdAt.toLocal() ?? DateTime.now(),
      unreadCount: totalMessage - seenMessageOrder,
      channel: _parseChannelFromMessage(lastMessage!),
      isAI: false,
    );
  }
}

String _getAppName(String message) {
  if (message.contains('MESSENGER')) return 'MESSENGER';
  if (message.contains('ZALO')) return 'ZALO';
  return 'UNKNOWN';
}

Channel _parseChannelFromMessage(MessageDto message) {
  final channelId = message.channelInfo!.channelId;
  final channelName = message.channelInfo?.name ?? 'Unknown';
  final channelAvatarUrl = message.channelInfo?.config[_getAppName(message.channelInfo?.appInfo['type'] as String) == 'MESSENGER' ? 'MESSENGER_FANPAGE_IMAGE' : 'ZALO_PROFILE_AVATAR'] as String?;
  return Channel(id: channelId, name: channelName, avatarUrl: channelAvatarUrl);
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