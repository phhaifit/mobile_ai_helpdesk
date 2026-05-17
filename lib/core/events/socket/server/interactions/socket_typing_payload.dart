class SocketTypingPayload {
  static const String nameTyping = 'SOCKET_TYPING';
  static const String nameStopTyping = 'SOCKET_STOP_TYPING';

  final String chatRoomId;
  final String? customerSupportId;
  final String? fullname;
  final String? profilePicture;

  SocketTypingPayload({
    required this.chatRoomId,
    this.customerSupportId,
    this.fullname,
    this.profilePicture,
  });

  factory SocketTypingPayload.fromJson(Map<String, dynamic> json) {
    return SocketTypingPayload(
      chatRoomId: (json['chatRoomID'] ?? '').toString(),
      customerSupportId: _optionalString(json['customerSupportID']),
      fullname: _optionalString(json['fullname']),
      profilePicture: _optionalString(json['profilePicture']),
    );
  }

  static String? _optionalString(dynamic value) {
    if (value == null) return null;
    final String text = value.toString();
    return text.isEmpty ? null : text;
  }
}
