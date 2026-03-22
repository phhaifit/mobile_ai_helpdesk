import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';

class GetMonetizationOverviewUseCase
    extends UseCase<MonetizationOverview, void> {
  final MonetizationRepository _repository;

  GetMonetizationOverviewUseCase(this._repository);

  @override
  Future<MonetizationOverview> call({required void params}) {
    return _repository.getMonetizationOverview();
  }
}
