import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../constants/colors.dart';
import '../../di/service_locator.dart';
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

  bool _autoResolutionEnabled = false;
  String? _activeTenantId;
  bool _isSavingName = false;
  bool _isDeletingTenant = false;

  @override
  void dispose() {
    _organizationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isMobile ? AppBar(
        title: const Text('Organization'),
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
          final tenant = _tenantStore.currentTenant;
          _syncTenantName(tenant?.id, tenant?.name ?? '');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organization',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your organization information',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'General Information',
                    style: TextStyle(
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
                              const Text(
                                'Organization name *',
                                style: TextStyle(
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
                              const SizedBox(
                                width: 180,
                                child: Text(
                                  'Organization name *',
                                  style: TextStyle(
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
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
                                borderRadius: BorderRadius.circular(8),
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
                                : const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ticket Auto-Resolution',
                    style: TextStyle(
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
                          'Configure automatic ticket resolution after a period of inactivity. When enabled, tickets with no new messages for the specified period will be automatically marked as solved.',
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
                              const Text(
                                'Auto-resolution',
                                style: TextStyle(
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
                            ],
                          )
                        else
                          Row(
                            children: [
                              const Text(
                                'Auto-resolution',
                                style: TextStyle(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Delete Organization',
                    style: TextStyle(
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
                                'All organization data will be permanently deleted',
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
                                  child: const Text('Delete Organization'),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'All organization data will be permanently deleted',
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
                                child: const Text('Delete Organization'),
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

  void _syncTenantName(String? tenantId, String tenantName) {
    if (_activeTenantId != tenantId) {
      _activeTenantId = tenantId;
      _organizationNameController.text = tenantName;
    }
  }

  Future<void> _handleSaveOrganizationName() async {
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage('No organization selected.');
      return;
    }
    final name = _organizationNameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Organization name cannot be empty.');
      return;
    }
    if (name == tenant.name) {
      _showMessage('No changes to save.');
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
          ? 'Organization name updated successfully.'
          : 'Failed to update organization name.',
    );
  }

  Future<void> _handleDeleteOrganization() async {
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage('No organization selected.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete organization'),
          content: Text(
            'Delete "${tenant.name}" permanently? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF04E4E),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
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
    _syncTenantName(
      _tenantStore.currentTenant?.id,
      _tenantStore.currentTenant?.name ?? '',
    );
    _showMessage(
      hasTenants
          ? 'Organization deleted. Switched to ${_tenantStore.currentTenant?.name}.'
          : 'Organization deleted. No organizations available.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
