import 'message_dto.dart';
import 'message_entities_dto.dart';

class MessageListDto {
  final List<MessageDto> messages;
  final MessageEntitiesDto entities;

  MessageListDto({
    required this.messages,
    required this.entities,
  });

  factory MessageListDto.fromJson(Map<String, dynamic> json) {
    return MessageListDto(
      messages: (json['messages'] as List).map((e) => MessageDto.fromJson(e as Map<String, dynamic>)).toList(),
      entities: MessageEntitiesDto.fromJson(json['entities'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
      'entities': entities.toJson(),
    };
  }
}