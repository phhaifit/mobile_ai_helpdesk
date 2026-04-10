import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// PROFILE SCREEN WIDGET TREE:
/// Scaffold
///   ├─ AppBar
///   └─ SafeArea
///       └─ SingleChildScrollView
///           └─ Column
///               ├─ Card (user info)
///               │   └─ Row
///               │       ├─ CircleAvatar
///               │       └─ Column (user details)
///               ├─ SizedBox
///               ├─ Card (email)
///               ├─ Card (username)
///               ├─ SizedBox
///               ├─ ListTile (change password)
///               ├─ Divider
///               └─ ListTile (logout)

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    _authStore = getIt<AuthStore>();
  }

  void _handleLogout() {
    final l = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.translate('logout_confirm_title')),
        content: Text(l.translate('logout_confirm_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.translate('logout_confirm_no')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _authStore.logout();
              
              if (mounted) {
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
            child: Text(l.translate('logout_confirm_yes')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('profile_tv_title')),
      ),
      body: SafeArea(
        child: Observer(
          builder: (_) {
            final user = _authStore.currentUser;

            if (user == null) {
              return Center(
                child: Text(l.translate('auth_error_session_expired')),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // User info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // User details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? user.username,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email card
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(l.translate('profile_tv_email')),
                      subtitle: Text(user.email),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Username card
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person_outline,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(l.translate('profile_tv_username')),
                      subtitle: Text(user.username),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone card (if available)
                  if (user.phone != null && user.phone!.isNotEmpty)
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.phone_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(l.translate('profile_tv_phone')),
                        subtitle: Text(user.phone!),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Change password button
                  ListTile(
                    leading: const Icon(Icons.lock_outlined),
                    title: Text(l.translate('profile_btn_change_password')),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.changePassword);
                    },
                  ),
                  const Divider(),

                  // Logout button
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      l.translate('profile_btn_logout'),
                      style: const TextStyle(color: Colors.red),
                    ),
                    onTap: _handleLogout,
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
