import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../domain/entity/team_member/team_member.dart';
import '../../domain/entity/tenant/tenant.dart';
import '../../domain/entity/tenant_settings/tenant_settings.dart';
import '../tenant/store/tenant_store.dart';

class TenantSwitcher extends StatelessWidget {
  const TenantSwitcher({super.key});
  static const String _createTenantAction = '__create_tenant__';

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
              if (selectedValue == _createTenantAction) {
                await _showCreateTenantDialog(context, tenantStore);
                return;
              }
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
                    onPressed: () => _showCreateTenantDialog(context, tenantStore),
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

  Future<void> _showCreateTenantDialog(
    BuildContext context,
    TenantStore tenantStore,
  ) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final tenantName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.domain_add_rounded, color: AppColors.messengerBlue),
          title: const Text('Create new tenant'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Tenant name',
                hintText: 'e.g., Acme Corp',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(controller.text.trim());
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(controller.text.trim());
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    final name = tenantName?.trim() ?? '';
    if (name.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final id = 'tn-${now.millisecondsSinceEpoch}';

    await tenantStore.createTenant(
      Tenant(
        id: id,
        name: name,
        slug: name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
        settings: const TenantSettings(
          allowInvitations: true,
          defaultRole: TeamRole.member,
          enableAuditLog: false,
        ),
        createdAt: now,
      ),
    );
  }
}