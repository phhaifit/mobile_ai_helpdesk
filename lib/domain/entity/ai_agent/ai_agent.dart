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
  final DateTime? updatedAt;
  final String? websiteUrl;

  // API configuration fields (from UpdateAiAgentDto)
  final String? toneOfAI;
  final String? language;
  final bool? includeReference;
  final bool? autoResponse;
  final bool? autoDraftResponse;
  final bool? enableTemplate;
  final String? organizationDescription;
  final String? responseFormatGuide;

  const AiAgent({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.platforms,
    required this.workflows,
    required this.createdAt,
    this.updatedAt,
    this.websiteUrl,
    this.avatarUrl,
    this.teamId,
    this.toneOfAI,
    this.language,
    this.includeReference,
    this.autoResponse,
    this.autoDraftResponse,
    this.enableTemplate,
    this.organizationDescription,
    this.responseFormatGuide,
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
    DateTime? updatedAt,
    String? websiteUrl,
    String? toneOfAI,
    String? language,
    bool? includeReference,
    bool? autoResponse,
    bool? autoDraftResponse,
    bool? enableTemplate,
    String? organizationDescription,
    String? responseFormatGuide,
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
        updatedAt: updatedAt ?? this.updatedAt,
        websiteUrl: websiteUrl ?? this.websiteUrl,
        toneOfAI: toneOfAI ?? this.toneOfAI,
        language: language ?? this.language,
        includeReference: includeReference ?? this.includeReference,
        autoResponse: autoResponse ?? this.autoResponse,
        autoDraftResponse: autoDraftResponse ?? this.autoDraftResponse,
        enableTemplate: enableTemplate ?? this.enableTemplate,
        organizationDescription:
            organizationDescription ?? this.organizationDescription,
        responseFormatGuide: responseFormatGuide ?? this.responseFormatGuide,
      );
}
