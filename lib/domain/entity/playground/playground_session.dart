import 'package:json_annotation/json_annotation.dart';

import '../playground/playground_message.dart';

part 'playground_session.g.dart';

enum PlaygroundContextType { lazada, normal }

@JsonSerializable(explicitToJson: true)
class PlaygroundSession {
  final String id;
  final String? agentId;
  final PlaygroundContextType contextType;
  final List<PlaygroundMessage> messages;
  final DateTime createdAt;

  const PlaygroundSession({
    required this.id,
    this.agentId,
    required this.contextType,
    required this.messages,
    required this.createdAt,
  });

  factory PlaygroundSession.fromJson(Map<String, dynamic> json) =>
      _$PlaygroundSessionFromJson(json);

  Map<String, dynamic> toJson() => _$PlaygroundSessionToJson(this);

  PlaygroundSession copyWith({
    String? id,
    String? agentId,
    PlaygroundContextType? contextType,
    List<PlaygroundMessage>? messages,
    DateTime? createdAt,
  }) =>
      PlaygroundSession(
        id: id ?? this.id,
        agentId: agentId ?? this.agentId,
        contextType: contextType ?? this.contextType,
        messages: messages ?? this.messages,
        createdAt: createdAt ?? this.createdAt,
      );
}
