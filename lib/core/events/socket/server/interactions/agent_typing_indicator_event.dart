import 'socket_typing_payload.dart';

class AgentTypingIndicatorEvent {
  static const String name = SocketTypingPayload.nameTyping;

  static SocketTypingPayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketTypingPayload.fromJson(payload.cast<String, dynamic>());
  }
}

