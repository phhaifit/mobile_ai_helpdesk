import 'message_dto.dart';

class MessageGroupDto {
  final DateTime date;
  final List<MessageDto> messages;

  MessageGroupDto({
    required this.date,
    required this.messages,
  });

  factory MessageGroupDto.fromJson(Map<String, dynamic> json) {
    return MessageGroupDto(
      date: json['date'] is String
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      messages: (json['messages'] as List).whereType<Map<String, dynamic>>().map((e) => MessageDto.fromJson(e)).toList(),
    );
  }
}