import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetBroadcastTemplatesParams {
  final BroadcastTemplateQuery query;

  const GetBroadcastTemplatesParams({required this.query});
}

class GetBroadcastTemplatesUseCase
    extends
        UseCase<BroadcastPage<BroadcastTemplate>, GetBroadcastTemplatesParams> {
  final MarketingBroadcastRepository _repository;

  GetBroadcastTemplatesUseCase(this._repository);

  @override
  Future<BroadcastPage<BroadcastTemplate>> call({
    required GetBroadcastTemplatesParams params,
  }) {
    return _repository.getBroadcastTemplates(query: params.query);
  }
}
