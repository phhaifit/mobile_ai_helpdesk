class ChatRoomCounterDto {
  final int open;
  final int pending;
  final int solved;
  final int closed;

  ChatRoomCounterDto({
    required this.open,
    required this.pending,
    required this.solved,
    required this.closed,
  });

  factory ChatRoomCounterDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomCounterDto(
      open: (json['open'] is num) ? (json['open'] as num).toInt() : 0,
      pending: (json['pending'] is num) ? (json['pending'] as num).toInt() : 0,
      solved: (json['solved'] is num) ? (json['solved'] as num).toInt() : 0,
      closed: (json['closed'] is num) ? (json['closed'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'pending': pending,
      'solved': solved,
      'closed': closed,
    };
  }
}