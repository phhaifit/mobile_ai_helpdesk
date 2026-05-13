import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetDeliveryReceiptsParams {
  final String broadcastId;
  final PaginationQuery query;

  const GetDeliveryReceiptsParams({
    required this.broadcastId,
    required this.query,
  });
}

class GetDeliveryReceiptsUseCase
    extends
        UseCase<
          BroadcastPage<BroadcastDeliveryReceipt>,
          GetDeliveryReceiptsParams
        > {
  final MarketingBroadcastRepository _repository;

  GetDeliveryReceiptsUseCase(this._repository);

  @override
  Future<BroadcastPage<BroadcastDeliveryReceipt>> call({
    required GetDeliveryReceiptsParams params,
  }) {
    return _repository.getBroadcastDeliveryReceipts(
      broadcastId: params.broadcastId,
      query: params.query,
    );
  }
}
