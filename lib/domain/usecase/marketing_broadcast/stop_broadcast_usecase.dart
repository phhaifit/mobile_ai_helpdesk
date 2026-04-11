import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class StopBroadcastParams {
  final String broadcastId;

  const StopBroadcastParams({required this.broadcastId});
}

class StopBroadcastUseCase extends UseCase<BroadcastItem, StopBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  StopBroadcastUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required StopBroadcastParams params}) {
    return _repository.stopBroadcast(params.broadcastId);
  }
}
