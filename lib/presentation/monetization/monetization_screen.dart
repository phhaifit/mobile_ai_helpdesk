import 'package:mobile_ai_helpdesk/constants/dimens.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/domain/entity/monetization/monetization.dart';
import 'package:mobile_ai_helpdesk/presentation/monetization/store/monetization_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class MonetizationScreen extends StatefulWidget {
  final bool embedded;

  const MonetizationScreen({super.key, this.embedded = false});

  @override
  State<MonetizationScreen> createState() => _MonetizationScreenState();
}

class _MonetizationScreenState extends State<MonetizationScreen> {
  late final MonetizationStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MonetizationStore>();
    _store.fetchOverview();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final body = Observer(
      builder: (_) {
        if (_store.isLoadingOverview) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_store.errorMessage != null) {
          return Center(child: Text(_store.errorMessage!));
        }

        final overview = _store.overview;
        if (overview == null) {
          return Center(child: Text(l.translate('monetization_tv_empty')));
        }

        final selectedPlan = overview.plans.firstWhere(
          (plan) => plan.id == _store.selectedPlanId,
          orElse: () => overview.plans.first,
        );
        final isProSelected = selectedPlan.tier == PlanTier.pro;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepHeader(context, activeStep: 1),
                const SizedBox(height: 16),
                _buildCurrentPlanCard(context, overview),
                const SizedBox(height: 12),
                _buildUsageCard(context, overview),
                const SizedBox(height: 16),
                _buildSectionTitle(
                  context,
                  icon: Icons.view_list_outlined,
                  title: l.translate('monetization_tv_plans'),
                ),
                const SizedBox(height: 8),
                ...overview.plans.map((plan) => _buildPlanCard(context, plan)),
                const SizedBox(height: 8),
                Text(
                  l.translate('monetization_tv_select_plan_hint'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isProSelected) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                    context,
                    icon: Icons.fact_check_outlined,
                    title: l.translate('monetization_tv_feature_gating'),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureGateTable(context, overview.featureGates),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.upgradePayment,
                          arguments: _store.selectedPlanId,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(l.translate('monetization_btn_upgrade_cta')),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('monetization_tv_title'))),
      body: body,
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
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

  Widget _buildCurrentPlanCard(
    BuildContext context,
    MonetizationOverview data,
  ) {
    final l = AppLocalizations.of(context);
    final expiresAt = data.currentPlan.expiresAt;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              icon: Icons.workspace_premium_outlined,
              title: l.translate('monetization_tv_current_plan'),
            ),
            const SizedBox(height: 6),
            Text(
              l.translate(data.currentPlan.planNameKey),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              expiresAt == null
                  ? l.translate('monetization_tv_no_expiry')
                  : '${l.translate('monetization_tv_expiry')}: '
                        '${expiresAt.day}/${expiresAt.month}/${expiresAt.year}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCard(BuildContext context, MonetizationOverview data) {
    final l = AppLocalizations.of(context);
    final usage = data.usageLimit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              context,
              icon: Icons.stacked_bar_chart_outlined,
              title: l.translate('monetization_tv_usage_limit'),
            ),
            const SizedBox(height: 8),
            Text(
              '${usage.usedTickets}/${usage.totalTickets}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // This progress bar demonstrates ticket usage limit with mock data.
            LinearProgressIndicator(
              value: _store.usageProgress.clamp(0.0, 1.0),
            ),
            const SizedBox(height: 8),
            Text(
              '${usage.totalTickets - usage.usedTickets} '
              '${l.translate('monetization_tv_tickets_remaining')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SubscriptionPlan plan) {
    final l = AppLocalizations.of(context);
    final isSelected = _store.selectedPlanId == plan.id;
    final borderColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outlineVariant;

    return GestureDetector(
      onTap: () => _store.selectPlan(plan.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l.translate(plan.nameKey)}  ${plan.priceLabel}${plan.billingCycle}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (plan.isRecommended)
                      Chip(
                        label: Text(l.translate('monetization_tv_recommended')),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ...plan.featureKeys.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l.translate(feature))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!plan.isCurrentPlan)
                  isSelected
                      ? FilledButton.icon(
                          onPressed: () => _store.selectPlan(plan.id),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(l.translate('monetization_btn_selected')),
                        )
                      : OutlinedButton.icon(
                          onPressed: () => _store.selectPlan(plan.id),
                          icon: const Icon(Icons.radio_button_unchecked),
                          label: Text(
                            l.translate('monetization_btn_select_plan'),
                          ),
                        )
                else
                  Text(
                    l.translate('monetization_tv_current_plan_badge'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGateTable(BuildContext context, List<FeatureGate> gates) {
    final l = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(l.translate('monetization_tv_feature'))),
                Text(l.translate('monetization_tv_free')),
                const SizedBox(width: 16),
                Text(l.translate('monetization_tv_pro')),
              ],
            ),
            const Divider(),
            ...gates.map(
              (gate) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(l.translate(gate.featureKey))),
                    Icon(
                      gate.freeIncluded ? Icons.check_circle : Icons.cancel,
                      size: 18,
                      color: gate.freeIncluded
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 18),
                    Icon(
                      gate.proIncluded ? Icons.check_circle : Icons.cancel,
                      size: 18,
                      color: gate.proIncluded
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
