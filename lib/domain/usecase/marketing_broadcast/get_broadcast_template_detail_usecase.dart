import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class GetBroadcastTemplateDetailParams {
  final String templateId;

  const GetBroadcastTemplateDetailParams({required this.templateId});
}

class GetBroadcastTemplateDetailUseCase
    extends UseCase<BroadcastTemplate, GetBroadcastTemplateDetailParams> {
  final MarketingBroadcastRepository _repository;

  GetBroadcastTemplateDetailUseCase(this._repository);

  @override
  Future<BroadcastTemplate> call({
    required GetBroadcastTemplateDetailParams params,
  }) {
    return _repository.getBroadcastTemplateDetail(params.templateId);
  }
}
