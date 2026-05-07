import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class ResumeBroadcastParams {
  final String broadcastId;

  const ResumeBroadcastParams({required this.broadcastId});
}

class ResumeBroadcastUseCase
    extends UseCase<BroadcastItem, ResumeBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  ResumeBroadcastUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required ResumeBroadcastParams params}) {
    return _repository.resumeBroadcast(params.broadcastId);
  }
}
