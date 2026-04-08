import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '/domain/entity/playground/playground_session.dart';
import '/presentation/playground/store/playground_store.dart';
import '/utils/locale/app_localization.dart';

/// Side drawer showing session history.
/// Tapping a session switches the active session in [PlaygroundStore].
class SessionHistoryDrawer extends StatelessWidget {
  final PlaygroundStore store;
  final VoidCallback onNewSession;

  const SessionHistoryDrawer({
    super.key,
    required this.store,
    required this.onNewSession,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.translate('playground_session_history'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: theme.colorScheme.onPrimary,
                  ),
                  tooltip: l.translate('playground_new_session'),
                  onPressed: onNewSession,
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(builder: (_) {
              if (store.sessions.isEmpty) {
                return Center(
                  child: Text(l.translate('playground_no_sessions')),
                );
              }
              return ListView.builder(
                itemCount: store.sessions.length,
                itemBuilder: (_, i) {
                  final session = store.sessions[i];
                  final isActive =
                      store.activeSession?.id == session.id;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        session.contextType == PlaygroundContextType.lazada
                            ? Icons.shopping_bag_outlined
                            : Icons.support_agent_outlined,
                        color: isActive
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      '${l.translate('playground_session_label')} ${i + 1}',
                      style: TextStyle(
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      session.contextType == PlaygroundContextType.lazada
                          ? l.translate('playground_context_lazada')
                          : l.translate('playground_context_normal'),
                      style: theme.textTheme.bodySmall,
                    ),
                    selected: isActive,
                    onTap: () {
                      store.openSession(session);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
