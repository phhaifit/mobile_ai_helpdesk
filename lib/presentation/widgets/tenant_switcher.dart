import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/presentation/tenant/invitation_response_screen.dart';
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
  static const String _menuNoPendingInvitationsValue =
      '__no_pending_invitations__';
  static const String _invitationValuePrefix = 'inv:';

  final TenantStore _tenantStore = getIt<TenantStore>();
  final InvitationRepository _invitationRepository =
      getIt<InvitationRepository>();

  List<Invitation> _accountInvitations = <Invitation>[];
  bool _isLoadingInvitations = false;

  List<Invitation> get _pendingInvitations {
    return _accountInvitations
        .where((invitation) => invitation.status == InvitationStatus.pending)
        .toList(growable: false);
  }

  int get _pendingInvitationsCount => _pendingInvitations.length;

  @override
  void initState() {
    super.initState();
    _loadAccountInvitations();
  }

  Future<void> _loadAccountInvitations() async {
    if (_isLoadingInvitations) {
      return;
    }
    setState(() {
      _isLoadingInvitations = true;
    });
    try {
      final invitations = await _invitationRepository.getAccountInvitations();
      if (!mounted) {
        return;
      }
      setState(() {
        _accountInvitations = invitations;
      });
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingInvitations = false;
      });
    }
  }

  Future<void> _openCreateTenantFlow(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const CreateTenantScreen(),
        fullscreenDialog: true,
      ),
    );
    await _loadAccountInvitations();
  }

  Future<void> _openInvitationResponseFlow(
    BuildContext context,
    String invitationId,
  ) async {
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => InvitationResponseScreen(invitationId: invitationId),
      ),
    );
    await _loadAccountInvitations();
  }

  String _menuValueForInvitation(Invitation invitation) {
    return '$_invitationValuePrefix${invitation.id}';
  }

  String? _invitationIdFromMenuValue(String value) {
    if (!value.startsWith(_invitationValuePrefix)) {
      return null;
    }
    final invitationId = value.substring(_invitationValuePrefix.length).trim();
    if (invitationId.isEmpty) {
      return null;
    }
    return invitationId;
  }

  String _tenantNameForInvitation(
    Invitation invitation,
    AppLocalizations l,
  ) {
    for (final tenant in _tenantStore.tenantList) {
      if (tenant.id == invitation.tenantId) {
        return tenant.name;
      }
    }
    return l.translate('invite_response_organization_fallback');
  }

  Future<void> _handleSelection(BuildContext context, String selectedValue) async {
    if (selectedValue == _menuCreateTenantValue) {
      await _openCreateTenantFlow(context);
      return;
    }

    if (selectedValue == _menuNoPendingInvitationsValue) {
      return;
    }

    final invitationId = _invitationIdFromMenuValue(selectedValue);
    if (invitationId != null) {
      await _openInvitationResponseFlow(context, invitationId);
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
              selectedTenant?.name ?? l.translate('tenant_info_msg_no_org');
          final pendingInvitations = _pendingInvitations;

          return PopupMenuButton<String>(
            tooltip: l.translate('tenant_info_appbar'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            position: PopupMenuPosition.under,
            onOpened: _loadAccountInvitations,
            onSelected: (selectedValue) async {
              await _handleSelection(context, selectedValue);
            },
            itemBuilder: (context) => [
              if (_isLoadingInvitations)
                PopupMenuItem<String>(
                  enabled: false,
                  value: _menuNoPendingInvitationsValue,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.messengerBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(l.translate('employee_tab_invitations')),
                    ],
                  ),
                )
              else if (pendingInvitations.isEmpty)
                PopupMenuItem<String>(
                  enabled: false,
                  value: _menuNoPendingInvitationsValue,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(l.translate('employee_empty_invitations')),
                    ],
                  ),
                )
              else
                ...pendingInvitations.map((invitation) {
                  final tenantName = _tenantNameForInvitation(invitation, l);
                  return PopupMenuItem<String>(
                    value: _menuValueForInvitation(invitation),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mail_rounded,
                          color: AppColors.messengerBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${invitation.email} • $tenantName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const PopupMenuDivider(height: 2),
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
              if (tenants.isNotEmpty) const PopupMenuDivider(height: 2),
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
                  if (_pendingInvitationsCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _pendingInvitationsCount > 99
                            ? '99+'
                            : _pendingInvitationsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (_pendingInvitationsCount > 0) const SizedBox(width: 8),
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