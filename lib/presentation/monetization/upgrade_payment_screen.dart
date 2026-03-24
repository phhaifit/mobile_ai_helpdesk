import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class UpgradePaymentScreen extends StatefulWidget {
  const UpgradePaymentScreen({super.key});

  @override
  State<UpgradePaymentScreen> createState() => _UpgradePaymentScreenState();
}

class _UpgradePaymentScreenState extends State<UpgradePaymentScreen> {
  late final MonetizationStore _store;
  bool _didApplyRouteArgs = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<MonetizationStore>();

    if (_store.overview == null) {
      _store.fetchOverview();
    }

    _store.moveToPaymentStep();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didApplyRouteArgs) {
      return;
    }

    final planId = ModalRoute.of(context)?.settings.arguments as String?;
    if (planId != null && planId.isNotEmpty) {
      _store.selectPlan(planId);
      _store.moveToPaymentStep();
    }
    _didApplyRouteArgs = true;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('monetization_tv_payment_title'))),
      body: Observer(
        builder: (_) {
          if (_store.isLoadingOverview) {
            return const Center(child: CircularProgressIndicator());
          }

          final overview = _store.overview;
          if (overview == null) {
            return Center(child: Text(l.translate('monetization_tv_empty')));
          }

          final selectedPlan = overview.plans.firstWhere(
            (plan) => plan.id == _store.selectedPlanId,
            orElse: () => overview.plans.first,
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepHeader(context, activeStep: 2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l.translate('monetization_tv_select_payment_method'),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMethodOption(
                    context,
                    method: PaymentMethod.card,
                    title: l.translate('monetization_tv_payment_card'),
                  ),
                  _buildMethodOption(
                    context,
                    method: PaymentMethod.paypal,
                    title: l.translate('monetization_tv_payment_paypal'),
                  ),
                  _buildMethodOption(
                    context,
                    method: PaymentMethod.bankTransfer,
                    title: l.translate('monetization_tv_payment_bank_transfer'),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      title: Text(l.translate('monetization_tv_plan_summary')),
                      subtitle: Text(
                        '${l.translate(selectedPlan.nameKey)} - '
                        '${selectedPlan.priceLabel}${selectedPlan.billingCycle}',
                      ),
                      trailing: const Icon(Icons.receipt_long_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _store.isSubmittingUpgrade
                          ? null
                          : () async {
                              await _store.submitUpgrade();
                              if (!context.mounted ||
                                  _store.errorMessage != null) {
                                return;
                              }
                              await Navigator.pushNamed(
                                context,
                                Routes.upgradeConfirmation,
                                arguments: _store.upgradeResult,
                              );
                            },
                      icon: _store.isSubmittingUpgrade
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.lock_open_outlined),
                      label: Text(l.translate('monetization_btn_continue')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, {required int activeStep}) {
    final l = AppLocalizations.of(context);

    Widget buildStep(int index, String label) {
      final isActive = index == activeStep;

      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$index', style: Theme.of(context).textTheme.titleMedium),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.translate('monetization_tv_upgrade_process'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            buildStep(1, l.translate('monetization_tv_step_plan')),
            const SizedBox(width: 8),
            buildStep(2, l.translate('monetization_tv_step_payment')),
            const SizedBox(width: 8),
            buildStep(3, l.translate('monetization_tv_step_confirm')),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodOption(
    BuildContext context, {
    required PaymentMethod method,
    required String title,
  }) {
    final isSelected = _store.selectedPaymentMethod == method;

    return Card(
      child: ListTile(
        onTap: () => _store.selectPaymentMethod(method),
        leading: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(title),
        trailing: isSelected ? const Icon(Icons.check_circle_outline) : null,
      ),
    );
  }
}
