import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../tenant/create_tenant_screen.dart';
import '../tenant/store/tenant_store.dart';

class TenantSwitcher extends StatefulWidget {
  const TenantSwitcher({super.key});

  @override
  State<TenantSwitcher> createState() => _TenantSwitcherState();
}

class _TenantSwitcherState extends State<TenantSwitcher> {
  static const String _menuCreateTenantValue = '__create_tenant__';

  final TenantStore _tenantStore = getIt<TenantStore>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openCreateTenantFlow(BuildContext context) async {
    final tenantCountBeforeCreate = _tenantStore.tenantList.length;
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const CreateTenantScreen(),
        fullscreenDialog: true,
      ),
    );
    await _refreshTenantsAfterCreate(tenantCountBeforeCreate);
  }

  Future<void> _refreshTenantsAfterCreate(int previousCount) async {
    if (_tenantStore.tenantList.length > previousCount) {
      return;
    }

    const retryDelays = <Duration>[
      Duration.zero,
      Duration(milliseconds: 500),
      Duration(milliseconds: 1200),
    ];

    for (var i = 0; i < retryDelays.length; i++) {
      final delay = retryDelays[i];
      if (delay != Duration.zero) {
        await Future.delayed(delay);
      }

      await _tenantStore.loadTenants();

      if (_tenantStore.tenantList.length > previousCount) {
        return;
      }
    }
  }

  Future<void> _handleSelection(BuildContext context, String selectedValue) async {
    if (selectedValue == _menuCreateTenantValue) {
      await _openCreateTenantFlow(context);
      return;
    }

    await _tenantStore.switchTenant(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Observer(
        builder: (_) {
          final tenants = _tenantStore.tenantList;
          final selectedTenant = _tenantStore.currentTenant;
          final selectedName =
              selectedTenant?.name.trim().isNotEmpty ?? false
              ? selectedTenant!.name
              : l.translate('tenant_info_msg_no_org');

          return PopupMenuButton<String>(
            tooltip: l.translate('tenant_info_appbar'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            position: PopupMenuPosition.under,
            onSelected: (selectedValue) async {
              await _handleSelection(context, selectedValue);
            },
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
              PopupMenuItem<String>(
                value: _menuCreateTenantValue,
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
                      selectedName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_tenantStore.isLoading)
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
}