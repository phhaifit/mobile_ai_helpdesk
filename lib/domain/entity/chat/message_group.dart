import 'message.dart';

/// Messages grouped under a date bucket (e.g. search results).
class MessageGroup {
  final DateTime date;
  final List<Message> messages;

  const MessageGroup({
    required this.date,
    required this.messages,
  });
}
