import 'dart:async';

import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class SaveTemplateParams {
  final MarketingTemplate template;

  const SaveTemplateParams({required this.template});
}

class SaveTemplateUseCase extends UseCase<TemplateSaveResult, SaveTemplateParams> {
  final MarketingRepository _repository;

  SaveTemplateUseCase(this._repository);

  @override
  Future<TemplateSaveResult> call({required SaveTemplateParams params}) {
    return _repository.saveTemplate(params.template);
  }
}
