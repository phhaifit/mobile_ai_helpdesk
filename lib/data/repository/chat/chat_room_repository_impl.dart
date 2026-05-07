import 'package:ai_helpdesk/data/network/apis/chat/chat_api.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/chat_room_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/contact_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/customer_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/models/seen_info_dto.dart';
import 'package:ai_helpdesk/data/network/apis/chat/params/fetch_chat_rooms_params.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';
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
    final String name = isGroup ? groupInfo?.displayName ?? '' : customerInfo?.name ?? '';
    final String avatarUrl = isGroup ? groupInfo?.avatar ?? '' : _avatarUrlFromCustomer(customerInfo);
    final String appName = (defaultChannel?['appInfo']['type'] as String).contains('MESSENGER') ? 'MESSENGER' : 'ZALO';
    final String appAvatarUrl = appName == 'MESSENGER' ? 'https://helpdesk.jarvis.cx/images/messenger_colored.png' : 'https://helpdesk.jarvis.cx/images/zalo_colored.png';
    
    final channelId = defaultChannel?['channelID'] as String;
    final channelName = defaultChannel?['name'] as String;
    final channelAvatarUrl = defaultChannel?['config'][appName == 'MESSENGER' ? 'MESSENGER_FANPAGE_IMAGE' : 'ZALO_PROFILE_AVATAR'] as String;

    return ChatRoom(
      id: chatRoomId,
      name: name,
      avatarUrl: avatarUrl,
      appAvatarUrl: appAvatarUrl,
      lastMessage: lastMessage?.contentInfo['content'] as String? ?? '',
      lastMessageIsMe: lastMessage?.sender == customerId,
      lastMessageTime: lastMessage?.createdAt ?? DateTime.now(),
      unreadCount: totalMessage - seenMessageOrder,
      channel: Channel(id: channelId, name: channelName, avatarUrl: channelAvatarUrl),
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