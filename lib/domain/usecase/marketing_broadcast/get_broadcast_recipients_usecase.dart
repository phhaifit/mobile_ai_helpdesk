import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetBroadcastRecipientsParams {
  final BroadcastRecipientsQuery query;

  const GetBroadcastRecipientsParams({required this.query});
}

class GetBroadcastRecipientsUseCase
    extends
        UseCase<
          BroadcastPage<BroadcastRecipient>,
          GetBroadcastRecipientsParams
        > {
  final MarketingBroadcastRepository _repository;

  GetBroadcastRecipientsUseCase(this._repository);

  @override
  Future<BroadcastPage<BroadcastRecipient>> call({
    required GetBroadcastRecipientsParams params,
  }) {
    return _repository.getBroadcastRecipients(query: params.query);
  }
}
