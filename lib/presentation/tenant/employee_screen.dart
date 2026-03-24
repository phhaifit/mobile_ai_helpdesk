import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _emailController = TextEditingController();

  TeamRole _selectedRole = TeamRole.member;
  bool _isInviting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Observer(
        builder: (_) {
          final tenant = _tenantStore.currentTenant;
          final members = _teamStore.teamMembers.toList();
          final invitations = _teamStore.invitations.toList();
          final pendingInvitations = invitations
              .where((item) => item.status == InvitationStatus.pending)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Employees',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tenant == null
                        ? 'Select an organization to manage team members'
                        : 'Manage invitations for ${tenant.name}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  _buildInviteCard(tenant == null),
                  const SizedBox(height: 20),
                  _buildPendingInvitationsCard(pendingInvitations),
                  const SizedBox(height: 20),
                  _buildMembersCard(members),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInviteCard(bool disabled) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Invite Employee',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<TeamRole>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: TeamRole.values
                      .map(
                        (role) => DropdownMenuItem<TeamRole>(
                          value: role,
                          child: Text(_roleLabel(role)),
                        ),
                      )
                      .toList(),
                  onChanged: disabled
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: disabled || _isInviting || _teamStore.isLoading
                    ? null
                    : _inviteMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.messengerBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                child: _isInviting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Send Invite'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingInvitationsCard(List<Invitation> invitations) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Invitations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (invitations.isEmpty)
            Text(
              'No pending invitations.',
              style: TextStyle(color: Colors.grey.shade700),
            )
          else
            ...invitations.map(
              (invitation) => _buildInvitationTile(invitation),
            ),
        ],
      ),
    );
  }

  Widget _buildInvitationTile(Invitation invitation) {
    final acceptLink = _inviteLink(invitation.id, 'accept');
    final declineLink = _inviteLink(invitation.id, 'decline');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: ListTile(
        title: Text(invitation.email),
        subtitle: Text(
          '${_roleLabel(invitation.role)} - expires ${_formatDate(invitation.expiresAt)}',
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            TextButton(
              onPressed: _teamStore.isLoading
                  ? null
                  : () => _handleResend(invitation.id),
              child: const Text('Resend'),
            ),
            PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleLinkAction(value, acceptLink, declineLink),
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'copy_accept',
                  child: Text('Copy accept link'),
                ),
                PopupMenuItem<String>(
                  value: 'copy_decline',
                  child: Text('Copy decline link'),
                ),
                PopupMenuItem<String>(
                  value: 'open_accept',
                  child: Text('Open accept'),
                ),
                PopupMenuItem<String>(
                  value: 'open_decline',
                  child: Text('Open decline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersCard(List<TeamMember> members) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Members',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (members.isEmpty)
            Text(
              'No members found.',
              style: TextStyle(color: Colors.grey.shade700),
            )
          else
            ...members.map(
              (member) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  member.displayName?.trim().isNotEmpty == true
                      ? member.displayName!
                      : member.email,
                ),
                subtitle: Text(member.email),
                trailing: Text(_roleLabel(member.role)),
              ),
            ),
        ],
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

  Future<void> _inviteMember() async {
    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }
    final invitedByMemberId = _teamStore.teamMembers.isNotEmpty
        ? _teamStore.teamMembers.first.id
        : 'system-inviter';

    setState(() {
      _isInviting = true;
    });
    await _teamStore.inviteMember(
      email: email,
      role: _selectedRole,
      invitedByMemberId: invitedByMemberId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _isInviting = false;
    });
    _emailController.clear();
    _showMessage('Invitation sent to $email.');
  }

  Future<void> _handleResend(String invitationId) async {
    await _teamStore.resendInvitation(invitationId);
    if (!mounted) {
      return;
    }
    _showMessage('Invitation resent.');
  }

  Future<void> _handleLinkAction(
    String action,
    String acceptLink,
    String declineLink,
  ) async {
    if (action == 'copy_accept') {
      await Clipboard.setData(ClipboardData(text: acceptLink));
      _showMessage('Accept link copied.');
      return;
    }
    if (action == 'copy_decline') {
      await Clipboard.setData(ClipboardData(text: declineLink));
      _showMessage('Decline link copied.');
      return;
    }
    if (!mounted) {
      return;
    }
    final route = action == 'open_accept' ? acceptLink : declineLink;
    await Navigator.of(context).pushNamed(route);
  }

  String _inviteLink(String invitationId, String action) {
    return '${Routes.tenantInviteRespond}?invitationId=$invitationId&action=$action';
  }

  String _roleLabel(TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return 'Owner';
      case TeamRole.admin:
        return 'Admin';
      case TeamRole.member:
        return 'Member';
    }
  }

  bool _isValidEmail(String value) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(value);
  }

  String _formatDate(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
