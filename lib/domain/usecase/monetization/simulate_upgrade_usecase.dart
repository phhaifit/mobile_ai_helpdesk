import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:ai_helpdesk/domain/repository/monetization/monetization_repository.dart';

class SimulateUpgradeParams {
  final String planId;
  final PaymentMethod paymentMethod;

  const SimulateUpgradeParams({
    required this.planId,
    required this.paymentMethod,
  });
}

class SimulateUpgradeUseCase
    extends UseCase<UpgradeSimulationResult, SimulateUpgradeParams> {
  final MonetizationRepository _repository;

  SimulateUpgradeUseCase(this._repository);

  @override
  Future<UpgradeSimulationResult> call({
    required SimulateUpgradeParams params,
  }) {
    return _repository.simulateUpgrade(
      planId: params.planId,
      paymentMethod: params.paymentMethod,
    );
  }
}
