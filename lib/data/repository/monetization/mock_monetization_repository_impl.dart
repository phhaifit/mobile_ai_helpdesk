import 'dart:async';

import 'package:mobile_ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:mobile_ai_helpdesk/domain/repository/monetization/monetization_repository.dart';

class MockMonetizationRepositoryImpl implements MonetizationRepository {
  final MonetizationOverview _overview = MonetizationOverview(
    currentPlan: CurrentPlanStatus(
      tier: PlanTier.free,
      planNameKey: 'freePlan',
      isActive: true,
      expiresAt: null,
    ),
    usageLimit: const UsageLimit(usedTickets: 18, totalTickets: 20),
    plans: const [
      SubscriptionPlan(
        id: 'free',
        tier: PlanTier.free,
        nameKey: 'freePlan',
        priceLabel: '\$0',
        billingCycle: '/month',
        isCurrentPlan: true,
        isRecommended: false,
        featureKeys: ['monthlyTickets', 'basicRouting', 'emailSupport'],
      ),
      SubscriptionPlan(
        id: 'pro_monthly',
        tier: PlanTier.pro,
        nameKey: 'proPlan',
        priceLabel: '\$24',
        billingCycle: '/month',
        isCurrentPlan: false,
        isRecommended: true,
        featureKeys: [
          'unlimitedTickets',
          'priorityRouting',
          'analyticsDashboard',
          'premiumSupport',
        ],
      ),
    ],
    featureGates: const [
      FeatureGate(
        featureKey: 'monthlyTickets',
        freeIncluded: true,
        proIncluded: true,
      ),
      FeatureGate(
        featureKey: 'advancedAnalytics',
        freeIncluded: false,
        proIncluded: true,
      ),
      FeatureGate(
        featureKey: 'slaAutomation',
        freeIncluded: false,
        proIncluded: true,
      ),
      FeatureGate(
        featureKey: 'prioritySupport',
        freeIncluded: false,
        proIncluded: true,
      ),
      FeatureGate(
        featureKey: 'customBranding',
        freeIncluded: false,
        proIncluded: true,
      ),
    ],
  );

  @override
  Future<MonetizationOverview> getMonetizationOverview() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return _overview;
  }

  @override
  Future<UpgradeSimulationResult> simulateUpgrade({
    required String planId,
    required PaymentMethod paymentMethod,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final selectedPlan = _overview.plans.firstWhere(
      (plan) => plan.id == planId,
      orElse: () => _overview.plans[1],
    );

    return UpgradeSimulationResult(
      selectedPlanId: selectedPlan.id,
      selectedPlanNameKey: selectedPlan.nameKey,
      paymentMethod: paymentMethod,
      billedAmount: '24.00',
      messageKey: 'upgradeSuccessMessage',
    );
  }
}
