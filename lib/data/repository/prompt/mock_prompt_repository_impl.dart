import 'dart:async';

import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';

class MockPromptRepositoryImpl implements PromptRepository {
  MockPromptRepositoryImpl() {
    _templates.addAll(_seedData);
  }

  final List<ResponseTemplate> _templates = [];

  static const List<ResponseTemplate> _seedData = [
    ResponseTemplate(
      id: 'tpl_1',
      name: 'Customer greeting',
      description: 'Standard greeting template for customer support',
      template: 'Hello! Thank you for contacting us. How can I help you today?',
      isActive: true,
      assistantId: 'ast_support_01',
    ),
    ResponseTemplate(
      id: 'tpl_2',
      name: 'Ticket resolution summary',
      description: 'Summary template after resolving a support ticket',
      template:
          'Here is a summary of the steps we took to resolve your ticket. Please let us know if anything else comes up.',
      isActive: true,
      assistantId: 'ast_support_01',
    ),
    ResponseTemplate(
      id: 'tpl_3',
      name: 'Product introduction',
      description: 'Template for introducing product features to prospects',
      template:
          'I would love to walk you through our plan options and find the best fit for your team.',
      isActive: true,
      assistantId: 'ast_sales_01',
    ),
    ResponseTemplate(
      id: 'tpl_4',
      name: 'Follow-up after demo',
      description: 'Post-demo follow-up message template',
      template:
          'Thanks for your time today. I am sharing the recap and next steps we discussed.',
      isActive: false,
      assistantId: 'ast_sales_01',
    ),
    ResponseTemplate(
      id: 'tpl_5',
      name: 'API troubleshooting',
      description: 'Template for requesting debug info from customers',
      template:
          'Could you share the request ID, timestamp, and endpoint so we can trace the error in our logs?',
      isActive: true,
      assistantId: 'ast_tech_01',
    ),
    ResponseTemplate(
      id: 'tpl_6',
      name: 'Thank you note',
      description: 'Generic thank-you message for any channel',
      template:
          'We appreciate your patience and your business. Have a great day!',
      isActive: true,
      assistantId: 'ast_general_01',
    ),
  ];

  @override
  Future<List<ResponseTemplate>> getTemplates({String? assistantId}) async {
    await Future.delayed(const Duration(milliseconds: 320));
    if (assistantId != null && assistantId.isNotEmpty) {
      return List<ResponseTemplate>.unmodifiable(
        _templates.where((t) => t.assistantId == assistantId),
      );
    }
    return List<ResponseTemplate>.unmodifiable(_templates);
  }

  @override
  Future<ResponseTemplate> getTemplateDetail(String templateId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _templates.firstWhere(
      (t) => t.id == templateId,
      orElse: () => throw Exception('Template not found: $templateId'),
    );
  }

  @override
  Future<ResponseTemplate> createTemplate(
    CreateResponseTemplateDto dto,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final template = ResponseTemplate(
      id: 'tpl_${DateTime.now().millisecondsSinceEpoch}',
      name: dto.name,
      description: dto.description,
      template: dto.template,
      isActive: dto.isActive,
      assistantId: dto.assistantId,
    );
    _templates.add(template);
    return template;
  }

  @override
  Future<ResponseTemplate> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final i = _templates.indexWhere((t) => t.id == templateId);
    if (i < 0) {
      throw Exception('Template not found: $templateId');
    }
    final existing = _templates[i];
    final updated = existing.copyWith(
      name: dto.name,
      description: dto.description,
      template: dto.template,
      isActive: dto.isActive,
      assistantId: dto.assistantId,
    );
    _templates[i] = updated;
    return updated;
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _templates.removeWhere((t) => t.id == templateId);
  }

  @override
  Future<void> toggleActive(String templateId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final i = _templates.indexWhere((t) => t.id == templateId);
    if (i < 0) {
      return;
    }
    final t = _templates[i];
    _templates[i] = t.copyWith(isActive: !t.isActive);
  }
}
