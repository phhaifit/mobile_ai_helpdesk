import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ZaloAccountAssignmentScreen extends StatefulWidget {
  const ZaloAccountAssignmentScreen({super.key});

  @override
  State<ZaloAccountAssignmentScreen> createState() =>
      _ZaloAccountAssignmentScreenState();
}

class _ZaloAccountAssignmentScreenState
    extends State<ZaloAccountAssignmentScreen> {
  late final OmnichannelStore _store;
  late final TeamStore _teamStore;
  final Map<String, String> _selectedAgentByAccountId = <String, String>{};

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
    _teamStore = getIt<TeamStore>();

    // Load team data if not already loaded
    if (_teamStore.teamMembers.isEmpty) {
      _teamStore.loadTeamData();
    }

    _store.fetchOverview().then((_) {
      final assignments = _store.overview?.zalo.assignments;
      if (assignments == null || !mounted) {
        return;
      }

      setState(() {
        for (final item in assignments) {
          _selectedAgentByAccountId[item.accountId] = item.assignedCs;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('omnichannel_zalo_assignment_title')),
      ),
      body: Observer(
        builder: (_) {
          final assignments = _store.overview?.zalo.assignments;
          final teamMembers = _teamStore.teamMembers;

          _showActionMessageIfNeeded(context);

          if ((assignments == null || _teamStore.isLoading) && _store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (assignments == null) {
            return Center(
              child: Text(l.translate('omnichannel_generic_error')),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...assignments.map((item) {
                final currentId =
                    _selectedAgentByAccountId[item.accountId] ??
                    item.assignedCs;

                // Ensure the current ID exists in the dropdown items to prevent crashes.
                // If it doesn't exist (e.g., empty string or deleted user), default to unassigned (empty string).
                final dropdownValue = teamMembers.any((m) => m.id == currentId)
                    ? currentId
                    : '';

                return Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.accountName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black.withValues(alpha: 0.04),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          value: dropdownValue,
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text(
                                l.translate('omnichannel_unassigned'),
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                            ...teamMembers.map(
                              (m) => DropdownMenuItem<String>(
                                value: m.id,
                                child: Text(
                                  m.displayName ?? m.email,
                                  style: const TextStyle(color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedAgentByAccountId[item.accountId] = value ?? '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _store.isLoading ? null : _saveAssignments,
                icon: const Icon(Icons.save),
                label: Text(l.translate('omnichannel_save_button')),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveAssignments() async {
    final assignments = _store.overview?.zalo.assignments;
    if (assignments == null) {
      return;
    }

    final updates = assignments
        .map(
          (item) => ZaloAssignmentUpdate(
            accountId: item.accountId,
            assignedCs:
                _selectedAgentByAccountId[item.accountId] ?? item.assignedCs,
          ),
        )
        .toList(growable: false);

    await _store.updateZaloAssignments(updates);
  }

  void _showActionMessageIfNeeded(BuildContext context) {
    final messageKey = _store.actionMessageKey;
    if (messageKey == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.translate(messageKey)),
          backgroundColor: _store.actionWasSuccess ? Colors.green : Colors.red,
        ),
      );
      _store.clearActionMessage();
    });
  }
}
