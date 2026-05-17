import 'socket_message_payload.dart';

class EmailMessageEvent {
  static const String name = 'SOCKET_EMAIL_MESSAGE';

  static SocketMessagePayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketMessagePayload.fromJson(payload.cast<String, dynamic>());
  }
}

