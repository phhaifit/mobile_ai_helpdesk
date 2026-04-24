import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';

class ChatApi {
  final DioClient _dioClient;

  ChatApi(this._dioClient);

  Future<Map<String, dynamic>> getChatRoomList({
    String? customerName,
    int limit = 20,
    String? lastMessageId,
    String? lastChatRoomId,
    String? lastChatRoomUpdatedAt,
    String? status,
    List<String>? statuses,
    List<String>? channels,
    List<String>? channelIds,
    bool getCounter = false,
    bool getAll = false,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoom(),
      queryParameters: {
        if (customerName != null) 'customerName': customerName,
        'limit': limit,
        if (lastMessageId != null) 'lastMessageID': lastMessageId,
        if (lastChatRoomId != null) 'lastChatRoomID': lastChatRoomId,
        if (lastChatRoomUpdatedAt != null)
          'lastChatRoomUpdatedAt': lastChatRoomUpdatedAt,
        if (status != null) 'status': status,
        if (statuses != null && statuses.isNotEmpty) 'statuses': statuses,
        if (channels != null && channels.isNotEmpty) 'channel': channels,
        if (channelIds != null && channelIds.isNotEmpty) 'channelIDs': channelIds,
        'getCounter': getCounter,
        'getAll': getAll,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getChatRoomCounters({
    String? customerName,
    bool getAll = false,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoomCounter(),
      queryParameters: {
        if (customerName != null) 'customerName': customerName,
        'getAll': getAll,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getChatRoomDetail({
    String? chatRoomId,
    String? customerId,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.chatRoomDetail(),
      queryParameters: {
        if (chatRoomId != null) 'chatRoomID': chatRoomId,
        if (customerId != null) 'customerID': customerId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getMessageList({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.message(),
      queryParameters: {
        'chatRoomID': chatRoomId,
        if (lastMessageId != null) 'lastMessageID': lastMessageId,
        'limit': limit,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> getNewerMessages({
    required String chatRoomId,
    String? lastMessageId,
    int limit = 20,
  }) async {
    final res = await _dioClient.dio.get(
      Endpoints.newerMessage(),
      queryParameters: {
        'chatRoomID': chatRoomId,
        if (lastMessageId != null) 'lastMessageID': lastMessageId,
        'limit': limit,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> sendMessageFromAgentToCustomer({
    required String chatRoomId,
    required String channelId,
    required String contactId,
    required String content,
    String? replyMessageId,
    String? socketId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.csToCustomer(),
      data: {
        'chatRoomID': chatRoomId,
        'channelID': channelId,
        'contactID': contactId,
        'content': content,
        if (replyMessageId != null) 'replyMessageID': replyMessageId,
        if (socketId != null) 'socketID': socketId,
        'files': [],
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> markChatRoomAsSeen({
    required String chatRoomId,
    required String messageId,
    required int messageOrder,
    String? socketId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.chatRoomSeen(),
      data: {
        'chatRoomID': chatRoomId,
        'messageID': messageId,
        'messageOrder': messageOrder,
        if (socketId != null) 'socketID': socketId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> reactToMessage({
    required String messageId,
    required String zaloMessageId,
    required String reactIcon,
    required String zaloAccountId,
    required String chatRoomId,
    String? socketId,
    String? channelId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.reactToMessage(),
      data: {
        'messageID': messageId,
        'zaloMessageID': zaloMessageId,
        'reactIcon': reactIcon,
        'zaloAccountID': zaloAccountId,
        'chatRoomID': chatRoomId,
        if (socketId != null) 'socketID': socketId,
        if (channelId != null) 'channelID': channelId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> unreactMessage({
    required String messageId,
    required String zaloMessageId,
    required String reactIcon,
    required String zaloAccountId,
    required String chatRoomId,
    String? socketId,
    String? channelId,
  }) async {
    final res = await _dioClient.dio.post(
      Endpoints.unreactToMessage(),
      data: {
        'messageID': messageId,
        'zaloMessageID': zaloMessageId,
        'reactIcon': reactIcon,
        'zaloAccountID': zaloAccountId,
        'chatRoomID': chatRoomId,
        if (socketId != null) 'socketID': socketId,
        if (channelId != null) 'channelID': channelId,
      },
    );
    return (res.data as Map).cast<String, dynamic>();
  }
}

