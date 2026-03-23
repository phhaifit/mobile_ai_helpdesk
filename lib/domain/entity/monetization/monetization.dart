import 'package:json_annotation/json_annotation.dart';

part 'monetization.g.dart';

enum PlanTier { free, pro }

enum PaymentMethod { card, paypal, bankTransfer }

@JsonSerializable()
class CurrentPlanStatus {
  final PlanTier tier;
  final String planNameKey;
  final bool isActive;
  final DateTime? expiresAt;

  const CurrentPlanStatus({
    required this.tier,
    required this.planNameKey,
    required this.isActive,
    this.expiresAt,
  });

  factory CurrentPlanStatus.fromJson(Map<String, dynamic> json) =>
      _$CurrentPlanStatusFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentPlanStatusToJson(this);
}

@JsonSerializable()
class UsageLimit {
  final int usedTickets;
  final int totalTickets;

  const UsageLimit({required this.usedTickets, required this.totalTickets});

  factory UsageLimit.fromJson(Map<String, dynamic> json) =>
      _$UsageLimitFromJson(json);

  Map<String, dynamic> toJson() => _$UsageLimitToJson(this);
}

@JsonSerializable()
class SubscriptionPlan {
  final String id;
  final PlanTier tier;
  final String nameKey;
  final String priceLabel;
  final String billingCycle;
  final bool isCurrentPlan;
  final bool isRecommended;
  final List<String> featureKeys;

  const SubscriptionPlan({
    required this.id,
    required this.tier,
    required this.nameKey,
    required this.priceLabel,
    required this.billingCycle,
    required this.isCurrentPlan,
    required this.isRecommended,
    required this.featureKeys,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);
}

@JsonSerializable()
class FeatureGate {
  final String featureKey;
  final bool freeIncluded;
  final bool proIncluded;

  const FeatureGate({
    required this.featureKey,
    required this.freeIncluded,
    required this.proIncluded,
  });

  factory FeatureGate.fromJson(Map<String, dynamic> json) =>
      _$FeatureGateFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureGateToJson(this);
}

@JsonSerializable()
class MonetizationOverview {
  final CurrentPlanStatus currentPlan;
  final UsageLimit usageLimit;
  final List<SubscriptionPlan> plans;
  final List<FeatureGate> featureGates;

  const MonetizationOverview({
    required this.currentPlan,
    required this.usageLimit,
    required this.plans,
    required this.featureGates,
  });

  factory MonetizationOverview.fromJson(Map<String, dynamic> json) =>
      _$MonetizationOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$MonetizationOverviewToJson(this);
}

@JsonSerializable()
class UpgradeSimulationResult {
  final String selectedPlanId;
  final String selectedPlanNameKey;
  final PaymentMethod paymentMethod;
  final String billedAmount;
  final String messageKey;

  const UpgradeSimulationResult({
    required this.selectedPlanId,
    required this.selectedPlanNameKey,
    required this.paymentMethod,
    required this.billedAmount,
    required this.messageKey,
  });

  factory UpgradeSimulationResult.fromJson(Map<String, dynamic> json) =>
      _$UpgradeSimulationResultFromJson(json);

  Map<String, dynamic> toJson() => _$UpgradeSimulationResultToJson(this);
}
