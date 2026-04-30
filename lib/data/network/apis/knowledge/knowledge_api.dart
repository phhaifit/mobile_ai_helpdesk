import 'dart:io';

import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class KnowledgeApi {
  final DioClient _client;

  KnowledgeApi(this._client);

  Future<Map<String, dynamic>> importLocalFile(
    String tenantId,
    File file,
  ) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
      ),
    });
    final response = await _client.dio.post<dynamic>(
      Endpoints.knowledgeImportLocalFile(tenantId),
      data: formData,
    );
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  Future<Map<String, dynamic>> pollSourceStatus(
    List<String> sourceIds,
  ) async {
    final response = await _client.dio.post<dynamic>(
      Endpoints.knowledgePollStatus(),
      data: <String, dynamic>{'sourceIds': sourceIds},
    );
    final data = response.data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }
}
