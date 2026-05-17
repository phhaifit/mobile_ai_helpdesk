class AuthenticateSocketConnectionEvent {
  static const String name = 'SOCKET_AUTHENTICATE';

  final String token;

  AuthenticateSocketConnectionEvent({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

