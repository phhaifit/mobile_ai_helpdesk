import 'socket_message_payload.dart';

class FacebookMessengerMessageEvent {
  static const String name = 'SOCKET_MESSENGER_MESSAGE';

  static SocketMessagePayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketMessagePayload.fromJson(payload.cast<String, dynamic>());
  }
}

