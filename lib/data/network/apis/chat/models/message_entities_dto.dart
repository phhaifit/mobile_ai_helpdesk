class MessageEntitiesDto {
  final Map<String, dynamic> channels;
  final Map<String, dynamic> senders;
  final Map<String, dynamic> tickets;

  MessageEntitiesDto({
    required this.channels,
    required this.senders,
    required this.tickets,
  });

  factory MessageEntitiesDto.fromJson(Map<String, dynamic> json) {
    return MessageEntitiesDto(
      channels: json['channels'] is Map<String, dynamic>
          ? (json['channels'] as Map<String, dynamic>).cast<String, dynamic>()
          : {},
      senders: json['senders'] is Map<String, dynamic>
          ? (json['senders'] as Map<String, dynamic>).cast<String, dynamic>()
          : {},
      tickets: json['tickets'] is Map<String, dynamic>
          ? (json['tickets'] as Map<String, dynamic>).cast<String, dynamic>()
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channels': channels,
      'senders': senders,
      'tickets': tickets,
    };
  }
}