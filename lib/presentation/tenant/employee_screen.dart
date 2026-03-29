import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isMobile ? AppBar(
        title: const Text('Employees'),
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
                  _buildTabs(),
                  const SizedBox(height: 16),
                  if (_selectedTab == 0)
                    _buildEmployeeContent(members, isMobile)
                  else
                    _buildInvitationContent(invitations, isMobile),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tabButton('Employee Information', 0),
        const SizedBox(width: 20),
        _tabButton('Invitations', 1),
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

  Widget _buildEmployeeContent(List<TeamMember> members, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          title: 'Employee Information',
          subtitle: 'Total Employees: ${members.length} employee',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _panel(
          child: Column(
            children: [
              _employeeFilters(isMobile),
              const SizedBox(height: 12),
              if (isMobile) _employeeCards(members) else _employeeTable(members),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationContent(List<Invitation> invitations, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(
          title: 'Employee Invitations',
          subtitle: 'Total Invitations: ${invitations.length} invitations',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _panel(
          child: Column(
            children: [
              _invitationFilters(isMobile),
              const SizedBox(height: 12),
              if (isMobile)
                _invitationCards(invitations)
              else
                _invitationTable(invitations),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHeader({
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
                    label: const Text('Export Excel'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _openInviteDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Employee'),
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
                label: const Text('Export Excel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _openInviteDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Employee'),
              ),
            ],
          );
  }

  Widget _employeeFilters(bool isMobile) {
    // Border color is AppColors.dividerColor, text color is tertiary text color, icon is AppColors.textTertiary
    final search = TextField(
      controller: _memberSearchController,
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search by email',
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
        const DropdownMenuItem<TeamRole?>(value: null, child: Text('All')),
        ...TeamRole.values.map(
          (role) => DropdownMenuItem<TeamRole?>(
            value: role,
            child: Text(_roleLabel(role)),
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

  Widget _invitationFilters(bool isMobile) {
    final search = TextField(
      controller: _invitationSearchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Search by email',
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
        const DropdownMenuItem<InvitationStatus?>(
          value: null,
          child: Text('Select invitation status'),
        ),
        ...InvitationStatus.values.map(
          (status) => DropdownMenuItem<InvitationStatus?>(
            value: status,
            child: Text(_invitationStatusLabel(status)),
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

  Widget _employeeTable(List<TeamMember> members) {
    return Column(
      children: [
        _tableHeader(const ['Full Name', 'Email', 'Phone Number', 'Role', '']),
        ...members.map(
          (member) => _tableRow([
            _displayName(member),
            member.email,
            '-',
            _roleLabel(member.role),
            _detailsButton(member),
          ]),
        ),
        _footerPagination(),
      ],
    );
  }

  Widget _invitationTable(List<Invitation> invitations) {
    return Column(
      children: [
        _tableHeader(const ['Email', 'Role', 'Expiration Date', 'Status', '']),
        ...invitations.map(
          (item) => _tableRow([
            item.email,
            _roleLabel(item.role),
            _formatDateTime(item.expiresAt),
            _statusText(item.status),
            _invitationActions(item),
          ]),
        ),
        _footerPagination(),
      ],
    );
  }

  Widget _employeeCards(List<TeamMember> members) {
    if (members.isEmpty) {
      return _emptyText('No employees found.');
    }
    return Column(
      children: members
          .map(
            (member) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(_displayName(member)),
                subtitle: Text('${member.email}\n${_roleLabel(member.role)}'),
                trailing: TextButton(
                  onPressed: () => _showMemberDetails(member),
                  child: const Text('Details'),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _invitationCards(List<Invitation> invitations) {
    if (invitations.isEmpty) {
      return _emptyText('No invitations found.');
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
                    Text(_roleLabel(item.role)),
                    Text(_formatDateTime(item.expiresAt)),
                    Text(_invitationStatusLabel(item.status)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (item.status == InvitationStatus.pending)
                          OutlinedButton(
                            onPressed: () => _handleResend(item.id),
                            child: const Text('Resend'),
                          ),
                        const SizedBox(width: 8),
                        if (item.status == InvitationStatus.pending)
                          ElevatedButton(
                            onPressed: () => _handleDeleteInvitation(item.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF04E4E),
                            ),
                            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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

  Widget _detailsButton(TeamMember member) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(
        onPressed: () => _showMemberDetails(member),
        child: const Text('Details'),
      ),
    );
  }

  Widget _statusText(InvitationStatus status) {
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
      _invitationStatusLabel(status),
      style: TextStyle(fontWeight: FontWeight.w700, color: color),
    );
  }

  Widget _invitationActions(Invitation invitation) {
    if (invitation.status != InvitationStatus.pending) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => _handleResend(invitation.id),
          child: const Text('Resend'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _handleDeleteInvitation(invitation.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF04E4E),
          ),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _footerPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Rows per page:'),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: const Text('10'),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFFF5F6FA),
            ),
            child: const Text('1'),
          ),
        ],
      ),
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

  String _roleLabel(TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return 'Owner';
      case TeamRole.admin:
        return 'Manager';
      case TeamRole.member:
        return 'Staff';
    }
  }

  String _invitationStatusLabel(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return 'Pending';
      case InvitationStatus.accepted:
        return 'Accepted';
      case InvitationStatus.revoked:
        return 'Deleted';
      case InvitationStatus.expired:
        return 'Expired';
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

  Future<void> _openInviteDialog() async {
    final tenant = _tenantStore.currentTenant;
    if (tenant == null) {
      _showMessage('No organization selected.');
      return;
    }

    _inviteEmailController.clear();
    _inviteRole = TeamRole.member;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('Add Employee'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _inviteEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TeamRole>(
                    value: _inviteRole,
                    items: TeamRole.values
                        .map(
                          (role) => DropdownMenuItem<TeamRole>(
                            value: role,
                            child: Text(_roleLabel(role)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() => _inviteRole = value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
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
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isSubmittingInvite
                    ? null
                    : () async {
                        await _submitInvite();
                        if (mounted) {
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
                    : const Text('Add Employee'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitInvite() async {
    final email = _inviteEmailController.text.trim();
    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
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

    _showMessage('Invitation sent to $email.');
  }

  Future<void> _handleResend(String invitationId) async {
    await _teamStore.resendInvitation(invitationId);
    if (!mounted) {
      return;
    }
    _showMessage('Invitation resent.');
  }

  Future<void> _handleDeleteInvitation(String invitationId) async {
    await _teamStore.declineInvitation(invitationId);
    if (!mounted) {
      return;
    }
    _showMessage('Invitation deleted.');
  }

  void _showMemberDetails(TeamMember member) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Employee Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_displayName(member)}'),
            const SizedBox(height: 8),
            Text('Email: ${member.email}'),
            const SizedBox(height: 8),
            Text('Role: ${_roleLabel(member.role)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _onExport() {
    _showMessage('Export is not implemented yet.');
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
