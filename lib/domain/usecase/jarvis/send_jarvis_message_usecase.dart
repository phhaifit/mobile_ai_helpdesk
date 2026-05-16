import '/core/domain/usecase/use_case.dart';
import '/domain/entity/jarvis/jarvis_message.dart';
import '/domain/repository/jarvis/jarvis_repository.dart';

class SendJarvisMessageParams {
  final String tenantId;
  final JarvisMessageDto dto;

  const SendJarvisMessageParams({required this.tenantId, required this.dto});
}

class SendJarvisMessageUseCase
    extends UseCase<JarvisResponse, SendJarvisMessageParams> {
  final JarvisRepository _repository;

  SendJarvisMessageUseCase(this._repository);

  @override
  Future<JarvisResponse> call({required SendJarvisMessageParams params}) =>
      _repository.sendMessage(params.tenantId, params.dto);
}
