import 'package:dio/dio.dart';

import '/data/local/datasources/playground/playground_datasource.dart';
import '/data/network/apis/playground/playground_api.dart';
import '/data/network/models/request/chat_completion_request.dart';
import '/data/network/models/request/chat_message.dart';
import '/data/network/models/request/draft_response_request.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  final PlaygroundDataSource _dataSource;
  final PlaygroundApi _api;

  PlaygroundRepositoryImpl(this._dataSource, this._api);

  @override
  Future<List<PlaygroundSession>> getSessions() => _dataSource.getSessions();

  @override
  Future<PlaygroundSession?> getSessionById(String id) =>
      _dataSource.getSessionById(id);

  @override
  Future<PlaygroundSession> createSession(
    PlaygroundContextType contextType,
    String? agentId,
  ) =>
      _dataSource.createSession(contextType, agentId);

  @override
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
  ) async {
    // 1. Add user message locally and get a placeholder AI message.
    final mockAiMsg =
        await _dataSource.sendMessage(sessionId, content, attachments);

    // 2. Fetch the session to get agentId for the API call.
    final session = await _dataSource.getSessionById(sessionId);
    if (session?.agentId == null) {
      // No agent linked — return the mock response as fallback.
      return mockAiMsg;
    }

    // 3. Build chat history from session messages (excluding the placeholder).
    final history = session!.messages
        .where((m) => m.id != mockAiMsg.id)
        .map((m) => ChatMessage(role: m.role.name, content: m.content))
        .toList();

    // 4. Call real API.
    try {
      final realText = await _api.chatComplete(
        session.agentId!,
        ChatCompletionRequest(prompt: content, chatHistory: history),
      );
      // 5. Replace placeholder AI message content with real response.
      return await _dataSource.editMessage(
        sessionId,
        mockAiMsg.id,
        realText.isNotEmpty ? realText : mockAiMsg.content,
      );
    } on DioException {
      // Network error — return the mock response so the UI doesn't break.
      return mockAiMsg;
    }
  }

  @override
  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  ) =>
      _dataSource.editMessage(sessionId, messageId, newContent);

  @override
  Future<String> getDraftResponse(DraftResponseParams params) async {
    final req = _toRequest(params);
    try {
      return await _api.getDraftResponse(params.tenantID, req);
    } on DioException catch (e) {
      throw Exception('Failed to get draft response: ${e.message}');
    }
  }

  @override
  Stream<String> streamDraftResponse(DraftResponseParams params) {
    final req = _toRequest(params);
    return _api.streamDraftResponse(params.tenantID, req);
  }

  DraftResponseRequest _toRequest(DraftResponseParams params) =>
      DraftResponseRequest(
        chatHistory: params.chatHistory
            .map((m) => ChatMessage(
                  role: m['role'] ?? '',
                  content: m['content'] ?? '',
                ))
            .toList(),
        channel: params.channel,
        type: params.type,
        defaultConfigType: params.defaultConfigType,
        tenantID: params.tenantID,
        ticketID: params.ticketID,
        chatRoomID: params.chatRoomID,
        customerID: params.customerID,
        channelProfileOverrides: params.channelProfileOverrides,
      );
}
