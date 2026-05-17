import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/models/request/ask_question_request.dart';
import '/data/network/models/request/chat_completion_request.dart';
import '/data/network/models/request/draft_response_request.dart';

class PlaygroundApi {
  final DioClient _dioClient;

  PlaygroundApi(this._dioClient);

  Future<String> askAgent(String agentId, AskQuestionRequest req) async {
    debugPrint('[PlaygroundApi] askAgent called');
    try {
      final response = await _dioClient.dio.post<dynamic>(
        Endpoints.agentAsk(agentId),
        data: req.toJson(),
      );
      return _extractText(response.data);
    } on DioException catch (e) {
      _logApiError('askAgent', e);
      rethrow;
    }
  }

  Future<String> chatComplete(String agentId, ChatCompletionRequest req) async {
    debugPrint('[PlaygroundApi] chatComplete called');
    try {
      final response = await _dioClient.dio.post<dynamic>(
        Endpoints.agentChatComplete(agentId),
        data: req.toJson(),
      );
      return _extractText(response.data);
    } on DioException catch (e) {
      _logApiError('chatComplete', e);
      rethrow;
    }
  }

  Future<String> getDraftResponse(
    String tenantId,
    DraftResponseRequest req,
  ) async {
    debugPrint('[PlaygroundApi] getDraftResponse called');
    try {
      final response = await _dioClient.dio.post<dynamic>(
        Endpoints.agentDraftResponse(tenantId),
        data: req.toJson(),
      );
      return _extractText(response.data);
    } on DioException catch (e) {
      _logApiError('getDraftResponse', e);
      rethrow;
    }
  }

  /// Returns a [Stream<String>] of text chunks via Server-Sent Events.
  /// The backend sends named events such as `draftResponseProgress` and
  /// `lastDraftResponseUpdate`, with JSON payloads in `data:` lines.
  Stream<String> streamDraftResponse(
    String tenantId,
    DraftResponseRequest req,
  ) {
    debugPrint('[PlaygroundApi] streamDraftResponse called');
    final controller = StreamController<String>();
    String? currentEvent;
    var emittedProgressText = false;

    _dioClient.dio
        .post<ResponseBody>(
          Endpoints.agentDraftResponseStream(tenantId),
          data: req.toJson(),
          options: Options(responseType: ResponseType.stream),
        )
        .then((response) {
          response.data!.stream
              .cast<List<int>>()
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .listen(
                (line) {
                  if (line.startsWith('event:')) {
                    currentEvent = line.substring(6).trim();
                    return;
                  }
                  if (!line.startsWith('data:')) return;
                  final raw = line.substring(6).trim();
                  if (raw == '[DONE]') {
                    controller.close();
                    return;
                  }
                  final text = _extractSseText(
                    raw,
                    event: currentEvent,
                    hasProgressText: emittedProgressText,
                  );
                  if (text.isNotEmpty) {
                    if (currentEvent != 'lastDraftResponseUpdate') {
                      emittedProgressText = true;
                    }
                    controller.add(text);
                  }
                },
                onError: controller.addError,
                onDone: () {
                  if (!controller.isClosed) controller.close();
                },
              );
        })
        .catchError((e, st) {
          if (e is DioException) {
            _logApiError('streamDraftResponse', e);
          }
          // ensure types match StreamController.addError(Object, [StackTrace?])
          controller.addError(e as Object, st as StackTrace?);
          return null;
        });

    return controller.stream;
  }

  /// Extracts the response text from various API response shapes.
  String _extractText(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      final nestedData = data['data'];
      if (nestedData is Map<String, dynamic>) {
        final nestedText = _extractText(nestedData);
        if (nestedText.isNotEmpty) return nestedText;
      }
      return (data['response'] ??
              data['message'] ??
              data['content'] ??
              data['text'] ??
              data['answer'] ??
              data['draftResponse'] ??
              data['draft'] ??
              '')
          .toString();
    }
    return data.toString();
  }

  String _extractSseText(
    String raw, {
    required String? event,
    required bool hasProgressText,
  }) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return event == null ? decoded.toString() : '';
      }

      if (event == 'lastDraftResponseUpdate' && hasProgressText) {
        return '';
      }

      final payload = decoded['data'];
      final map = payload is Map<String, dynamic> ? payload : decoded;
      return _extractText(map);
    } catch (_) {
      return event == null ? raw : '';
    }
  }

  void _logApiError(String action, DioException e) {
    final method = e.requestOptions.method;
    final path = e.requestOptions.path;
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    debugPrint(
      '[PlaygroundApi][$action] $method $path failed '
      '(status: $statusCode) response: $responseData',
    );
  }
}
