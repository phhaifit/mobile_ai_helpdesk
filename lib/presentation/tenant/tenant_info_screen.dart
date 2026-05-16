import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../constants/colors.dart';
import '../../di/service_locator.dart';
import '../../utils/locale/app_localization.dart';
import '../tenant/store/tenant_store.dart';

class TenantInfoScreen extends StatefulWidget {
  const TenantInfoScreen({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  State<TenantInfoScreen> createState() => _TenantInfoScreenState();
}

class _TenantInfoScreenState extends State<TenantInfoScreen> {
  final TenantStore _tenantStore = getIt<TenantStore>();
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _autoResolutionTimeoutController =
      TextEditingController();

  bool _autoResolutionEnabled = false;
  String? _activeTenantId;
  bool _isSavingName = false;
  bool _isSavingAutoResolution = false;
  bool _isDeletingTenant = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadAutoResolutionSettings();
    });
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _autoResolutionTimeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isMobile ? AppBar(
        title: Text(l.translate('tenant_info_appbar')),
        backgroundColor: Colors.white,
        leading: isMobile && widget.onMenuTap != null
                ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: widget.onMenuTap,
                  )
                : null,
          ) : null,
      body: Observer(
        builder: (_) {
          _syncTenantState();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.translate('tenant_info_title'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.translate('tenant_info_subtitle'),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.translate('tenant_info_general'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    child: Column(
                      children: [
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.translate('tenant_info_org_name'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _organizationNameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text(
                                  l.translate('tenant_info_org_name'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _organizationNameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 12,
                            children: [
                            ElevatedButton(
                              onPressed: _isSavingName ? null : _handleCancelOrganizationName,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.textTertiary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(l.translate('tenant_info_cancel'), style: const TextStyle()),
                            ),
                            ElevatedButton(
                            onPressed:
                                (_tenantStore.currentTenant == null ||
                                    _isSavingName ||
                                    _tenantStore.isLoading)
                                ? null
                                : _handleSaveOrganizationName,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.messengerBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: _isSavingName
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l.translate('tenant_info_save')),
                          ),
                          ],)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.translate('tenant_info_auto_resolution_section'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.translate('tenant_info_auto_resolution_desc'),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isMobile)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.translate('tenant_info_auto_resolution_label'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Switch(
                                  value: _autoResolutionEnabled,
                                  activeColor: AppColors.messengerBlue,
                                  onChanged: (value) {
                                    setState(() {
                                      _autoResolutionEnabled = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l.translate('tenant_info_auto_resolution_timeout_label'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _autoResolutionTimeoutController,
                                keyboardType: TextInputType.number,
                                enabled: _autoResolutionEnabled,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: l.translate(
                                    'tenant_info_auto_resolution_timeout_hint',
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed:
                                      (_tenantStore.currentTenant == null ||
                                          _isSavingAutoResolution ||
                                          _tenantStore.isLoading)
                                      ? null
                                      : _handleSaveAutoResolution,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.messengerBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: _isSavingAutoResolution
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(l.translate('tenant_info_save')),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    l.translate('tenant_info_auto_resolution_label'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: _autoResolutionEnabled,
                                    activeColor: AppColors.messengerBlue,
                                    onChanged: (value) {
                                      setState(() {
                                        _autoResolutionEnabled = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 240,
                                    child: Text(
                                      l.translate(
                                        'tenant_info_auto_resolution_timeout_label',
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _autoResolutionTimeoutController,
                                      keyboardType: TextInputType.number,
                                      enabled: _autoResolutionEnabled,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: l.translate(
                                          'tenant_info_auto_resolution_timeout_hint',
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed:
                                      (_tenantStore.currentTenant == null ||
                                          _isSavingAutoResolution ||
                                          _tenantStore.isLoading)
                                      ? null
                                      : _handleSaveAutoResolution,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.messengerBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: _isSavingAutoResolution
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(l.translate('tenant_info_save')),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.translate('tenant_info_delete_section'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.translate('tenant_info_delete_warning'),
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      (_tenantStore.currentTenant == null ||
                                          _isDeletingTenant ||
                                          _tenantStore.isLoading)
                                      ? null
                                      : _handleDeleteOrganization,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF04E4E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(l.translate('tenant_info_delete_btn')),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.translate('tenant_info_delete_warning'),
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed:
                                    (_tenantStore.currentTenant == null ||
                                        _isDeletingTenant ||
                                        _tenantStore.isLoading)
                                    ? null
                                    : _handleDeleteOrganization,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF04E4E),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(l.translate('tenant_info_delete_btn')),
                              ),
                            ],
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  void _syncTenantState() {
    final tenant = _tenantStore.currentTenant;
    final tenantId = tenant?.id;
    if (_activeTenantId != tenantId) {
      _activeTenantId = tenantId;
      _organizationNameController.text = tenant?.name ?? '';
      _autoResolutionEnabled = tenant?.settings.autoResolutionEnabled ?? false;
      _autoResolutionTimeoutController.text =
          (tenant?.settings.autoResolutionTimeoutHours ?? 24).toString();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _reloadAutoResolutionSettings();
      });
    }
  }

  Future<void> _reloadAutoResolutionSettings() async {
    final tenantId = _tenantStore.currentTenant?.id;
    if (tenantId == null) {
      return;
    }
    await _tenantStore.refreshAutoResolutionSettings();
    if (!mounted || _tenantStore.currentTenant?.id != tenantId) {
      return;
    }
    final settings = _tenantStore.currentTenant?.settings;
    if (settings == null) {
      return;
    }
    setState(() {
      _autoResolutionEnabled = settings.autoResolutionEnabled;
      _autoResolutionTimeoutController.text =
          settings.autoResolutionTimeoutHours.toString();
    });
  }

  /// Handles the cancel organization name action
  /// @return void
  void _handleCancelOrganizationName() {
    _organizationNameController.text = _tenantStore.currentTenant?.name ?? '';
  }

  /// Handles the save organization name action
  /// @return void
  Future<void> _handleSaveOrganizationName() async {
    final l = AppLocalizations.of(context);
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage(l.translate('tenant_info_msg_no_org'));
      return;
    }
    final name = _organizationNameController.text.trim();
    if (name.isEmpty) {
      _showMessage(l.translate('tenant_info_msg_name_empty'));
      return;
    }
    if (name == tenant.name) {
      _showMessage(l.translate('tenant_info_msg_no_changes'));
      return;
    }

    setState(() {
      _isSavingName = true;
    });
    final updated = await _tenantStore.updateTenantName(name);
    if (!mounted) {
      return;
    }
    setState(() {
      _isSavingName = false;
    });
    _showMessage(
      updated
          ? l.translate('tenant_info_msg_name_updated')
          : l.translate('tenant_info_msg_name_failed'),
    );
  }

  Future<void> _handleSaveAutoResolution() async {
    final l = AppLocalizations.of(context);
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage(l.translate('tenant_info_msg_no_org'));
      return;
    }

    final timeoutHours = int.tryParse(
      _autoResolutionTimeoutController.text.trim(),
    );
    if (timeoutHours == null || timeoutHours <= 0) {
      _showMessage(l.translate('tenant_info_msg_auto_resolution_invalid_timeout'));
      return;
    }

    setState(() {
      _isSavingAutoResolution = true;
    });
    final updated = await _tenantStore.updateAutoResolutionSettings(
      enabled: _autoResolutionEnabled,
      timeoutHours: timeoutHours,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isSavingAutoResolution = false;
    });

    if (updated) {
      await _reloadAutoResolutionSettings();
    }
    _showMessage(
      updated
          ? l.translate('tenant_info_msg_auto_resolution_updated')
          : l.translate('tenant_info_msg_auto_resolution_failed'),
    );
  }

  Future<void> _handleDeleteOrganization() async {
    final l = AppLocalizations.of(context);
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage(l.translate('tenant_info_msg_no_org'));
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dl = AppLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(dl.translate('tenant_info_dialog_delete_title')),
          content: Text(
            dl.translate('tenant_info_dialog_delete_body').replaceAll('{name}', tenant.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dl.translate('common_cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF04E4E),
                foregroundColor: Colors.white,
              ),
              child: Text(dl.translate('tenant_info_dialog_delete_confirm')),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isDeletingTenant = true;
    });
    await _tenantStore.deleteTenant(tenant.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _isDeletingTenant = false;
    });

    final hasTenants = _tenantStore.currentTenant != null;
    _syncTenantState();
    final msgL = AppLocalizations.of(context);
    _showMessage(
      hasTenants
          ? msgL.translate('tenant_info_msg_deleted_switched').replaceAll('{name}', _tenantStore.currentTenant?.name ?? '')
          : msgL.translate('tenant_info_msg_deleted_none'),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
