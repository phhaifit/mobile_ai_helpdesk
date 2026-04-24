import 'socket_typing_payload.dart';

class CustomerStoppedTypingEvent {
  static const String name = 'SOCKET_CUSTOMER_STOP_TYPING';

  static SocketTypingPayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketTypingPayload.fromJson(payload.cast<String, dynamic>());
  }
}

