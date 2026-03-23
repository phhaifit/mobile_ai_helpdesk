import 'dart:async';

import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';

abstract class MonetizationRepository {
  Future<MonetizationOverview> getMonetizationOverview();

  Future<UpgradeSimulationResult> simulateUpgrade({
    required String planId,
    required PaymentMethod paymentMethod,
  });
}
