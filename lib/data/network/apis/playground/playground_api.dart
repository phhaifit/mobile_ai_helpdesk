import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/data/network/models/request/ask_question_request.dart';
import '/data/network/models/request/chat_completion_request.dart';
import '/data/network/models/request/draft_response_request.dart';

class PlaygroundApi {
  final DioClient _dioClient;

  PlaygroundApi(this._dioClient);

  Future<String> askAgent(String agentId, AskQuestionRequest req) async {
    final response = await _dioClient.dio.post<dynamic>(
      Endpoints.agentAsk(agentId),
      data: req.toJson(),
    );
    return _extractText(response.data);
  }

  Future<String> chatComplete(
    String agentId,
    ChatCompletionRequest req,
  ) async {
    final response = await _dioClient.dio.post<dynamic>(
      Endpoints.agentChatComplete(agentId),
      data: req.toJson(),
    );
    return _extractText(response.data);
  }

  Future<String> getDraftResponse(
    String tenantId,
    DraftResponseRequest req,
  ) async {
    final response = await _dioClient.dio.post<dynamic>(
      Endpoints.agentDraftResponse(tenantId),
      data: req.toJson(),
    );
    return _extractText(response.data);
  }

  /// Returns a [Stream<String>] of text chunks via Server-Sent Events.
  /// Each SSE event line starts with `data: `. The stream closes on `[DONE]`
  /// or when the server closes the connection.
  Stream<String> streamDraftResponse(
    String tenantId,
    DraftResponseRequest req,
  ) {
    final controller = StreamController<String>();

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
                  if (!line.startsWith('data: ')) return;
                  final raw = line.substring(6).trim();
                  if (raw == '[DONE]') {
                    controller.close();
                    return;
                  }
                  try {
                    final json = jsonDecode(raw) as Map<String, dynamic>;
                    final text = (json['text'] ??
                            json['content'] ??
                            json['message'] ??
                            '')
                        .toString();
                    if (text.isNotEmpty) controller.add(text);
                  } catch (_) {
                    if (raw.isNotEmpty) controller.add(raw);
                  }
                },
                onError: controller.addError,
                onDone: () {
                  if (!controller.isClosed) controller.close();
                },
              );
        })
        .catchError(controller.addError);

    return controller.stream;
  }

  /// Extracts the response text from various API response shapes.
  String _extractText(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      return (data['response'] ??
              data['message'] ??
              data['content'] ??
              data['text'] ??
              '')
          .toString();
    }
    return data.toString();
  }
}
