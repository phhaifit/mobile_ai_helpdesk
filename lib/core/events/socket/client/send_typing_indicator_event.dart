class SendTypingIndicatorEvent {
  static const String name = 'SOCKET_TYPING';

  final String chatRoomId;
  final String? customerSupportId;
  final String? fullname;
  final String? profilePicture;

  SendTypingIndicatorEvent({
    required this.chatRoomId,
    this.customerSupportId,
    this.fullname,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'chatRoomID': chatRoomId,
        if (customerSupportId != null && customerSupportId!.isNotEmpty)
          'customerSupportID': customerSupportId,
        if (fullname != null && fullname!.isNotEmpty) 'fullname': fullname,
        if (profilePicture != null && profilePicture!.isNotEmpty)
          'profilePicture': profilePicture,
      };
}
