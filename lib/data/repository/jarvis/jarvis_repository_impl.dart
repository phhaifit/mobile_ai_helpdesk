import '/data/network/apis/jarvis/jarvis_agent_api.dart';
import '/domain/entity/jarvis/jarvis_message.dart';
import '/domain/repository/jarvis/jarvis_repository.dart';

class JarvisRepositoryImpl implements JarvisRepository {
  final JarvisAgentApi _api;

  JarvisRepositoryImpl(this._api);

  @override
  Future<JarvisResponse> sendMessage(
    String tenantId,
    JarvisMessageDto dto,
  ) => _api.sendMessage(tenantId, dto);

  @override
  Future<JarvisResponse> confirmHitl(
    String tenantId,
    JarvisConfirmDto dto,
  ) => _api.confirmHitl(tenantId, dto);
}
