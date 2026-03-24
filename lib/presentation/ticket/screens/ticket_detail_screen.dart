import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/ticket_detail_header_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/ticket_assignment_section_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/ticket_customer_info_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/ticket_description_section_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/comment_thread_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/ticket_history_timeline_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/delete_ticket_dialog.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/status_badge_widget.dart';

final _getIt = GetIt.instance;

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late final TicketDetailStore _store;

  @override
  void initState() {
    super.initState();
    _store = _getIt<TicketDetailStore>();
    _store.loadTicket(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) {
            if (_store.ticket == null) return const Text('Chi tiết phiếu');
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _store.ticket!.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadgeWidget(status: _store.ticket!.status),
              ],
            );
          },
        ),
        actions: [
          Observer(
            builder: (_) {
              if (_store.ticket == null) return const SizedBox();
              return PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Chỉnh sửa'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: AppColors.errorRed),
                        SizedBox(width: 8),
                        Text('Xóa', style: TextStyle(color: AppColors.errorRed)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.isDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, true);
            });
            return const SizedBox();
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
                    onPressed: () => _store.loadTicket(widget.ticketId),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final ticket = _store.ticket;
          if (ticket == null) {
            return const Center(child: Text('Không tìm thấy phiếu hỗ trợ'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                TicketDetailHeaderWidget(ticket: ticket),
                TicketAssignmentSectionWidget(ticket: ticket, store: _store),
                TicketCustomerInfoWidget(
                  ticket: ticket,
                  onViewHistory: () {
                    Navigator.pushNamed(
                      context,
                      '/customer_history',
                      arguments: {
                        'customerId': ticket.customerId,
                        'customerName': ticket.customerName,
                      },
                    );
                  },
                ),
                TicketDescriptionSectionWidget(ticket: ticket),
                CommentThreadWidget(store: _store),
                TicketHistoryTimelineWidget(store: _store),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'edit':
        final result = await Navigator.pushNamed(
          context,
          '/edit_ticket',
          arguments: _store.ticket,
        );
        if (result == true) {
          _store.loadTicket(widget.ticketId);
        }
        break;
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => DeleteTicketDialog(
            ticketTitle: _store.ticket?.title ?? '',
          ),
        );
        if (confirmed == true) {
          await _store.deleteTicket();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã xóa phiếu hỗ trợ')),
            );
          }
        }
        break;
    }
  }
}
