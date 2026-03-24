import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/presentation/team/store/team_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class InvitationResponseScreen extends StatefulWidget {
  const InvitationResponseScreen({
    super.key,
    required this.invitationId,
    required this.action,
  });

  final String invitationId;
  final String action;

  @override
  State<InvitationResponseScreen> createState() =>
      _InvitationResponseScreenState();
}

class _InvitationResponseScreenState extends State<InvitationResponseScreen> {
  final TeamStore _teamStore = getIt<TeamStore>();
  bool _isSubmitting = false;
  String? _resultMessage;

  @override
  void initState() {
    super.initState();
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAcceptAction = widget.action.toLowerCase() == 'accept';

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(title: const Text('Invitation Response')),
      body: Observer(
        builder: (_) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSubmitting
                            ? Icons.hourglass_top_rounded
                            : (isAcceptAction
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined),
                        size: 52,
                        color: _isSubmitting
                            ? Colors.orange
                            : (isAcceptAction
                                  ? Colors.green.shade700
                                  : Colors.red.shade700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isSubmitting
                            ? 'Processing invitation...'
                            : (_resultMessage ??
                                  'Unable to process invitation response.'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Invitation ID: ${widget.invitationId}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 20),
                      if (!_isSubmitting)
                        OutlinedButton(
                          onPressed: _submit,
                          child: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    final action = widget.action.toLowerCase();
    if (widget.invitationId.trim().isEmpty ||
        (action != 'accept' && action != 'decline')) {
      setState(() {
        _resultMessage = 'Invalid invitation link.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _resultMessage = null;
    });
    if (action == 'accept') {
      await _teamStore.acceptInvitation(widget.invitationId);
    } else {
      await _teamStore.declineInvitation(widget.invitationId);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
      _resultMessage = action == 'accept'
          ? 'Invitation accepted successfully.'
          : 'Invitation declined successfully.';
    });
  }
}
