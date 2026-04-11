import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class UpdateBroadcastParams {
  final String broadcastId;
  final BroadcastUpsertData data;

  const UpdateBroadcastParams({required this.broadcastId, required this.data});
}

class UpdateBroadcastUseCase
    extends UseCase<BroadcastItem, UpdateBroadcastParams> {
  final MarketingBroadcastRepository _repository;

  UpdateBroadcastUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required UpdateBroadcastParams params}) {
    return _repository.updateBroadcast(
      broadcastId: params.broadcastId,
      data: params.data,
    );
  }
}
