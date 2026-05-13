import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class UpdateBroadcastTemplateParams {
  final String templateId;
  final BroadcastTemplateUpsertData data;

  const UpdateBroadcastTemplateParams({
    required this.templateId,
    required this.data,
  });
}

class UpdateBroadcastTemplateUseCase
    extends UseCase<BroadcastTemplate, UpdateBroadcastTemplateParams> {
  final MarketingBroadcastRepository _repository;

  UpdateBroadcastTemplateUseCase(this._repository);

  @override
  Future<BroadcastTemplate> call({
    required UpdateBroadcastTemplateParams params,
  }) {
    return _repository.updateBroadcastTemplate(
      templateId: params.templateId,
      data: params.data,
    );
  }
}
