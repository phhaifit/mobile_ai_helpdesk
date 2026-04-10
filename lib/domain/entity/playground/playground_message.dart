import 'package:json_annotation/json_annotation.dart';

part 'playground_message.g.dart';

enum MessageRole { user, assistant }

@JsonSerializable()
class PlaygroundMessage {
  final String id;
  final String content;
  final MessageRole role;

  /// Runtime-only flag — not persisted in JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isStreaming;

  final List<String> attachments;
  final DateTime timestamp;

  const PlaygroundMessage({
    required this.id,
    required this.content,
    required this.role,
    this.isStreaming = false,
    required this.attachments,
    required this.timestamp,
  });

  factory PlaygroundMessage.fromJson(Map<String, dynamic> json) =>
      _$PlaygroundMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PlaygroundMessageToJson(this);

  PlaygroundMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    bool? isStreaming,
    List<String>? attachments,
    DateTime? timestamp,
  }) =>
      PlaygroundMessage(
        id: id ?? this.id,
        content: content ?? this.content,
        role: role ?? this.role,
        isStreaming: isStreaming ?? this.isStreaming,
        attachments: attachments ?? this.attachments,
        timestamp: timestamp ?? this.timestamp,
      );
}
