abstract class SocketEvent<T> {
  String get name;
  T? parse(dynamic payload);
}

