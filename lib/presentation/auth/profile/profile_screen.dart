import 'dart:io';

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/usecase/account/upload_avatar_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthStore _authStore;
  late final UploadAvatarUseCase _uploadAvatarUseCase;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
    _uploadAvatarUseCase = getIt<UploadAvatarUseCase>();
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

  Future<void> _handleChangeAvatar() async {
    if (_uploadingAvatar) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pick = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = pick?.files.single.path;
    if (path == null) return;

    setState(() => _uploadingAvatar = true);
    final result = await _uploadAvatarUseCase.call(params: File(path));
    if (!mounted) return;
    setState(() => _uploadingAvatar = false);

    await result.fold<Future<void>>(
      (failure) async {
        messenger.showSnackBar(
          SnackBar(content: Text(l.translate('profile_avatar_upload_failed'))),
        );
      },
      (_) async {
        await _authStore.refreshAccount();
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text(l.translate('profile_avatar_upload_success'))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('profile_tv_title')),
        actions: [
          Observer(
            builder: (_) => _authStore.account == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l.translate('profile_menu_edit'),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.editProfile),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final account = _authStore.account;
            if (account == null) {
              return Center(
                child: Text(l.translate('auth_error_session_expired')),
              );
            }

            final hasAvatar = account.profilePicture != null &&
                account.profilePicture!.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: theme.colorScheme.primary,
                                backgroundImage: hasAvatar
                                    ? NetworkImage(account.profilePicture!)
                                    : null,
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
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Material(
                                  color: theme.colorScheme.primary,
                                  shape: const CircleBorder(),
                                  elevation: 2,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: _uploadingAvatar
                                        ? null
                                        : _handleChangeAvatar,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: _uploadingAvatar
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.camera_alt,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  account.email,
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(account.role),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(l.translate('profile_tv_email')),
                      subtitle: Text(account.email),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person_outline,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(l.translate('profile_tv_username')),
                      subtitle: Text(account.username),
                    ),
                  ),
                  if (account.phoneNumber != null &&
                      account.phoneNumber!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.phone_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(l.translate('profile_tv_phone')),
                        subtitle: Text(account.phoneNumber!),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  Observer(
                    builder: (_) => ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        l.translate('profile_btn_logout'),
                        style: const TextStyle(color: Colors.red),
                      ),
                      trailing: _authStore.isSigningOut
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                      onTap: _authStore.isSigningOut ? null : _handleLogout,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
