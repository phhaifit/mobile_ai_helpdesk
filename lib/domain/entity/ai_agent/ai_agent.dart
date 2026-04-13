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

  // API configuration fields (from UpdateAiAgentDto)
  final String? toneOfAI;
  final String? language;
  final bool? includeReference;
  final bool? autoResponse;
  final bool? autoDraftResponse;
  final bool? enableTemplate;

  const AiAgent({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.platforms,
    required this.workflows,
    required this.createdAt,
    this.avatarUrl,
    this.teamId,
    this.toneOfAI,
    this.language,
    this.includeReference,
    this.autoResponse,
    this.autoDraftResponse,
    this.enableTemplate,
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
    String? toneOfAI,
    String? language,
    bool? includeReference,
    bool? autoResponse,
    bool? autoDraftResponse,
    bool? enableTemplate,
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
        toneOfAI: toneOfAI ?? this.toneOfAI,
        language: language ?? this.language,
        includeReference: includeReference ?? this.includeReference,
        autoResponse: autoResponse ?? this.autoResponse,
        autoDraftResponse: autoDraftResponse ?? this.autoDraftResponse,
        enableTemplate: enableTemplate ?? this.enableTemplate,
      );
}
