import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ticket/store/customer_history_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/status_badge_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/priority_badge_widget.dart';
import 'package:ai_helpdesk/utils/routes/routes.dart';

final _getIt = GetIt.instance;

class CustomerTicketHistoryScreen extends StatefulWidget {
  final String customerId;
  final String customerName;

  const CustomerTicketHistoryScreen({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CustomerTicketHistoryScreen> createState() =>
      _CustomerTicketHistoryScreenState();
}

class _CustomerTicketHistoryScreenState
    extends State<CustomerTicketHistoryScreen> {
  late final CustomerHistoryStore _store;

  @override
  void initState() {
    super.initState();
    _store = _getIt<CustomerHistoryStore>();
    _store.loadHistory(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử - ${widget.customerName}'),
      ),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.errorRed),
                  const SizedBox(height: 16),
                  Text(_store.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _store.loadHistory(widget.customerId),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (_store.tickets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 48, color: AppColors.textTertiary),
                  SizedBox(height: 16),
                  Text(
                    'Không có phiếu hỗ trợ nào',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Customer header card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                        child: Text(
                          widget.customerName.isNotEmpty
                              ? widget.customerName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_store.tickets.length} phiếu hỗ trợ',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Ticket list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _store.tickets.length,
                  itemBuilder: (context, index) {
                    return _buildTicketCard(_store.tickets[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.ticketDetail,
            arguments: ticket.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ticket.id,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  StatusBadgeWidget(status: ticket.status),
                  const SizedBox(width: 8),
                  PriorityBadgeWidget(priority: ticket.priority),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 20, color: AppColors.textTertiary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
