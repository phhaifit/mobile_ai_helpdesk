import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';

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
}
