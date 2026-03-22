import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class DeleteTemplateParams {
  final String id;

  const DeleteTemplateParams({required this.id});
}

class DeleteTemplateUseCase extends UseCase<TemplateSaveResult, DeleteTemplateParams> {
  final MarketingRepository _repository;

  DeleteTemplateUseCase(this._repository);

  @override
  Future<TemplateSaveResult> call({required DeleteTemplateParams params}) {
    return _repository.deleteTemplate(params.id);
  }
}
