import 'socket_typing_payload.dart';

class AgentStoppedTypingEvent {
  static const String name = SocketTypingPayload.nameStopTyping;

  static SocketTypingPayload? parse(dynamic payload) {
    if (payload is! Map) return null;
    return SocketTypingPayload.fromJson(payload.cast<String, dynamic>());
  }
}

