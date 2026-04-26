import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/edit_profile/store/edit_profile_store.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileStore _store;
  late final TextEditingController _fullnameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _store = getIt<EditProfileStore>();
    final account = getIt<AuthStore>().account;
    if (account != null) _store.seedFrom(account);
    _fullnameCtrl = TextEditingController(text: _store.fullname);
    _usernameCtrl = TextEditingController(text: _store.username);
    _phoneCtrl = TextEditingController(text: _store.phoneNumber);
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await _store.save();
    if (!mounted) return;
    if (ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.translate('profile_edit_saved'))),
      );
      navigator.pop(true);
    }
  }

  Future<bool> _confirmDiscardIfNeeded() async {
    if (!_store.isDirty) return true;
    final l = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.translate('profile_edit_discard_title')),
        content: Text(l.translate('profile_edit_discard_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.translate('logout_confirm_no')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.translate('profile_edit_discard_confirm')),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscardIfNeeded()) {
          if (mounted) Navigator.of(context).pop(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l.translate('profile_edit_title'))),
        body: SafeArea(
          child: Observer(
            builder: (_) {
              final account = getIt<AuthStore>().account;
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
                    TextField(
                      controller: _fullnameCtrl,
                      enabled: !_store.isSaving,
                      onChanged: _store.setFullname,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l.translate('profile_tv_full_name'),
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usernameCtrl,
                      enabled: !_store.isSaving,
                      onChanged: _store.setUsername,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l.translate('profile_tv_username'),
                        prefixIcon: const Icon(Icons.person_outline),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneCtrl,
                      enabled: !_store.isSaving,
                      keyboardType: TextInputType.phone,
                      onChanged: _store.setPhoneNumber,
                      decoration: InputDecoration(
                        labelText: l.translate('profile_tv_phone'),
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Read-only email — backend keys records by email.
                    TextField(
                      enabled: false,
                      controller: TextEditingController(text: account.email),
                      decoration: InputDecoration(
                        labelText: l.translate('profile_tv_email'),
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                        helperText:
                            l.translate('profile_edit_email_readonly_hint'),
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
                    Observer(
                      builder: (_) => FilledButton(
                        onPressed: _store.canSubmit ? _handleSave : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: _store.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l.translate('profile_edit_save')),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
