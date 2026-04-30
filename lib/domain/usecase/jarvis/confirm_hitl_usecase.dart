import '/core/domain/usecase/use_case.dart';
import '/domain/entity/jarvis/jarvis_message.dart';
import '/domain/repository/jarvis/jarvis_repository.dart';

class ConfirmHitlParams {
  final String tenantId;
  final JarvisConfirmDto dto;

  const ConfirmHitlParams({required this.tenantId, required this.dto});
}

class ConfirmHitlUseCase extends UseCase<JarvisResponse, ConfirmHitlParams> {
  final JarvisRepository _repository;

  ConfirmHitlUseCase(this._repository);

  @override
  Future<JarvisResponse> call({required ConfirmHitlParams params}) =>
      _repository.confirmHitl(params.tenantId, params.dto);
}
