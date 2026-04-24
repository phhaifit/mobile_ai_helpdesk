import 'dart:async';
import 'dart:convert';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/core/events/socket/server/ai/draft_response_sse_event.dart';
import 'package:dio/dio.dart';

class DraftResponseSseClient {
  final DioClient _dioClient;

  DraftResponseSseClient(this._dioClient);

  Stream<DraftResponseSseEvent> streamDraftResponse({
    required String chatRoomId,
    String? ticketId,
  }) async* {
    final res = await _dioClient.dio.post<ResponseBody>(
      '/api/chat-room/draft-response/stream',
      data: {
        'chatRoomId': chatRoomId,
        if (ticketId != null) 'ticketId': ticketId,
      },
      options: Options(
        responseType: ResponseType.stream,
        headers: const {
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
      ),
    );

    final body = res.data;
    if (body == null) {
      return;
    }

    final utf8Stream = body.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();

    await for (final chunk in utf8Stream) {
      buffer.write(chunk);
      var text = buffer.toString();
      var idx = text.indexOf('\n\n');
      while (idx != -1) {
        final rawEvent = text.substring(0, idx);
        text = text.substring(idx + 2);
        final evt = DraftResponseSseEvent.parse(rawEvent);
        if (evt != null) {
          yield evt;
        }
        idx = text.indexOf('\n\n');
      }
      buffer
        ..clear()
        ..write(text);
    }
  }
}