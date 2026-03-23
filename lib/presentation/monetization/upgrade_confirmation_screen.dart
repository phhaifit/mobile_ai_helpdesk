import 'package:ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';

class UpgradeConfirmationScreen extends StatelessWidget {
  const UpgradeConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final result =
        ModalRoute.of(context)?.settings.arguments as UpgradeSimulationResult?;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('monetization_tv_confirmation_title')),
      ),
      body: result == null
          ? Center(child: Text(l.translate('monetization_tv_no_result')))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStepHeader(context, activeStep: 3),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            size: 56,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.translate('monetization_tv_upgrade_success'),
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.translate(result.messageKey),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.translate(
                                    'monetization_tv_upgrade_summary',
                                  ),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.workspace_premium),
                                  title: Text(
                                    l.translate(
                                      'monetization_tv_selected_plan',
                                    ),
                                  ),
                                  subtitle: Text(
                                    l.translate(result.selectedPlanNameKey),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                  ),
                                  title: Text(
                                    l.translate(
                                      'monetization_tv_selected_payment',
                                    ),
                                  ),
                                  subtitle: Text(
                                    _paymentLabel(result.paymentMethod, l),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    Icons.receipt_long_outlined,
                                  ),
                                  title: Text(
                                    l.translate(
                                      'monetization_tv_billed_amount',
                                    ),
                                  ),
                                  subtitle: Text(result.billedAmount),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.monetization,
                                (route) => route.settings.name == Routes.home,
                              );
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: Text(
                              l.translate(
                                'monetization_btn_back_to_monetization',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

  String _paymentLabel(PaymentMethod method, AppLocalizations l) {
    switch (method) {
      case PaymentMethod.card:
        return l.translate('monetization_tv_payment_card');
      case PaymentMethod.paypal:
        return l.translate('monetization_tv_payment_paypal');
      case PaymentMethod.bankTransfer:
        return l.translate('monetization_tv_payment_bank_transfer');
    }
  }
}
