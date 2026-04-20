import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/widgets/account_menu_sheet.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Reactive footer used by the sidebar. Tap opens [AccountMenuSheet] with
/// Profile / Change avatar / Sign out. When [AuthStore.account] is null
/// (cold start, not yet hydrated) renders a neutral placeholder.
class SidebarProfileSection extends StatelessWidget {
  const SidebarProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Observer(
        builder: (_) {
          final account = authStore.account;
          final displayName = (account?.fullname.isNotEmpty ?? false)
              ? account!.fullname
              : account?.username ?? l.translate('profile_tv_signed_out');
          final displayRole =
              account?.role ?? l.translate('profile_tv_no_account');
          final avatarUrl = account?.profilePicture;
          final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: account == null
                ? null
                : () => AccountMenuSheet.show(context, account),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary,
                    backgroundImage:
                        hasAvatar ? NetworkImage(avatarUrl) : null,
                    child: hasAvatar
                        ? null
                        : Text(
                            account?.initial ?? '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          displayRole,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
