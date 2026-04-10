import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class GetTemplatesUseCase extends UseCase<List<MarketingTemplate>, void> {
  final MarketingRepository _repository;

  GetTemplatesUseCase(this._repository);

  @override
  Future<List<MarketingTemplate>> call({required void params}) {
    return _repository.getTemplates();
  }
}
