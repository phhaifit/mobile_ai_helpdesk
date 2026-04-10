import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../tenant/create_tenant_screen.dart';
import '../tenant/store/tenant_store.dart';

class TenantSwitcher extends StatelessWidget {
  const TenantSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final tenantStore = getIt<TenantStore>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Observer(
        builder: (_) {
          final tenants = tenantStore.tenantList;
          final selectedTenant = tenantStore.currentTenant;
          final selectedName = selectedTenant?.name ?? 'Select tenant';

          return PopupMenuButton<String>(
            tooltip: 'Switch tenant',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            position: PopupMenuPosition.under,
            onSelected: (selectedValue) async {
              await tenantStore.switchTenant(selectedValue);
            },
            // Popup menu items should be width as the parent widget
            itemBuilder: (context) => [
              ...tenants.map(
                (tenant) {
                  final isSelected = tenant.id == selectedTenant?.id;
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
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.messengerBlue : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.messengerBlue, size: 20),
                      ],
                    ),
                  );
                },
              ),
              if (tenants.isNotEmpty) const PopupMenuDivider(height: 2, color: AppColors.dividerColor),
              PopupMenuItem<String>(
                //Center the button in the dropdown menu
                child: Align(
                  alignment: Alignment.center,
                    child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openCreateTenantFlow(context);
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('New tenant'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.messengerBlue,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
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
                      selectedName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (tenantStore.isLoading)
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
          );
        },
      ),
    );
  }

  Future<void> _openCreateTenantFlow(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const CreateTenantScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}