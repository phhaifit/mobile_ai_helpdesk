import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/employee_detail_screen.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final TeamStore _teamStore = getIt<TeamStore>();
  final TenantStore _tenantStore = getIt<TenantStore>();
  final TextEditingController _memberSearchController = TextEditingController();
  final TextEditingController _invitationSearchController =
      TextEditingController();
  final TextEditingController _inviteEmailController = TextEditingController();

  int _selectedTab = 0;
  TeamRole? _memberRoleFilter;
  InvitationStatus? _invitationStatusFilter;
  TeamRole _inviteRole = TeamRole.member;
  bool _isSubmittingInvite = false;

  @override
  void dispose() {
    _memberSearchController.dispose();
    _invitationSearchController.dispose();
    _inviteEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isMobile ? AppBar(
        title: Text(l.translate('employee_app_title')),
        leading: isMobile && widget.onMenuTap != null
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: widget.onMenuTap,
              )
            : null,
      ) : null,
      body: Observer(
        builder: (_) {
          final members = _filteredMembers();
          final invitations = _filteredInvitations();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(l),
                  const SizedBox(height: 16),
                  if (_selectedTab == 0)
                    _buildEmployeeContent(l, members, isMobile)
                  else
                    _buildInvitationContent(l, invitations, isMobile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(AppLocalizations l) {
    return Row(
      children: [
        _tabButton(l.translate('employee_tab_employees'), 0),
        const SizedBox(width: 20),
        _tabButton(l.translate('employee_tab_invitations'), 1),
      ],
    );
  }

  Widget _tabButton(String title, int tab) {
    final selected = _selectedTab == tab;
    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: selected ? const Color(0xFF4057D6) : Colors.grey.shade700,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 120,
            color: selected ? const Color(0xFF4057D6) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeContent(AppLocalizations l, List<TeamMember> members, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          l: l,
          title: l.translate('employee_section_info'),
          subtitle: l.translate('employee_total_employees').replaceAll('{count}', '${members.length}'),
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _panel(
          child: Column(
            children: [
              _employeeFilters(l, isMobile),
              const SizedBox(height: 12),
              if (isMobile) _employeeCards(l, members) else _employeeTable(l, members),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationContent(AppLocalizations l, List<Invitation> invitations, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          l: l,
          title: l.translate('employee_section_invitations'),
          subtitle: l.translate('employee_total_invitations').replaceAll('{count}', '${invitations.length}'),
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _panel(
          child: Column(
            children: [
              _invitationFilters(l, isMobile),
              const SizedBox(height: 12),
              if (isMobile)
                _invitationCards(l, invitations)
              else
                _invitationTable(l, invitations),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHeader({
    required AppLocalizations l,
    required String title,
    required String subtitle,
    required bool isMobile,
  }) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _onExport,
                    icon: const Icon(Icons.download, size: 16),
                    label: Text(l.translate('employee_btn_export_excel')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openInviteDialog(l),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(l.translate('employee_btn_add_employee')),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _onExport,
                icon: const Icon(Icons.download, size: 16),
                label: Text(l.translate('employee_btn_export_excel')),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => _openInviteDialog(l),
                icon: const Icon(Icons.add, size: 16),
                label: Text(l.translate('employee_btn_add_employee')),
              ),
            ],
          );
  }

  Widget _employeeFilters(AppLocalizations l, bool isMobile) {
    // Border color is AppColors.dividerColor, text color is tertiary text color, icon is AppColors.textTertiary
    final search = TextField(
      controller: _memberSearchController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        hintText: l.translate('employee_search_email_hint'),
        prefixIcon: const Icon(Icons.search, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
    );

    final filter = DropdownButtonFormField<TeamRole?>(
      value: _memberRoleFilter,
      onChanged: (value) => setState(() => _memberRoleFilter = value),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        isDense: true,
      ),
      items: [
        DropdownMenuItem<TeamRole?>(value: null, child: Text(l.translate('employee_filter_all'))),
        ...TeamRole.values.map(
          (role) => DropdownMenuItem<TeamRole?>(
            value: role,
            child: Text(_roleLabel(l, role)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(children: [search, const SizedBox(height: 8), filter]);
    }

    return Row(
      children: [
        const Spacer(),
        SizedBox(width: 300, child: search),
        const SizedBox(width: 10),
        SizedBox(width: 240, child: filter),
      ],
    );
  }

  Widget _invitationFilters(AppLocalizations l, bool isMobile) {
    final search = TextField(
      controller: _invitationSearchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: l.translate('employee_search_email_hint'),
        prefixIcon: const Icon(Icons.search, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
    );

    final filter = DropdownButtonFormField<InvitationStatus?>(
      value: _invitationStatusFilter,
      onChanged: (value) => setState(() => _invitationStatusFilter = value),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
      items: [
        DropdownMenuItem<InvitationStatus?>(
          value: null,
          child: Text(l.translate('employee_filter_invitation_status')),
        ),
        ...InvitationStatus.values.map(
          (status) => DropdownMenuItem<InvitationStatus?>(
            value: status,
            child: Text(_invitationStatusLabel(l, status)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(children: [search, const SizedBox(height: 8), filter]);
    }

    return Row(
      children: [
        const Spacer(),
        SizedBox(width: 300, child: search),
        const SizedBox(width: 10),
        SizedBox(width: 300, child: filter),
      ],
    );
  }

  Widget _employeeTable(AppLocalizations l, List<TeamMember> members) {
    return Column(
      children: [
        _tableHeader([
          l.translate('employee_col_full_name'),
          l.translate('employee_col_email'),
          l.translate('employee_col_phone'),
          l.translate('employee_col_role'),
          l.translate('employee_col_actions'),
        ]),
        ...members.map(
          (member) => _tableRow([
            _displayName(member),
            member.email,
            member.phoneNumber ?? '-',
            _roleLabel(l, member.role),
            _detailsButton(l, member),
          ]),
        ),
      ],
    );
  }

  Widget _invitationTable(AppLocalizations l, List<Invitation> invitations) {
    return Column(
      children: [
        _tableHeader([
          l.translate('employee_col_email'),
          l.translate('employee_col_role'),
          l.translate('employee_col_expiration'),
          l.translate('employee_col_status'),
          l.translate('employee_col_actions'),
        ]),
        ...invitations.map(
          (item) => _tableRow([
            item.email,
            _roleLabel(l, item.role),
            _formatDateTime(item.expiresAt),
            _statusText(l, item.status),
            _invitationActions(l, item),
          ]),
        ),
      ],
    );
  }

  Widget _employeeCards(AppLocalizations l, List<TeamMember> members) {
    if (members.isEmpty) {
      return _emptyText(l.translate('employee_empty_employees'));
    }
    return Column(
      children: members
          .map(
            (member) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(_displayName(member)),
                subtitle: Text('${member.email}\n${_roleLabel(l, member.role)}'),
                trailing: TextButton(
                  onPressed: () => _showMemberDetails(member),
                  child: Text(l.translate('employee_btn_details')),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _invitationCards(AppLocalizations l, List<Invitation> invitations) {
    if (invitations.isEmpty) {
      return _emptyText(l.translate('employee_empty_invitations'));
    }
    return Column(
      children: invitations
          .map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.email,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(_roleLabel(l, item.role)),
                    Text(_formatDateTime(item.expiresAt)),
                    Text(_invitationStatusLabel(l, item.status)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (item.status == InvitationStatus.pending)
                          OutlinedButton(
                            onPressed: () => _handleResend(item.id, l),
                            child: Text(l.translate('employee_btn_resend')),
                          ),
                        const SizedBox(width: 8),
                        if (item.status == InvitationStatus.pending)
                          ElevatedButton(
                            onPressed: () => _handleDeleteInvitation(item.id, l),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF04E4E),
                            ),
                            child: Text(l.translate('employee_btn_delete'), style: const TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _tableHeader(List<String> titles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF3F4F7),
      child: Row(
        children: titles
            .map(
              (e) => Expanded(
                child: Text(
                  e,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _tableRow(List<dynamic> values) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: values
            .map(
              (v) =>
                  Expanded(child: v is Widget ? v : Text(v?.toString() ?? '-')),
            )
            .toList(),
      ),
    );
  }

  Widget _detailsButton(AppLocalizations l, TeamMember member) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(
        onPressed: () => _showMemberDetails(member),
        child: Text(l.translate('employee_btn_details')),
      ),
    );
  }

  Widget _statusText(AppLocalizations l, InvitationStatus status) {
    Color color;
    switch (status) {
      case InvitationStatus.pending:
        color = Colors.black87;
        break;
      case InvitationStatus.accepted:
        color = Colors.green;
        break;
      case InvitationStatus.expired:
        color = Colors.red;
        break;
      case InvitationStatus.revoked:
        color = Colors.orange;
        break;
    }
    return Text(
      _invitationStatusLabel(l, status),
      style: TextStyle(fontWeight: FontWeight.w700, color: color),
    );
  }

  Widget _invitationActions(AppLocalizations l, Invitation invitation) {
    if (invitation.status != InvitationStatus.pending) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => _handleResend(invitation.id, l),
          child: Text(l.translate('employee_btn_resend')),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _handleDeleteInvitation(invitation.id, l),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF04E4E),
          ),
          child: Text(l.translate('employee_btn_delete'), style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: child,
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(text, style: TextStyle(color: Colors.grey.shade700)),
    );
  }

  List<TeamMember> _filteredMembers() {
    final query = _memberSearchController.text.trim().toLowerCase();
    return _teamStore.teamMembers.where((member) {
      final hitQuery =
          query.isEmpty ||
          member.email.toLowerCase().contains(query) ||
          _displayName(member).toLowerCase().contains(query);
      final hitRole =
          _memberRoleFilter == null || member.role == _memberRoleFilter;
      return hitQuery && hitRole;
    }).toList();
  }

  List<Invitation> _filteredInvitations() {
    final query = _invitationSearchController.text.trim().toLowerCase();
    return _teamStore.invitations.where((item) {
      final hitQuery =
          query.isEmpty || item.email.toLowerCase().contains(query);
      final hitStatus =
          _invitationStatusFilter == null ||
          item.status == _invitationStatusFilter;
      return hitQuery && hitStatus;
    }).toList();
  }

  String _displayName(TeamMember member) {
    final displayName = member.displayName?.trim();
    return (displayName == null || displayName.isEmpty)
        ? member.email.split('@').first
        : displayName;
  }

  String _roleLabel(AppLocalizations l, TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return l.translate('employee_role_owner');
      case TeamRole.admin:
        return l.translate('employee_role_manager');
      case TeamRole.member:
        return l.translate('employee_role_staff');
    }
  }

  String _invitationStatusLabel(AppLocalizations l, InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return l.translate('invitation_status_pending');
      case InvitationStatus.accepted:
        return l.translate('invitation_status_accepted');
      case InvitationStatus.revoked:
        return l.translate('invitation_status_revoked');
      case InvitationStatus.expired:
        return l.translate('invitation_status_expired');
    }
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute $day/$month/$year';
  }

  Future<void> _openInviteDialog(AppLocalizations l) async {
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage(l.translate('employee_msg_no_org'));
      return;
    }

    _inviteEmailController.clear();
    _inviteRole = TeamRole.member;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dl = AppLocalizations.of(dialogContext);
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(dl.translate('employee_dialog_add_title')),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _inviteEmailController,
                      decoration: InputDecoration(
                        labelText: dl.translate('employee_field_email'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<TeamRole>(
                      value: _inviteRole,
                      items: TeamRole.values
                          .map(
                            (role) => DropdownMenuItem<TeamRole>(
                              value: role,
                              child: Text(_roleLabel(dl, role)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setDialogState(() => _inviteRole = value);
                      },
                      decoration: InputDecoration(
                        labelText: dl.translate('employee_field_role'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmittingInvite
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(dl.translate('common_cancel')),
                ),
                ElevatedButton(
                  onPressed: _isSubmittingInvite
                      ? null
                      : () async {
                          await _submitInvite(dl);
                          if (dialogContext.mounted) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                  child: _isSubmittingInvite
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(dl.translate('employee_btn_add_employee')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitInvite(AppLocalizations l) async {
    final email = _inviteEmailController.text.trim();
    if (!_isValidEmail(email)) {
      _showMessage(l.translate('employee_msg_invalid_email'));
      return;
    }

    final invitedByMemberId = _teamStore.teamMembers.isNotEmpty
        ? _teamStore.teamMembers.first.id
        : 'system-inviter';

    setState(() {
      _isSubmittingInvite = true;
    });

    await _teamStore.inviteMember(
      email: email,
      role: _inviteRole,
      invitedByMemberId: invitedByMemberId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmittingInvite = false;
      _selectedTab = 1;
    });

    _showMessage(l.translate('employee_msg_invite_sent').replaceAll('{email}', email));
  }

  Future<void> _handleResend(String invitationId, AppLocalizations l) async {
    await _teamStore.resendInvitation(invitationId);
    if (!mounted) {
      return;
    }
    _showMessage(l.translate('employee_msg_invite_resent'));
  }

  Future<void> _handleDeleteInvitation(String invitationId, AppLocalizations l) async {
    await _teamStore.declineInvitation(invitationId);
    if (!mounted) {
      return;
    }
    _showMessage(l.translate('employee_msg_invite_deleted'));
  }

  void _showMemberDetails(TeamMember member) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => EmployeeDetailScreen(member: member),
      ),
    );
  }

  void _onExport() {
    final l = AppLocalizations.of(context);
    _showMessage(l.translate('employee_msg_export_na'));
  }

  bool _isValidEmail(String value) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(value);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
