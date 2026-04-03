import 'package:json_annotation/json_annotation.dart';

part 'ai_agent.g.dart';

enum AgentMode { auto, semiAuto }

@JsonSerializable()
class AiAgent {
  final String id;
  final String name;
  final String description;
  final String? avatarUrl;
  final AgentMode mode;
  final List<String> platforms;
  final List<String> workflows;
  final String? teamId;
  final DateTime createdAt;

  const AiAgent({
    required this.id,
    required this.name,
    required this.description,
    this.avatarUrl,
    required this.mode,
    required this.platforms,
    required this.workflows,
    this.teamId,
    required this.createdAt,
  });

  factory AiAgent.fromJson(Map<String, dynamic> json) =>
      _$AiAgentFromJson(json);

  Map<String, dynamic> toJson() => _$AiAgentToJson(this);

  AiAgent copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    AgentMode? mode,
    List<String>? platforms,
    List<String>? workflows,
    String? teamId,
    DateTime? createdAt,
  }) =>
      AiAgent(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        mode: mode ?? this.mode,
        platforms: platforms ?? this.platforms,
        workflows: workflows ?? this.workflows,
        teamId: teamId ?? this.teamId,
        createdAt: createdAt ?? this.createdAt,
      );
}
