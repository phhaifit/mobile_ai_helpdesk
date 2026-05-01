import 'package:dio/dio.dart';

import '/data/local/datasources/playground/playground_datasource.dart';
import '/data/network/apis/playground/playground_api.dart';
import '/data/network/models/request/chat_completion_request.dart';
import '/data/network/models/request/chat_message.dart';
import '/data/network/models/request/draft_response_request.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  final PlaygroundDataSource _dataSource;
  final PlaygroundApi _api;
  final SharedPreferenceHelper _prefs;

  PlaygroundRepositoryImpl(this._dataSource, this._api, this._prefs);

  Future<String?> _resolveTenantId() async {
    final id = (await _prefs.tenantId)?.trim();
    if (id == null || id.isEmpty) {
      return null;
    }
    return id;
  }

  Future<String> _requireTenantId() async {
    final tenantId = await _resolveTenantId();
    if (tenantId == null) {
      throw Exception('Tenant ID is required to call draft response APIs.');
    }
    return tenantId;
  }

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
    // 1. Fetch the session to get agentId for the API call.
    final session = await _dataSource.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.agentId == null) {
      throw Exception('Session does not have an assigned AI Agent.');
    }

    // 2. Build chat history from current session messages.
    final history = session.messages
        .map((m) => ChatMessage(role: m.role.name, content: m.content))
        .toList();

    // 3. Call real API then persist messages locally.
    try {
      final realText = await _api.chatComplete(
        session.agentId!,
        ChatCompletionRequest(prompt: content, chatHistory: history),
      );

      return await _dataSource.sendMessage(
        sessionId,
        content,
        attachments,
        assistantResponse: realText,
      );
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
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
    final tenantId =
        params.tenantID.trim().isNotEmpty
            ? params.tenantID
            : await _requireTenantId();
    final req = _toRequest(params, tenantId);
    try {
      return await _api.getDraftResponse(tenantId, req);
    } on DioException catch (e) {
      throw Exception('Failed to get draft response: ${e.message}');
    }
  }

  @override
  Stream<String> streamDraftResponse(DraftResponseParams params) async* {
    final tenantId =
        params.tenantID.trim().isNotEmpty
            ? params.tenantID
            : await _requireTenantId();
    final req = _toRequest(params, tenantId);
    yield* _api.streamDraftResponse(tenantId, req);
  }

  DraftResponseRequest _toRequest(DraftResponseParams params, String tenantId) =>
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
        tenantID: tenantId,
        ticketID: params.ticketID,
        chatRoomID: params.chatRoomID,
        customerID: params.customerID,
        channelProfileOverrides: params.channelProfileOverrides,
      );
}
