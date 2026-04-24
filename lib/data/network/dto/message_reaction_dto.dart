class MessageReactionDto {
  final String messageReactionId;
  final String messageId;
  final String emoji;
  final int amount;
  final String? customerId;
  final String? customerSupportId;
  final String? customerName;
  final String? customerSupportName;
  final String? customerSupportAvatar;
  final String? customerZaloAvatar;
  final String? customerMessengerAvatar;

  MessageReactionDto({
    required this.messageReactionId,
    required this.messageId,
    required this.emoji,
    required this.amount,
    required this.customerId,
    required this.customerSupportId,
    required this.customerName,
    required this.customerSupportName,
    required this.customerSupportAvatar,
    required this.customerZaloAvatar,
    required this.customerMessengerAvatar,
  });

  factory MessageReactionDto.fromJson(Map<String, dynamic> json) {
    return MessageReactionDto(
      messageReactionId: (json['messageReactionID'] ?? '').toString(),
      messageId: (json['messageID'] ?? '').toString(),
      emoji: (json['emoji'] ?? '').toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toInt() : 0,
      customerId: json['customerID']?.toString(),
      customerSupportId: json['customerSupportID']?.toString(),
      customerName: json['customerName']?.toString(),
      customerSupportName: json['customerSupportName']?.toString(),
      customerSupportAvatar: json['customerSupportAvatar']?.toString() ?? '',
      customerZaloAvatar: json['customerZaloAvatar']?.toString() ?? '',
      customerMessengerAvatar: json['customerMessengerAvatar']?.toString() ?? '',
    );
  }
}