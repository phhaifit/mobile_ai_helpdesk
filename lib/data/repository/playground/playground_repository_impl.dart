import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/data/local/datasources/playground/playground_datasource.dart';
import '/data/network/apis/ai_agent/ai_agent_api.dart';
import '/data/network/apis/playground/playground_api.dart';
import '/data/network/models/request/ask_question_request.dart';
import '/data/network/models/request/chat_message.dart';
import '/data/network/models/request/draft_response_request.dart';
import '/data/sharedpref/shared_preference_helper.dart';
import '/domain/entity/playground/playground_message.dart';
import '/domain/entity/playground/playground_session.dart';
import '/domain/repository/playground/playground_repository.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  static const String _draftSeparator = '\n<<<DRAFT_SPLIT>>>\n';

  final PlaygroundDataSource _dataSource;
  final AiAgentApi _aiAgentApi;
  final PlaygroundApi _api;
  final SharedPreferenceHelper _prefs;

  PlaygroundRepositoryImpl(
    this._dataSource,
    this._aiAgentApi,
    this._api,
    this._prefs,
  );

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

  Future<String> _requireActiveAgentId(String tenantId) async {
    final json = await _aiAgentApi.getAgentByTenant(tenantId);
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    if (id.isEmpty) {
      throw Exception('Active AI Agent id is missing from tenant response.');
    }
    return id;
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
  ) => _dataSource.createSession(contextType, agentId);

  @override
  Future<PlaygroundMessage> sendMessage(
    String sessionId,
    String content,
    List<String> attachments,
  ) async {
    // 1. Fetch the session to validate it exists.
    final session = await _dataSource.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final tenantId = await _requireTenantId();
    final activeAgentId = await _requireActiveAgentId(tenantId);

    // 2. Build chat history from current session messages.
    final history =
        session.messages
            .map((m) => ChatMessage(role: m.role.name, content: m.content))
            .toList();

    // 3. Call playground/chat API then persist messages locally.
    try {
      final realText = await _api.askAgent(
        activeAgentId,
        AskQuestionRequest(question: content, chatHistory: history),
      );

      return await _dataSource.sendMessage(
        sessionId,
        content,
        attachments,
        assistantResponse: realText,
      );
    } on DioException catch (e) {
      if (_isInternalServerError(e)) {
        debugPrint(
          '[PlaygroundRepository] sendMessage fallback to local datasource '
          'because API returned 500.',
        );
        return _dataSource.sendMessage(
          sessionId,
          content,
          attachments,
          assistantResponse:
              'Xin lỗi, hệ thống đang bận. Tin nhắn đã được lưu cục bộ.',
        );
      }
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  @override
  Future<PlaygroundMessage> editMessage(
    String sessionId,
    String messageId,
    String newContent,
  ) => _dataSource.editMessage(sessionId, messageId, newContent);

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
      if (_isInternalServerError(e)) {
        debugPrint(
          '[PlaygroundRepository] getDraftResponse fallback with local drafts '
          'because API returned 500.',
        );
        return _buildLocalDraftFallback(params);
      }
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
    try {
      yield* _api.streamDraftResponse(tenantId, req);
    } on DioException catch (e) {
      if (_isInternalServerError(e)) {
        debugPrint(
          '[PlaygroundRepository] streamDraftResponse fallback with empty '
          'stream because API returned 500.',
        );
        return;
      }
      rethrow;
    }
  }

  bool _isInternalServerError(DioException e) => e.response?.statusCode == 500;

  String _buildLocalDraftFallback(DraftResponseParams params) {
    final latestUserMessage = params.chatHistory.reversed.firstWhere(
      (item) => (item['role'] ?? '').toLowerCase() == 'user',
      orElse: () => const <String, String>{},
    )['content']?.trim();
    final summary =
        (latestUserMessage == null || latestUserMessage.isEmpty)
            ? 'vấn đề của bạn'
            : latestUserMessage;

    final drafts = <String>[
      'Chào bạn, mình đã nhận được thông tin về "$summary". Mình sẽ kiểm tra và phản hồi chi tiết cho bạn trong ít phút nhé.',
      'Cảm ơn bạn đã chia sẻ về "$summary". Để hỗ trợ nhanh hơn, bạn vui lòng cho mình thêm mã đơn hoặc ảnh liên quan nếu có.',
      'Mình rất tiếc vì bất tiện liên quan đến "$summary". Mình đã ghi nhận và đang ưu tiên xử lý để cập nhật kết quả sớm nhất cho bạn.',
    ];
    return drafts.join(_draftSeparator);
  }

  DraftResponseRequest _toRequest(
    DraftResponseParams params,
    String tenantId,
  ) => DraftResponseRequest(
    chatHistory:
        params.chatHistory
            .map(
              (m) => ChatMessage(
                role: m['role'] ?? '',
                content: m['content'] ?? '',
              ),
            )
            .toList(),
    channel: params.channel,
    type: params.type,
    defaultConfigType:
        params.defaultConfigType
            .map((item) => <String, dynamic>{'value': item})
            .toList(),
    tenantID: tenantId,
    ticketID: params.ticketID,
    chatRoomID: params.chatRoomID,
    customerID: params.customerID,
    channelProfileOverrides: params.channelProfileOverrides,
  );
}
