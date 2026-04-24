class SeenInfoDto {
  final String chatRoomSeenID;
  final String chatRoomID;
  final String customerSupportID;
  final String messageID;
  final int messageOrder;
  final int numberMessageSeen;
  final DateTime createdAt; // format: "2026-04-23T07:48:19.424Z"
  final DateTime updatedAt;

  SeenInfoDto({required this.chatRoomSeenID, required this.chatRoomID, required this.customerSupportID, required this.messageID, required this.messageOrder, required this.numberMessageSeen, required this.createdAt, required this.updatedAt});
  factory SeenInfoDto.fromJson(Map<String, dynamic> json) {
    return SeenInfoDto(
      chatRoomSeenID: (json['chatRoomSeenID'] ?? '').toString(),
      chatRoomID: (json['chatRoomID'] ?? '').toString(),
      customerSupportID: (json['customerSupportID'] ?? '').toString(),
      messageID: (json['messageID'] ?? '').toString(),
      messageOrder: (json['messageOrder'] is num) ? (json['messageOrder'] as num).toInt() : 0,
      numberMessageSeen: (json['numberMessageSeen'] is num) ? (json['numberMessageSeen'] as num).toInt() : 0,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}