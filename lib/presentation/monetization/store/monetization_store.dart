import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/get_monetization_overview_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/monetization/simulate_upgrade_usecase.dart';
import 'package:mobx/mobx.dart';

part 'monetization_store.g.dart';

class MonetizationStore = _MonetizationStore with _$MonetizationStore;

enum UpgradeFlowStep { selectPlan, selectPayment, confirmation }

abstract class _MonetizationStore with Store {
  final GetMonetizationOverviewUseCase _getMonetizationOverviewUseCase;
  final SimulateUpgradeUseCase _simulateUpgradeUseCase;

  _MonetizationStore(
    this._getMonetizationOverviewUseCase,
    this._simulateUpgradeUseCase,
  );

  @observable
  ObservableFuture<MonetizationOverview>? fetchOverviewFuture;

  @observable
  ObservableFuture<UpgradeSimulationResult>? upgradeFuture;

  @observable
  MonetizationOverview? overview;

  @observable
  UpgradeSimulationResult? upgradeResult;

  @observable
  String selectedPlanId = '';

  @observable
  PaymentMethod selectedPaymentMethod = PaymentMethod.card;

  @observable
  UpgradeFlowStep currentStep = UpgradeFlowStep.selectPlan;

  @observable
  String? errorMessage;

  @computed
  bool get isLoadingOverview =>
      fetchOverviewFuture?.status == FutureStatus.pending;

  @computed
  bool get isSubmittingUpgrade => upgradeFuture?.status == FutureStatus.pending;

  @computed
  double get usageProgress {
    final usage = overview?.usageLimit;
    if (usage == null || usage.totalTickets == 0) {
      return 0;
    }
    return usage.usedTickets / usage.totalTickets;
  }

  @action
  Future<void> fetchOverview() async {
    errorMessage = null;
    final future = ObservableFuture(
      _getMonetizationOverviewUseCase.call(params: null),
    );

    fetchOverviewFuture = future;

    try {
      overview = await future;
      if (selectedPlanId.isEmpty) {
        final currentPlan = overview!.plans.firstWhere(
          (plan) => plan.isCurrentPlan,
          orElse: () => overview!.plans.first,
        );
        selectedPlanId = currentPlan.id;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  void selectPlan(String planId) {
    selectedPlanId = planId;
    currentStep = UpgradeFlowStep.selectPlan;
  }

  @action
  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod = paymentMethod;
    currentStep = UpgradeFlowStep.selectPayment;
  }

  @action
  void moveToPaymentStep() {
    currentStep = UpgradeFlowStep.selectPayment;
  }

  @action
  Future<void> submitUpgrade() async {
    errorMessage = null;
    final future = ObservableFuture(
      _simulateUpgradeUseCase.call(
        params: SimulateUpgradeParams(
          planId: selectedPlanId,
          paymentMethod: selectedPaymentMethod,
        ),
      ),
    );

    upgradeFuture = future;

    try {
      upgradeResult = await future;
      currentStep = UpgradeFlowStep.confirmation;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  void resetFlow() {
    currentStep = UpgradeFlowStep.selectPlan;
    upgradeResult = null;
    errorMessage = null;
  }
}
