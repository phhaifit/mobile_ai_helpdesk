import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';

/// In-memory datasource for playground session history.
class PlaygroundDataSource {
  final List<PlaygroundSession> _sessions = [];

  PlaygroundDataSource();

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<List<PlaygroundSession>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_sessions.reversed.toList());
  }

  Future<PlaygroundSession?> getSessionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<PlaygroundSession> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final session = PlaygroundSession(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      agentId: agentId,
      contextType: contextType,
      messages: [],
      createdAt: DateTime.now(),
    );
    _sessions.add(session);
    return session;
  }

  /// Appends a user message and the real assistant response.
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
    {
    required String assistantResponse,
  }
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx == -1) throw Exception('Session not found: $sessionId');

    final session = _sessions[idx];
    final now = DateTime.now();

    // User message
    final userMsg = PlaygroundMessage(
      id: 'msg-${now.millisecondsSinceEpoch}-u',
      content: content,
      role: MessageRole.user,
      attachments: attachments,
      timestamp: now,
    );

    final aiMsg = PlaygroundMessage(
      id: 'msg-${now.millisecondsSinceEpoch}-a',
      content: assistantResponse,
      role: MessageRole.assistant,
      attachments: [],
      timestamp: now.add(const Duration(milliseconds: 50)),
    );

    final updatedMessages = [...session.messages, userMsg, aiMsg];
    _sessions[idx] = session.copyWith(messages: updatedMessages);

    return aiMsg;
  }

  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final sIdx = _sessions.indexWhere((s) => s.id == sessionId);
    if (sIdx == -1) throw Exception('Session not found: $sessionId');

    final session = _sessions[sIdx];
    final msgs = List<PlaygroundMessage>.from(session.messages);
    final mIdx = msgs.indexWhere((m) => m.id == messageId);
    if (mIdx == -1) throw Exception('Message not found: $messageId');

    final updated = msgs[mIdx].copyWith(content: newContent);
    msgs[mIdx] = updated;
    _sessions[sIdx] = session.copyWith(messages: msgs);
    return updated;
  }
}
