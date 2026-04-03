// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentPlanStatus _$CurrentPlanStatusFromJson(Map<String, dynamic> json) =>
    CurrentPlanStatus(
      tier: $enumDecode(_$PlanTierEnumMap, json['tier']),
      planNameKey: json['planNameKey'] as String,
      isActive: json['isActive'] as bool,
      expiresAt:
          json['expiresAt'] == null
              ? null
              : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$CurrentPlanStatusToJson(CurrentPlanStatus instance) =>
    <String, dynamic>{
      'tier': _$PlanTierEnumMap[instance.tier]!,
      'planNameKey': instance.planNameKey,
      'isActive': instance.isActive,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$PlanTierEnumMap = {PlanTier.free: 'free', PlanTier.pro: 'pro'};

UsageLimit _$UsageLimitFromJson(Map<String, dynamic> json) => UsageLimit(
  usedTickets: (json['usedTickets'] as num).toInt(),
  totalTickets: (json['totalTickets'] as num).toInt(),
);

Map<String, dynamic> _$UsageLimitToJson(UsageLimit instance) =>
    <String, dynamic>{
      'usedTickets': instance.usedTickets,
      'totalTickets': instance.totalTickets,
    };

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    SubscriptionPlan(
      id: json['id'] as String,
      tier: $enumDecode(_$PlanTierEnumMap, json['tier']),
      nameKey: json['nameKey'] as String,
      priceLabel: json['priceLabel'] as String,
      billingCycle: json['billingCycle'] as String,
      isCurrentPlan: json['isCurrentPlan'] as bool,
      isRecommended: json['isRecommended'] as bool,
      featureKeys:
          (json['featureKeys'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tier': _$PlanTierEnumMap[instance.tier]!,
      'nameKey': instance.nameKey,
      'priceLabel': instance.priceLabel,
      'billingCycle': instance.billingCycle,
      'isCurrentPlan': instance.isCurrentPlan,
      'isRecommended': instance.isRecommended,
      'featureKeys': instance.featureKeys,
    };

FeatureGate _$FeatureGateFromJson(Map<String, dynamic> json) => FeatureGate(
  featureKey: json['featureKey'] as String,
  freeIncluded: json['freeIncluded'] as bool,
  proIncluded: json['proIncluded'] as bool,
);

Map<String, dynamic> _$FeatureGateToJson(FeatureGate instance) =>
    <String, dynamic>{
      'featureKey': instance.featureKey,
      'freeIncluded': instance.freeIncluded,
      'proIncluded': instance.proIncluded,
    };

MonetizationOverview _$MonetizationOverviewFromJson(
  Map<String, dynamic> json,
) => MonetizationOverview(
  currentPlan: CurrentPlanStatus.fromJson(
    json['currentPlan'] as Map<String, dynamic>,
  ),
  usageLimit: UsageLimit.fromJson(json['usageLimit'] as Map<String, dynamic>),
  plans:
      (json['plans'] as List<dynamic>)
          .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
  featureGates:
      (json['featureGates'] as List<dynamic>)
          .map((e) => FeatureGate.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MonetizationOverviewToJson(
  MonetizationOverview instance,
) => <String, dynamic>{
  'currentPlan': instance.currentPlan,
  'usageLimit': instance.usageLimit,
  'plans': instance.plans,
  'featureGates': instance.featureGates,
};

UpgradeSimulationResult _$UpgradeSimulationResultFromJson(
  Map<String, dynamic> json,
) => UpgradeSimulationResult(
  selectedPlanId: json['selectedPlanId'] as String,
  selectedPlanNameKey: json['selectedPlanNameKey'] as String,
  paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
  billedAmount: json['billedAmount'] as String,
  messageKey: json['messageKey'] as String,
);

Map<String, dynamic> _$UpgradeSimulationResultToJson(
  UpgradeSimulationResult instance,
) => <String, dynamic>{
  'selectedPlanId': instance.selectedPlanId,
  'selectedPlanNameKey': instance.selectedPlanNameKey,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'billedAmount': instance.billedAmount,
  'messageKey': instance.messageKey,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.card: 'card',
  PaymentMethod.paypal: 'paypal',
  PaymentMethod.bankTransfer: 'bankTransfer',
};
