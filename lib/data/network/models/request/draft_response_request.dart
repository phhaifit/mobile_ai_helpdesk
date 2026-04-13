import 'chat_message.dart';

/// Request body for POST /api/v1/ai-agents/{tenantId}/draft-response
/// and POST /api/v1/ai-agents/{tenantId}/draft-response/stream
/// Maps to DraftResponseDto on the backend.
class DraftResponseRequest {
  final List<ChatMessage> chatHistory;
  final String channel;
  final String type;
  final List<String> defaultConfigType;
  final String tenantID;
  final String ticketID;
  final String chatRoomID;
  final String customerID;
  final Map<String, dynamic>? channelProfileOverrides;

  const DraftResponseRequest({
    required this.chatHistory,
    required this.channel,
    required this.type,
    required this.defaultConfigType,
    required this.tenantID,
    required this.ticketID,
    required this.chatRoomID,
    required this.customerID,
    this.channelProfileOverrides,
  });

  Map<String, dynamic> toJson() => {
        'chatHistory': chatHistory.map((m) => m.toJson()).toList(),
        'channel': channel,
        'type': type,
        'defaultConfigType': defaultConfigType,
        'tenantID': tenantID,
        'ticketID': ticketID,
        'chatRoomID': chatRoomID,
        'customerID': customerID,
        if (channelProfileOverrides != null)
          'channelProfileOverrides': channelProfileOverrides,
      };
}
