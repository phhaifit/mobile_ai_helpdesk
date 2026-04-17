import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/jarvis/jarvis_message.dart';

class JarvisAgentApi {
  final DioClient _dioClient;

  JarvisAgentApi(this._dioClient);

  Future<JarvisResponse> sendMessage(
    String tenantId,
    JarvisMessageDto dto,
  ) async {
    final response = await _dioClient.dio.post(
      Endpoints.jarvisMessage(tenantId),
      data: dto.toJson(),
    );
    return JarvisResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<JarvisResponse> confirmHitl(
    String tenantId,
    JarvisConfirmDto dto,
  ) async {
    final response = await _dioClient.dio.post(
      Endpoints.jarvisConfirm(tenantId),
      data: dto.toJson(),
    );
    return JarvisResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
