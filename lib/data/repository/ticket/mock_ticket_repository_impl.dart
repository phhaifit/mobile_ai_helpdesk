import 'dart:async';

import '/domain/entity/ticket/ticket.dart';
import '/domain/repository/ticket/ticket_repository.dart';

class MockTicketRepositoryImpl implements TicketRepository {
  final List<Ticket> _mockTickets = [
    Ticket(
      id: 'TK-001',
      title: 'Cannot login to dashboard',
      description: 'User reports login failure after password reset.',
      status: TicketStatus.open,
      priority: TicketPriority.high,
      customerName: 'Nguyen Van A',
      channel: 'Email',
      createdAt: DateTime(2026, 3, 5, 10, 30),
    ),
    Ticket(
      id: 'TK-002',
      title: 'Payment processing error',
      description: 'Checkout fails with timeout error on mobile.',
      status: TicketStatus.inProgress,
      priority: TicketPriority.urgent,
      customerName: 'Tran Thi B',
      channel: 'Live Chat',
      createdAt: DateTime(2026, 3, 6, 14, 15),
    ),
    Ticket(
      id: 'TK-003',
      title: 'Feature request: dark mode',
      description: 'Customer requests dark mode support for the web app.',
      status: TicketStatus.open,
      priority: TicketPriority.low,
      customerName: 'Le Van C',
      channel: 'Messenger',
      createdAt: DateTime(2026, 3, 6, 9, 0),
    ),
    Ticket(
      id: 'TK-004',
      title: 'Shipping status not updating',
      description: 'Order tracking page shows stale data.',
      status: TicketStatus.resolved,
      priority: TicketPriority.medium,
      customerName: 'Pham Thi D',
      channel: 'Telegram',
      createdAt: DateTime(2026, 3, 4, 16, 45),
    ),
    Ticket(
      id: 'TK-005',
      title: 'API rate limit exceeded',
      description: 'Integration partner hitting rate limits during peak hours.',
      status: TicketStatus.inProgress,
      priority: TicketPriority.high,
      customerName: 'Hoang Van E',
      channel: 'Email',
      createdAt: DateTime(2026, 3, 7, 8, 0),
    ),
  ];

  @override
  Future<List<Ticket>> getTickets() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_mockTickets);
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockTickets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
