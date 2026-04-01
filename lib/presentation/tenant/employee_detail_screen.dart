import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({required this.member, super.key});

  final TeamMember member;

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final TeamStore _teamStore = getIt<TeamStore>();
  late final String _memberId;
  late TeamRole _role;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isSaving = false;
  bool _isDeleting = false;

  static const Color _headerBlue = Color(0xFF0D1B3E);

  @override
  void initState() {
    super.initState();
    _memberId = widget.member.id;
    _applyMember(widget.member);
  }

  void _applyMember(TeamMember member) {
    _role = member.role;
    final trimmedName = member.displayName?.trim();
    _fullNameController.text = (trimmedName != null && trimmedName.isNotEmpty)
        ? trimmedName
        : member.email.split('@').first;
    _phoneController.text = member.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
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

  String _initialLetter(TeamMember member) {
    final name = _displayName(member);
    if (name.isEmpty) {
      return '?';
    }
    return name[0].toUpperCase();
  }

  Future<void> _onSave() async {
    setState(() => _isSaving = true);
    final ok = await _teamStore.updateMemberProfile(
      memberId: _memberId,
      displayName: _fullNameController.text,
      phoneNumber: _phoneController.text,
      role: _role,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    if (ok) {
      final i = _teamStore.teamMembers.indexWhere((m) => m.id == _memberId);
      if (i >= 0) {
        _applyMember(_teamStore.teamMembers[i]);
      }
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.translate('employee_detail_snackbar_updated'))),
      );
    } else {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.translate('employee_detail_snackbar_save_failed'))),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dl = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(dl.translate('employee_detail_dialog_delete_title')),
          content: Text(dl.translate('employee_detail_dialog_delete_body')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dl.translate('common_cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
              child: Text(dl.translate('employee_detail_delete')),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }
    setState(() => _isDeleting = true);
    final ok = await _teamStore.removeMember(_memberId);
    if (!mounted) {
      return;
    }
    setState(() => _isDeleting = false);
    if (ok) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.translate('employee_detail_snackbar_removed'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.translate('employee_detail_snackbar_delete_failed'))),
      );
    }
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
  }

  Widget _labeledRow({
    required bool isMobile,
    required String label,
    required Widget field,
    bool forceHorizontal = false,
  }) {
    if (isMobile && !forceHorizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: field),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.backgroundGrey,
              elevation: 0,
              foregroundColor: AppColors.textPrimary,
              title: Text(l.translate('employee_detail_appbar')),
            )
          : null,
      body: Observer(
        builder: (_) {
          TeamMember? member;
          try {
            member = _teamStore.teamMembers.firstWhere((m) => m.id == _memberId);
          } catch (_) {
            member = null;
          }

          if (member == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.translate('employee_detail_unavailable'),
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l.translate('employee_detail_go_back')),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    Text(
                      l.translate('employee_detail_title').replaceAll('{name}', _displayName(member)),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: _headerBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.translate('employee_detail_subtitle'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionCard(
                      child: Column(
                        spacing: 12,
                        children: [
                          _labeledRow(
                            isMobile: isMobile,
                            forceHorizontal: true,
                            label: l.translate('employee_detail_profile_picture'),
                            field: Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xFF4A5A6A),
                                child: Text(
                                  _initialLetter(member),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _divider(),
                          const SizedBox(height: 16),
                          _labeledRow(
                            isMobile: isMobile,
                            forceHorizontal: true,
                            label: l.translate('employee_detail_email'),
                            field: Text(
                              member.email,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _divider(),
                          const SizedBox(height: 16),
                          _labeledRow(
                            isMobile: isMobile,
                            label: l.translate('employee_detail_position'),
                            field: InputDecorator(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<TeamRole>(
                                  value: _role,
                                  isExpanded: true,
                                  isDense: true,
                                  items: TeamRole.values
                                      .map(
                                        (r) => DropdownMenuItem<TeamRole>(
                                          value: r,
                                          child: Text(_roleLabel(l, r)),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _role = value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          _divider(),
                          const SizedBox(height: 16),
                          _labeledRow(
                            isMobile: isMobile,
                            label: l.translate('employee_detail_full_name'),
                            field: TextField(
                              controller: _fullNameController,
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
                          _divider(),
                          const SizedBox(height: 16),
                          _labeledRow(
                            isMobile: isMobile,
                            label: l.translate('employee_detail_phone'),
                            field: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
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
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton(
                              onPressed: (_isSaving || _teamStore.isLoading)
                                  ? null
                                  : _onSave,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF4057D6),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(l.translate('employee_detail_save_changes')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.translate('employee_detail_zalo_channels'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _headerBlue,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                l.translate('employee_detail_zalo_empty'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _sectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.translate('employee_detail_delete_section'),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _headerBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l.translate('employee_detail_delete_warning'),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: (_isDeleting || _teamStore.isLoading)
                                ? null
                                : _confirmDelete,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF04E4E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isDeleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(l.translate('employee_detail_delete')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
