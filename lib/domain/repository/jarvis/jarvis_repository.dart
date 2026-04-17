import '/domain/entity/jarvis/jarvis_message.dart';

abstract class JarvisRepository {
  Future<JarvisResponse> sendMessage(String tenantId, JarvisMessageDto dto);

  Future<JarvisResponse> confirmHitl(String tenantId, JarvisConfirmDto dto);
}
