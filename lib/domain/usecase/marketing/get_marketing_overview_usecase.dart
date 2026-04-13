import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class GetMarketingOverviewUseCase extends UseCase<MarketingOverview, void> {
  final MarketingRepository _repository;

  GetMarketingOverviewUseCase(this._repository);

  @override
  Future<MarketingOverview> call({required void params}) {
    return _repository.getMarketingOverview();
  }
}
