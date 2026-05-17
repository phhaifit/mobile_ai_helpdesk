import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

/// Displays the workspace list and forwards selection to [onTenantChanged].
/// Loading and fetch logic live outside this widget (e.g. [MainScreen]).
class TenantSwitcher extends StatelessWidget {
  const TenantSwitcher({
    required this.tenants,
    required this.selectedTenant,
    required this.isLoading,
    required this.onTenantChanged,
    this.onCreateTenant,
    super.key,
  });

  static const String menuCreateTenantValue = '__create_tenant__';

  final List<Tenant> tenants;
  final Tenant? selectedTenant;
  final bool isLoading;

  /// Called when the user picks an existing workspace from the menu.
  final ValueChanged<String> onTenantChanged;

  /// When set, shows “Create organization”; parent handles navigation and reload.
  final Future<void> Function(BuildContext context)? onCreateTenant;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String trimmedSelectedName = selectedTenant?.name.trim() ?? '';
    final String tenantButtonLabel = trimmedSelectedName.isNotEmpty
        ? trimmedSelectedName
        : l.translate('tenant_info_msg_no_org');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: PopupMenuButton<String>(
        tooltip: l.translate('tenant_info_appbar'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        position: PopupMenuPosition.under,
        onSelected: (String selectedValue) async {
          if (selectedValue == menuCreateTenantValue) {
            if (onCreateTenant != null) {
              await onCreateTenant!(context);
            }
            return;
          }
          onTenantChanged(selectedValue);
        },
        itemBuilder: (BuildContext context) => [
          ...tenants.map(
            (Tenant tenant) {
              final bool isSelected = tenant.id == selectedTenant?.id;
              return PopupMenuItem<String>(
                value: tenant.id,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        tenant.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.messengerBlue : null,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.messengerBlue,
                        size: 20,
                      ),
                  ],
                ),
              );
            },
          ),
          if (onCreateTenant != null)
            PopupMenuItem<String>(
              value: menuCreateTenantValue,
              child: Row(
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: AppColors.messengerBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(l.translate('create_tenant_step1_title')),
                ],
              ),
            ),
        ],
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            disabledForegroundColor: theme.textTheme.bodyLarge?.color,
            side: const BorderSide(color: AppColors.messengerBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tenantButtonLabel,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.messengerBlue,
                  ),
                )
              else
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: AppColors.messengerBlue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
