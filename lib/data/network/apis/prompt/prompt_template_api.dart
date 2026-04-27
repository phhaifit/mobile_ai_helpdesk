import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/prompt/prompt.dart';

class PromptTemplateApi {
  final DioClient _dioClient;

  PromptTemplateApi(this._dioClient);

  Future<List<ResponseTemplate>> getTemplates({String? assistantId}) async {
    final res = await _dioClient.dio.get(
      Endpoints.responseTemplates(),
      queryParameters:
          (assistantId != null && assistantId.isNotEmpty)
              ? <String, dynamic>{'assistantId': assistantId}
              : null,
    );

    final List<dynamic> rawList = _extractMapList(_unwrapApiPayload(res.data));

    return rawList
        .whereType<Map<Object?, Object?>>()
        .map(
          (Map<Object?, Object?> item) =>
              ResponseTemplate.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((ResponseTemplate t) => t.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<ResponseTemplate> getTemplateDetail(String templateId) async {
    final res = await _dioClient.dio.get(
      Endpoints.responseTemplate(templateId),
    );
    return ResponseTemplate.fromJson(
      Map<String, dynamic>.from(_unwrapApiPayload(res.data) as Map),
    );
  }

  Future<ResponseTemplate> createTemplate(CreateResponseTemplateDto dto) async {
    final res = await _dioClient.dio.post(
      Endpoints.responseTemplates(),
      data: dto.toJson(),
    );
    final dynamic payload = _unwrapApiPayload(res.data);
    if (payload is Map) {
      return ResponseTemplate.fromJson(Map<String, dynamic>.from(payload));
    }
    // Some BEs return only an ID — synthesize from request DTO.
    return ResponseTemplate(
      id: '',
      name: dto.name,
      description: dto.description,
      template: dto.template,
      isActive: dto.isActive,
      assistantId: dto.assistantId,
    );
  }

  Future<ResponseTemplate> updateTemplate(
    String templateId,
    UpdateResponseTemplateDto dto,
  ) async {
    final res = await _dioClient.dio.patch(
      Endpoints.responseTemplate(templateId),
      data: dto.toJson(),
    );
    final dynamic payload = _unwrapApiPayload(res.data);
    if (payload is Map) {
      return ResponseTemplate.fromJson(Map<String, dynamic>.from(payload));
    }
    return getTemplateDetail(templateId);
  }

  Future<void> deleteTemplate(String templateId) async {
    await _dioClient.dio.delete(Endpoints.responseTemplate(templateId));
  }

  Future<void> toggleActive(String templateId) async {
    await _dioClient.dio.patch(Endpoints.activateResponseTemplate(templateId));
  }
}

dynamic _unwrapApiPayload(dynamic data) {
  if (data is List) {
    return data;
  }

  if (data is! Map) {
    return data;
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(data);
  final dynamic wrapped = map['data'] ?? map['result'] ?? map['payload'] ?? map;
  return wrapped;
}

List<dynamic> _extractMapList(dynamic data) {
  if (data is List) {
    return data;
  }

  if (data is! Map) {
    return const <dynamic>[];
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(data);
  final dynamic items =
      map['templates'] ??
      map['items'] ??
      map['results'] ??
      map['data'];

  if (items is List) {
    return items;
  }

  return const <dynamic>[];
}
