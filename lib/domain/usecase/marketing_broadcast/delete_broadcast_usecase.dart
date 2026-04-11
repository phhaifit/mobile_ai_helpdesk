import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class DeleteBroadcastParams {
  final String broadcastId;

  const DeleteBroadcastParams({required this.broadcastId});
}

class DeleteBroadcastUseCase extends UseCase<bool, DeleteBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  DeleteBroadcastUseCase(this._repository);

  @override
  Future<bool> call({required DeleteBroadcastParams params}) {
    return _repository.deleteBroadcast(params.broadcastId);
  }
}
