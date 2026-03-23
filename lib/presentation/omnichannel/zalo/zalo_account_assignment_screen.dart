import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:mobile_ai_helpdesk/presentation/omnichannel/store/omnichannel_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
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
  final Map<String, String> _selectedAgentByAccountId = <String, String>{};

  final List<String> _agents = const [
    'Nguyen Ha Linh',
    'Tran Minh Quan',
    'Le Thu Anh',
    'Pham Gia Bao',
  ];

  @override
  void initState() {
    super.initState();
    _store = getIt<OmnichannelStore>();
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
          _showActionMessageIfNeeded(context);

          if (assignments == null && _store.isLoading) {
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
                final current =
                    _selectedAgentByAccountId[item.accountId] ??
                    item.assignedCs;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.accountName,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: current,
                          items: _agents
                              .map(
                                (agent) => DropdownMenuItem(
                                  value: agent,
                                  child: Text(agent),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedAgentByAccountId[item.accountId] = value;
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
