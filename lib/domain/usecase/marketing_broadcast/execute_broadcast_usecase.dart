import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class ExecuteBroadcastParams {
  final String broadcastId;

  const ExecuteBroadcastParams({required this.broadcastId});
}

class ExecuteBroadcastUseCase
    extends UseCase<BroadcastItem, ExecuteBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  ExecuteBroadcastUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required ExecuteBroadcastParams params}) {
    return _repository.executeBroadcast(params.broadcastId);
  }
}
