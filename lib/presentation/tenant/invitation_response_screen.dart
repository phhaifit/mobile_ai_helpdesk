import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/invitation/invitation.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/repository/invitation/invitation_repository.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Deep-link / email style screen to accept or decline a tenant invitation.
class InvitationResponseScreen extends StatefulWidget {
  const InvitationResponseScreen({
    required this.invitationId,
    super.key,
  });

  final String invitationId;

  /// Mock seed: invitation id → tenant id when invite is not in [TeamStore] yet.
  static const Map<String, String> seedInviteTenantIds = {
    'inv-001': 'tn-001',
    'inv-002': 'tn-001',
  };

  @override
  State<InvitationResponseScreen> createState() =>
      _InvitationResponseScreenState();
}

class _InvitationResponseScreenState extends State<InvitationResponseScreen> {
  final TeamStore _teamStore = getIt<TeamStore>();
  final TenantStore _tenantStore = getIt<TenantStore>();
  final InvitationRepository _invitationRepository = getIt<InvitationRepository>();

  static const Color _brandBlue = Color(0xFF1890FF);
  static const Color _brandPurple = Color(0xFF7C3AED);
  static const Color _cardTitleBlue = Color(0xFF1E3A5F);

  bool _isSubmitting = false;
  bool _finished = false;
  bool? _accepted;
  String? _errorMessage;

  Invitation? _findInvitation() {
    for (final i in _teamStore.invitations) {
      if (i.id == widget.invitationId) {
        return i;
      }
    }
    return null;
  }

  String _organizationName(AppLocalizations l, Invitation? inv) {
    final tenantId = inv?.tenantId ??
        InvitationResponseScreen.seedInviteTenantIds[widget.invitationId];
    if (tenantId == null) {
      return l.translate('invite_response_organization_fallback');
    }
    for (final t in _tenantStore.tenantList) {
      if (t.id == tenantId) {
        return t.name;
      }
    }
    return l.translate('invite_response_organization_fallback');
  }

  TeamRole _invitedRole(Invitation? inv) {
    return inv?.role ?? TeamRole.member;
  }

  String _inviteRoleLabel(AppLocalizations l, TeamRole role) {
    switch (role) {
      case TeamRole.owner:
        return l.translate('employee_role_owner');
      case TeamRole.admin:
        return l.translate('employee_role_manager');
      case TeamRole.member:
        return l.translate('invite_response_role_member');
    }
  }

  Future<void> _respond(bool accept) async {
    final l = AppLocalizations.of(context);
    if (widget.invitationId.trim().isEmpty) {
      setState(() => _errorMessage = l.translate('invite_response_error_invalid'));
      return;
    }

    final inv = _findInvitation();
    if (inv != null && inv.status != InvitationStatus.pending) {
      setState(() => _errorMessage = l.translate('invite_response_error_not_pending'));
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final Invitation? result = accept
        ? await _invitationRepository.acceptInvitation(widget.invitationId)
        : await _invitationRepository.declineInvitation(widget.invitationId);

    await _teamStore.loadTeamData();

    if (!mounted) {
      return;
    }
    if (result == null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = l.translate('invite_response_error_failed');
      });
      return;
    }

    setState(() {
      _isSubmitting = false;
      _finished = true;
      _accepted = accept;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Observer(
              builder: (_) {
                final inv = _findInvitation();
                final orgName = _organizationName(l, inv);
                final role = _invitedRole(inv);
                final roleLabel = _inviteRoleLabel(l, role);

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        children: [
                          _buildBrandHeader(l),
                          const SizedBox(height: 32),
                          if (_finished)
                            _buildResultCard(l)
                          else
                            _buildConfirmCard(l, orgName, roleLabel),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: l.translate('create_tenant_close_tooltip'),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader(AppLocalizations l) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_brandBlue, _brandPurple],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _brandBlue.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l.translate('create_tenant_brand_name'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _brandBlue,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          l.translate('create_tenant_welcome_title'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _brandBlue.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_welcome_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmCard(
    AppLocalizations l,
    String orgName,
    String roleLabel,
  ) {
    final baseStyle = TextStyle(
      fontSize: 15,
      height: 1.5,
      color: Colors.grey.shade800,
    );
    final boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w700,
      color: _cardTitleBlue,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.translate('invite_response_confirm_title'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _cardTitleBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            orgName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: _cardTitleBlue,
            ),
          ),
          const SizedBox(height: 18),
          Text.rich(
            TextSpan(
              style: baseStyle,
              children: [
                TextSpan(text: l.translate('invite_response_body_part1')),
                TextSpan(text: orgName, style: boldStyle),
                TextSpan(text: l.translate('invite_response_body_part2')),
                TextSpan(text: roleLabel, style: boldStyle),
                TextSpan(text: l.translate('invite_response_body_part3')),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.errorRed,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 28),
          if (_isSubmitting)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _respond(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l.translate('invite_response_decline'),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1890FF), Color(0xFF6366F1)],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _respond(true),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              l.translate('invite_response_join'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard(AppLocalizations l) {
    final ok = _accepted ?? false;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 56,
            color: ok ? Colors.green.shade600 : Colors.orange.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            ok
                ? l.translate('invite_response_success_accept')
                : l.translate('invite_response_success_decline'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: _brandBlue,
                side: BorderSide(color: _brandBlue.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(l.translate('invite_response_close')),
            ),
          ),
        ],
      ),
    );
  }
}
