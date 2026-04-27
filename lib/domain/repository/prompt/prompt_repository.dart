import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';

abstract class PromptRepository {
  /// GET /api/v1/response-templates?assistantId=
  Future<List<ResponseTemplate>> getTemplates({String? assistantId});

  /// GET /api/v1/response-templates/{templateId}
  Future<ResponseTemplate> getTemplateDetail(String templateId);

  /// POST /api/v1/response-templates
  Future<ResponseTemplate> createTemplate(CreateResponseTemplateDto dto);

  /// PATCH /api/v1/response-templates/{templateId}
  Future<ResponseTemplate> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  );

  /// DELETE /api/v1/response-templates/{templateId}
  Future<void> deleteTemplate(String templateId);

  /// PATCH /api/v1/response-templates/{templateId}/activate
  Future<void> toggleActive(String templateId);
}
