// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MonetizationStore on _MonetizationStore, Store {
  Computed<bool>? _$isLoadingOverviewComputed;

  @override
  bool get isLoadingOverview => (_$isLoadingOverviewComputed ??= Computed<bool>(
    () => super.isLoadingOverview,
    name: '_MonetizationStore.isLoadingOverview',
  )).value;
  Computed<bool>? _$isSubmittingUpgradeComputed;

  @override
  bool get isSubmittingUpgrade =>
      (_$isSubmittingUpgradeComputed ??= Computed<bool>(
        () => super.isSubmittingUpgrade,
        name: '_MonetizationStore.isSubmittingUpgrade',
      )).value;
  Computed<double>? _$usageProgressComputed;

  @override
  double get usageProgress => (_$usageProgressComputed ??= Computed<double>(
    () => super.usageProgress,
    name: '_MonetizationStore.usageProgress',
  )).value;

  late final _$fetchOverviewFutureAtom = Atom(
    name: '_MonetizationStore.fetchOverviewFuture',
    context: context,
  );

  @override
  ObservableFuture<MonetizationOverview>? get fetchOverviewFuture {
    _$fetchOverviewFutureAtom.reportRead();
    return super.fetchOverviewFuture;
  }

  @override
  set fetchOverviewFuture(ObservableFuture<MonetizationOverview>? value) {
    _$fetchOverviewFutureAtom.reportWrite(value, super.fetchOverviewFuture, () {
      super.fetchOverviewFuture = value;
    });
  }

  late final _$upgradeFutureAtom = Atom(
    name: '_MonetizationStore.upgradeFuture',
    context: context,
  );

  @override
  ObservableFuture<UpgradeSimulationResult>? get upgradeFuture {
    _$upgradeFutureAtom.reportRead();
    return super.upgradeFuture;
  }

  @override
  set upgradeFuture(ObservableFuture<UpgradeSimulationResult>? value) {
    _$upgradeFutureAtom.reportWrite(value, super.upgradeFuture, () {
      super.upgradeFuture = value;
    });
  }

  late final _$overviewAtom = Atom(
    name: '_MonetizationStore.overview',
    context: context,
  );

  @override
  MonetizationOverview? get overview {
    _$overviewAtom.reportRead();
    return super.overview;
  }

  @override
  set overview(MonetizationOverview? value) {
    _$overviewAtom.reportWrite(value, super.overview, () {
      super.overview = value;
    });
  }

  late final _$upgradeResultAtom = Atom(
    name: '_MonetizationStore.upgradeResult',
    context: context,
  );

  @override
  UpgradeSimulationResult? get upgradeResult {
    _$upgradeResultAtom.reportRead();
    return super.upgradeResult;
  }

  @override
  set upgradeResult(UpgradeSimulationResult? value) {
    _$upgradeResultAtom.reportWrite(value, super.upgradeResult, () {
      super.upgradeResult = value;
    });
  }

  late final _$selectedPlanIdAtom = Atom(
    name: '_MonetizationStore.selectedPlanId',
    context: context,
  );

  @override
  String get selectedPlanId {
    _$selectedPlanIdAtom.reportRead();
    return super.selectedPlanId;
  }

  @override
  set selectedPlanId(String value) {
    _$selectedPlanIdAtom.reportWrite(value, super.selectedPlanId, () {
      super.selectedPlanId = value;
    });
  }

  late final _$selectedPaymentMethodAtom = Atom(
    name: '_MonetizationStore.selectedPaymentMethod',
    context: context,
  );

  @override
  PaymentMethod get selectedPaymentMethod {
    _$selectedPaymentMethodAtom.reportRead();
    return super.selectedPaymentMethod;
  }

  @override
  set selectedPaymentMethod(PaymentMethod value) {
    _$selectedPaymentMethodAtom.reportWrite(
      value,
      super.selectedPaymentMethod,
      () {
        super.selectedPaymentMethod = value;
      },
    );
  }

  late final _$currentStepAtom = Atom(
    name: '_MonetizationStore.currentStep',
    context: context,
  );

  @override
  UpgradeFlowStep get currentStep {
    _$currentStepAtom.reportRead();
    return super.currentStep;
  }

  @override
  set currentStep(UpgradeFlowStep value) {
    _$currentStepAtom.reportWrite(value, super.currentStep, () {
      super.currentStep = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_MonetizationStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$fetchOverviewAsyncAction = AsyncAction(
    '_MonetizationStore.fetchOverview',
    context: context,
  );

  @override
  Future<void> fetchOverview() {
    return _$fetchOverviewAsyncAction.run(() => super.fetchOverview());
  }

  late final _$submitUpgradeAsyncAction = AsyncAction(
    '_MonetizationStore.submitUpgrade',
    context: context,
  );

  @override
  Future<void> submitUpgrade() {
    return _$submitUpgradeAsyncAction.run(() => super.submitUpgrade());
  }

  late final _$_MonetizationStoreActionController = ActionController(
    name: '_MonetizationStore',
    context: context,
  );

  @override
  void selectPlan(String planId) {
    final _$actionInfo = _$_MonetizationStoreActionController.startAction(
      name: '_MonetizationStore.selectPlan',
    );
    try {
      return super.selectPlan(planId);
    } finally {
      _$_MonetizationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectPaymentMethod(PaymentMethod paymentMethod) {
    final _$actionInfo = _$_MonetizationStoreActionController.startAction(
      name: '_MonetizationStore.selectPaymentMethod',
    );
    try {
      return super.selectPaymentMethod(paymentMethod);
    } finally {
      _$_MonetizationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void moveToPaymentStep() {
    final _$actionInfo = _$_MonetizationStoreActionController.startAction(
      name: '_MonetizationStore.moveToPaymentStep',
    );
    try {
      return super.moveToPaymentStep();
    } finally {
      _$_MonetizationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetFlow() {
    final _$actionInfo = _$_MonetizationStoreActionController.startAction(
      name: '_MonetizationStore.resetFlow',
    );
    try {
      return super.resetFlow();
    } finally {
      _$_MonetizationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchOverviewFuture: ${fetchOverviewFuture},
upgradeFuture: ${upgradeFuture},
overview: ${overview},
upgradeResult: ${upgradeResult},
selectedPlanId: ${selectedPlanId},
selectedPaymentMethod: ${selectedPaymentMethod},
currentStep: ${currentStep},
errorMessage: ${errorMessage},
isLoadingOverview: ${isLoadingOverview},
isSubmittingUpgrade: ${isSubmittingUpgrade},
usageProgress: ${usageProgress}
    ''';
  }
}
