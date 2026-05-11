import 'dart:io';

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/presentation/auth/profile/store/profile_store.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Single profile screen — mirrors the web version: an inline form with an
/// editable avatar, a read-only role and email, an editable full name and
/// phone number, and an "Update" button. Sign-out lives at the bottom.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileStore _store;
  late final AuthStore _authStore;
  late final TextEditingController _fullnameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _store = getIt<ProfileStore>();
    _authStore = getIt<AuthStore>();
    final account = _authStore.account;
    if (account != null) _store.seedFrom(account);
    _fullnameCtrl = TextEditingController(text: _store.fullname);
    _phoneCtrl = TextEditingController(text: _store.phoneNumber);
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();
    final ok = await _store.save();
    if (!mounted) return;
    if (ok) {
      _fullnameCtrl.text = _store.fullname;
      _phoneCtrl.text = _store.phoneNumber;
      messenger.showSnackBar(
        SnackBar(content: Text(l.translate('profile_update_success'))),
      );
    }
  }

  /// Tapping the avatar (or its camera badge): when a photo is already set we
  /// offer a choice (view full size / replace / remove); otherwise we go
  /// straight to the picker since "choose a photo" is the only sensible action.
  Future<void> _handleAvatarTap() async {
    if (_store.isAvatarBusy) return;
    final currentUrl = _store.account?.profilePicture;
    final hasAvatar =
        _store.hasAvatar && currentUrl != null && currentUrl.isNotEmpty;
    if (!hasAvatar) {
      await _pickAndUploadAvatar();
      return;
    }
    final l = AppLocalizations.of(context);
    final action = await showModalBottomSheet<_AvatarAction>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: Text(l.translate('profile_avatar_action_view')),
              onTap: () => Navigator.pop(sheetContext, _AvatarAction.view),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l.translate('profile_avatar_action_change')),
              onTap: () =>
                  Navigator.pop(sheetContext, _AvatarAction.change),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                l.translate('profile_avatar_action_remove'),
                style: TextStyle(
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
              ),
              onTap: () =>
                  Navigator.pop(sheetContext, _AvatarAction.remove),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case _AvatarAction.view:
        await _viewAvatar(currentUrl);
      case _AvatarAction.change:
        await _pickAndUploadAvatar();
      case _AvatarAction.remove:
        await _confirmAndRemoveAvatar();
    }
  }

  /// Full-screen, pinch-to-zoom viewer for the current avatar.
  Future<void> _viewAvatar(String url) async {
    final l = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: SafeArea(
                child: IconButton(
                  tooltip: l.translate('common_back'),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pick = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = pick?.files.single.path;
    if (path == null) return;

    final ok = await _store.uploadAvatar(File(path));
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l.translate(
            ok ? 'profile_avatar_upload_success' : 'profile_avatar_upload_failed',
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndRemoveAvatar() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.translate('profile_avatar_remove_confirm_title')),
        content: Text(l.translate('profile_avatar_remove_confirm_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.translate('common_cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.translate('profile_avatar_remove_confirm_yes')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await _store.removeAvatar();
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          l.translate(
            ok ? 'profile_avatar_remove_success' : 'profile_avatar_remove_failed',
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
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
    await _authStore.signOut();
    if (!mounted) return;
    await navigator.pushNamedAndRemoveUntil(Routes.signInEmail, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('profile_tv_title'))),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final account = _store.account;
            if (account == null) {
              return Center(
                child: Text(l.translate('auth_error_session_expired')),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _buildAvatar(account)),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      l.translate('profile_tv_avatar'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LabeledField(
                    label: l.translate('profile_tv_role'),
                    required: true,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: account.role),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: l.translate('profile_tv_email'),
                    required: true,
                    child: TextField(
                      enabled: false,
                      controller: TextEditingController(text: account.email),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: l.translate('profile_tv_full_name'),
                    required: true,
                    child: TextField(
                      controller: _fullnameCtrl,
                      enabled: !_store.isSaving,
                      onChanged: _store.setFullname,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LabeledField(
                    label: l.translate('profile_tv_phone'),
                    child: TextField(
                      controller: _phoneCtrl,
                      enabled: !_store.isSaving,
                      keyboardType: TextInputType.phone,
                      onChanged: _store.setPhoneNumber,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_store.errorKey != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l.translate(_store.errorKey!),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _store.canSubmit ? _handleSave : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: _store.isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l.translate('profile_btn_update')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      l.translate('profile_btn_logout'),
                      style: const TextStyle(color: Colors.red),
                    ),
                    trailing: _authStore.isSigningOut
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: _authStore.isSigningOut ? null : _handleLogout,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar(Account account) {
    final theme = Theme.of(context);
    final hasAvatar = account.profilePicture != null &&
        account.profilePicture!.isNotEmpty;
    final busy = _store.isAvatarBusy;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: busy ? null : _handleAvatarTap,
          child: CircleAvatar(
            radius: 44,
            backgroundColor: theme.colorScheme.primary,
            backgroundImage:
                hasAvatar ? NetworkImage(account.profilePicture!) : null,
            child: hasAvatar
                ? null
                : Text(
                    account.initial,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        if (busy)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.35),
              ),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Material(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: busy ? null : _handleAvatarTap,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _AvatarAction { view, change, remove }

/// A form row: label (with optional red `*`) stacked above its input field.
class _LabeledField extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: theme.textTheme.labelLarge,
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
