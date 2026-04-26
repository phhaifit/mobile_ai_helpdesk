import 'dart:io';

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/usecase/account/upload_avatar_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Bottom-sheet account menu opened from the sidebar profile chip. Shows
/// the real signed-in account plus shortcuts: view profile, change avatar,
/// sign out. Kept intentionally stateless — all state lives in [AuthStore].
class AccountMenuSheet extends StatelessWidget {
  final Account account;
  const AccountMenuSheet({required this.account, super.key});

  static Future<void> show(BuildContext context, Account account) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => AccountMenuSheet(account: account),
    );
  }

  Future<void> _openProfile(BuildContext context) async {
    Navigator.pop(context);
    await Navigator.of(context).pushNamed(Routes.profile);
  }

  Future<void> _openEdit(BuildContext context) async {
    Navigator.pop(context);
    await Navigator.of(context).pushNamed(Routes.editProfile);
  }

  Future<void> _uploadAvatar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    final useCase = getIt<UploadAvatarUseCase>();
    final authStore = getIt<AuthStore>();
    final outcome = await useCase.call(params: File(path));
    await outcome.fold<Future<void>>(
      (failure) async {
        messenger.showSnackBar(
          SnackBar(content: Text(l.translate('profile_avatar_upload_failed'))),
        );
      },
      (_) async {
        await authStore.refreshAccount();
        messenger.showSnackBar(
          SnackBar(content: Text(l.translate('profile_avatar_upload_success'))),
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final authStore = getIt<AuthStore>();
    Navigator.pop(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.translate('logout_confirm_title')),
        content: Text(l.translate('logout_confirm_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.translate('logout_confirm_no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.translate('logout_confirm_yes')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await authStore.signOut();
    await navigator.pushNamedAndRemoveUntil(Routes.signInEmail, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary,
                  backgroundImage: _hasAvatar
                      ? NetworkImage(account.profilePicture!)
                      : null,
                  child: _hasAvatar
                      ? null
                      : Text(
                          account.initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (account.fullname?.isNotEmpty ?? false)
                            ? account.fullname!
                            : account.username,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        account.email,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(account.role),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(l.translate('profile_menu_view')),
            onTap: () => _openProfile(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l.translate('profile_menu_edit')),
            onTap: () => _openEdit(context),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(l.translate('profile_menu_change_avatar')),
            onTap: () => _uploadAvatar(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              l.translate('profile_btn_logout'),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _signOut(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  bool get _hasAvatar =>
      account.profilePicture != null && account.profilePicture!.isNotEmpty;
}
