/// Request body for POST /api/v1/ai-agents/tenants/{tenantId} (create)
/// and PATCH /api/v1/ai-agents/tenants/{tenantId} (update config by tenant)
/// and PATCH /api/v1/ai-agents/{aiAgentId} (update config by agent ID).
///
/// Maps to UpdateAiAgentDto on the backend.
class UpdateAiAgentRequest {
  final String? toneOfAI;
  final String? language;
  final bool? includeReference;
  final bool? autoResponse;
  final bool? autoDraftResponse;
  final bool? enableTemplate;
  final String? organizationDescription;
  final String? responseFormatGuide;

  const UpdateAiAgentRequest({
    this.toneOfAI,
    this.language,
    this.includeReference,
    this.autoResponse,
    this.autoDraftResponse,
    this.enableTemplate,
    this.organizationDescription,
    this.responseFormatGuide,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (toneOfAI != null) map['toneOfAI'] = toneOfAI;
    if (language != null) map['language'] = language;
    if (includeReference != null) map['includeReference'] = includeReference;
    if (autoResponse != null) map['autoResponse'] = autoResponse;
    if (autoDraftResponse != null) map['autoDraftResponse'] = autoDraftResponse;
    if (enableTemplate != null) map['enableTemplate'] = enableTemplate;
    if (organizationDescription != null) {
      map['organizationDescription'] = organizationDescription;
    }
    if (responseFormatGuide != null) {
      map['responseFormatGuide'] = responseFormatGuide;
    }
    return map;
  }
}
