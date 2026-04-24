class MessageReactionDto {
  final String messageReactionID;
  final String messageID;
  final String emoji;
  final int amount;
  final String? customerID;
  final String? customerSupportID;
  final String? customerName;
  final String? customerSupportName;
  final String? customerSupportAvatar;
  final String? customerZaloAvatar;
  final String? customerMessengerAvatar;

  MessageReactionDto({
    required this.messageReactionID,
    required this.messageID,
    required this.emoji,
    required this.amount,
    required this.customerID,
    required this.customerSupportID,
    required this.customerName,
    required this.customerSupportName,
    required this.customerSupportAvatar,
    required this.customerZaloAvatar,
    required this.customerMessengerAvatar,
  });

  factory MessageReactionDto.fromJson(Map<String, dynamic> json) {
    return MessageReactionDto(
      messageReactionID: (json['messageReactionID'] ?? '').toString(),
      messageID: (json['messageID'] ?? '').toString(),
      emoji: (json['emoji'] ?? '').toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
      customerID: json['customerID']?.toString(),
      customerSupportID: json['customerSupportID']?.toString(),
      customerName: json['customerName']?.toString(),
      customerSupportName: json['customerSupportName']?.toString(),
      customerSupportAvatar: json['customerSupportAvatar']?.toString() ?? '',
      customerZaloAvatar: json['customerZaloAvatar']?.toString() ?? '',
      customerMessengerAvatar: json['customerMessengerAvatar']?.toString() ?? '',
    );
  }
}