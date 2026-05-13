/// Response template entity aligned with API spec:
/// GET/POST/PATCH/DELETE /api/v1/response-templates
class ResponseTemplate {
  final String id;
  final String name;
  final String description;
  final String template;
  final bool isActive;
  final String assistantId;

  const ResponseTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.template,
    required this.isActive,
    required this.assistantId,
  });

  ResponseTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? template,
    bool? isActive,
    String? assistantId,
  }) {
    return ResponseTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      template: template ?? this.template,
      isActive: isActive ?? this.isActive,
      assistantId: assistantId ?? this.assistantId,
    );
  }

  factory ResponseTemplate.fromJson(Map<String, dynamic> json) {
    return ResponseTemplate(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      template: json['template'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      assistantId: json['assistantId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'template': template,
      'isActive': isActive,
      'assistantId': assistantId,
    };
  }
}

/// DTO for POST /api/v1/response-templates
class CreateResponseTemplateDto {
  final String name;
  final String description;
  final String template;
  final bool isActive;
  final String assistantId;

  const CreateResponseTemplateDto({
    required this.name,
    required this.description,
    required this.template,
    required this.isActive,
    required this.assistantId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'template': template,
      'isActive': isActive,
      'assistantId': assistantId,
    };
  }
}

/// DTO for PATCH /api/v1/response-templates/{templateId}
class UpdateResponseTemplateDto {
  final String? name;
  final String? description;
  final String? template;
  final bool? isActive;
  final String? assistantId;

  const UpdateResponseTemplateDto({
    this.name,
    this.description,
    this.template,
    this.isActive,
    this.assistantId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (template != null) map['template'] = template;
    if (isActive != null) map['isActive'] = isActive;
    if (assistantId != null) map['assistantId'] = assistantId;
    return map;
  }
}
