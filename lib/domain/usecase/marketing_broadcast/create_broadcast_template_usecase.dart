import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class CreateBroadcastTemplateParams {
  final BroadcastTemplateUpsertData data;

  const CreateBroadcastTemplateParams({required this.data});
}

class CreateBroadcastTemplateUseCase
    extends UseCase<BroadcastTemplate, CreateBroadcastTemplateParams> {
  final MarketingBroadcastRepository _repository;

  CreateBroadcastTemplateUseCase(this._repository);

  @override
  Future<BroadcastTemplate> call({
    required CreateBroadcastTemplateParams params,
  }) {
    return _repository.createBroadcastTemplate(params.data);
  }
}
