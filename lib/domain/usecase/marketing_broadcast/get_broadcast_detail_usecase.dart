import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetBroadcastDetailParams {
  final String broadcastId;

  const GetBroadcastDetailParams({required this.broadcastId});
}

class GetBroadcastDetailUseCase
    extends UseCase<BroadcastItem, GetBroadcastDetailParams> {
  final MarketingBroadcastRepository _repository;

  GetBroadcastDetailUseCase(this._repository);

  @override
  Future<BroadcastItem> call({required GetBroadcastDetailParams params}) {
    return _repository.getBroadcastDetail(params.broadcastId);
  }
}
