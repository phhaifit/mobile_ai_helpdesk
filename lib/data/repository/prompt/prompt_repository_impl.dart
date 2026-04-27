import 'dart:async';

import 'package:ai_helpdesk/data/network/apis/prompt/prompt_template_api.dart';
import 'package:ai_helpdesk/data/repository/prompt/mock_prompt_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';
import 'package:ai_helpdesk/domain/repository/prompt/prompt_repository.dart';
import 'package:dio/dio.dart';

/// Real implementation of [PromptRepository] backed by the Helpdesk API.
///
/// Falls back to [MockPromptRepositoryImpl] when the API is unreachable
/// (DioException) so phase-1 UX stays usable while BE is being rolled out.
class PromptRepositoryImpl implements PromptRepository {
  final PromptTemplateApi _api;
  final MockPromptRepositoryImpl _fallback;

  PromptRepositoryImpl(
    this._api, {
    MockPromptRepositoryImpl? fallback,
  }) : _fallback = fallback ?? MockPromptRepositoryImpl();

  @override
  Future<List<ResponseTemplate>> getTemplates({String? assistantId}) async {
    try {
      return await _api.getTemplates(assistantId: assistantId);
    } on DioException {
      return _fallback.getTemplates(assistantId: assistantId);
    }
  }

  @override
  Future<ResponseTemplate> getTemplateDetail(String templateId) async {
    try {
      return await _api.getTemplateDetail(templateId);
    } on DioException {
      return _fallback.getTemplateDetail(templateId);
    }
  }

  @override
  Future<ResponseTemplate> createTemplate(CreateResponseTemplateDto dto) async {
    try {
      return await _api.createTemplate(dto);
    } on DioException {
      return _fallback.createTemplate(dto);
    }
  }

  @override
  Future<ResponseTemplate> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  ) async {
    try {
      return await _api.updateTemplate(templateId, dto);
    } on DioException {
      return _fallback.updateTemplate(templateId, dto);
    }
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    try {
      await _api.deleteTemplate(templateId);
    } on DioException {
      await _fallback.deleteTemplate(templateId);
    }
  }

  @override
  Future<void> toggleActive(String templateId) async {
    try {
      await _api.toggleActive(templateId);
    } on DioException {
      await _fallback.toggleActive(templateId);
    }
  }
}
