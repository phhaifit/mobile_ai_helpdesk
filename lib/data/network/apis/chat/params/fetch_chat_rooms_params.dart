class FetchChatRoomsParams {
  final String? customerName;
  final int limit;
  final String? lastMessageId;
  final String? lastChatRoomId;
  final String? lastChatRoomUpdatedAt;
  final String? status;
  final List<String>? statuses;
  final List<String>? channels;
  final List<String>? channelIds;
  final bool getCounter;
  final bool getAll;

  FetchChatRoomsParams({
    this.customerName,
    this.limit = 20,
    this.lastMessageId,
    this.lastChatRoomId,
    this.lastChatRoomUpdatedAt,
    this.status,
    this.statuses,
    this.channels,
    this.channelIds,
    this.getCounter = false,
    this.getAll = false,
  });

  Map<String, dynamic> toJson() {
    return {
      if (customerName != null) 'customerName': customerName,
      'limit': limit,
      if (lastMessageId != null) 'lastMessageID': lastMessageId,
      if (lastChatRoomId != null) 'lastChatRoomID': lastChatRoomId,
      if (lastChatRoomUpdatedAt != null) 'lastChatRoomUpdatedAt': lastChatRoomUpdatedAt,
      if (status != null) 'status': status,
      if (statuses != null && statuses!.isNotEmpty) 'statuses': statuses,
      if (channels != null && channels!.isNotEmpty) 'channel': channels,
      if (channelIds != null && channelIds!.isNotEmpty) 'channelIDs': channelIds,
      'getCounter': getCounter,
      'getAll': getAll,
    };
  }
}