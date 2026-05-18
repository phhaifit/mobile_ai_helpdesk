import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';

/// Parameters for draft response API calls.
/// Defined in domain layer — no data-layer imports.
class DraftResponseParams {
  final List<Map<String, String>> chatHistory;
  final String channel;
  final String type;
  final List<String> defaultConfigType;
  final String tenantID;
  final String ticketID;
  final String chatRoomID;
  final String customerID;
  final Map<String, dynamic>? channelProfileOverrides;

  const DraftResponseParams({
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
}

abstract class PlaygroundRepository {
  Future<List<PlaygroundSession>> getSessions();
  Future<PlaygroundSession?> getSessionById(String id);
  Future<PlaygroundSession> createSession(PlaygroundContextType contextType, String? agentId);
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
  );
  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  );
  Future<String> getDraftResponse(DraftResponseParams params);
  Stream<String> streamDraftResponse(DraftResponseParams params);
}
