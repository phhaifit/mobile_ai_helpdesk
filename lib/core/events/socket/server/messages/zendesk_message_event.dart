import 'socket_message_payload.dart';

class ZendeskMessageEvent {
  static const String name = 'SOCKET_ZENDESK_MESSAGE';

  static SocketMessagePayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketMessagePayload.fromJson(payload.cast<String, dynamic>());
  }
}

