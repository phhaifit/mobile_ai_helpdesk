import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/ticket_card_widget.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class CustomerTicketSection extends StatelessWidget {
  final CustomerDetailStore store;
  final String customerId;

  const CustomerTicketSection({
    required this.store,
    required this.customerId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SectionContainer(
      title: l10n.translate('customer_detail_section_tickets'),
      child: Observer(
        builder: (_) {
          final future = store.ticketsFuture;
          if (future == null || future.status == FutureStatus.pending) {
            return const _SectionLoader();
          }
          if (future.status == FutureStatus.rejected) {
            return _SectionError(
              onRetry: () => store.refreshTickets(customerId),
            );
          }
          final tickets = store.tickets;
          if (tickets.isEmpty) {
            return _SectionEmpty(
              message: l10n.translate('customer_detail_tickets_empty'),
              icon: Icons.confirmation_num_outlined,
            );
          }
          return Column(
            children: tickets
                .map(
                  (t) => _CompactTicketTile(
                    ticket: t,
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.ticketDetail,
                      arguments: t.id,
                    ),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

/// A condensed ticket row tailored to the customer-detail timeline.
/// Reuses the same status/priority badges as [TicketCardWidget] but drops the
/// horizontal margins so it nests cleanly inside the section card.
class _CompactTicketTile extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;

  const _CompactTicketTile({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TicketCardWidget(ticket: ticket, onTap: onTap),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(height: 24, color: Colors.grey.shade300),
            child,
          ],
        ),
      ),
    );
  }
}

class _SectionLoader extends StatelessWidget {
  const _SectionLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  final String message;
  final IconData icon;

  const _SectionEmpty({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  final VoidCallback onRetry;

  const _SectionError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 32),
            const SizedBox(height: 8),
            Text(
              l10n.translate('customer_detail_section_error'),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(l10n.translate('customer_detail_section_retry')),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}
