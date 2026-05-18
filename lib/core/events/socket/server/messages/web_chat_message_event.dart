import 'socket_message_payload.dart';

class WebChatMessageEvent {
  static const String name = 'SOCKET_WEB_CHAT_WIDGET_MESSAGE';

  static SocketMessagePayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketMessagePayload.fromJson(payload.cast<String, dynamic>());
  }
}

