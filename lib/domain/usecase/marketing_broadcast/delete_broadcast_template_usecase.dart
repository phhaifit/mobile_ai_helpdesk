import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class DeleteBroadcastTemplateParams {
  final String templateId;

  const DeleteBroadcastTemplateParams({required this.templateId});
}

class DeleteBroadcastTemplateUseCase
    extends UseCase<bool, DeleteBroadcastTemplateParams> {
  final MarketingBroadcastRepository _repository;

  DeleteBroadcastTemplateUseCase(this._repository);

  @override
  Future<bool> call({required DeleteBroadcastTemplateParams params}) {
    return _repository.deleteBroadcastTemplate(params.templateId);
  }
}
