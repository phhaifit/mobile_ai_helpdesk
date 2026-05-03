import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetBroadcastsParams {
  final BroadcastQuery query;

  const GetBroadcastsParams({required this.query});
}

class GetBroadcastsUseCase
    extends UseCase<BroadcastPage<BroadcastItem>, GetBroadcastsParams> {
  final MarketingBroadcastRepository _repository;

  GetBroadcastsUseCase(this._repository);

  @override
  Future<BroadcastPage<BroadcastItem>> call({
    required GetBroadcastsParams params,
  }) {
    return _repository.getBroadcasts(query: params.query);
  }
}
