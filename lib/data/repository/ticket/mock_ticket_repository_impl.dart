import 'dart:async';

import '../../../domain/entity/agent/agent.dart';
import '../../../domain/entity/enums.dart';
import '../../../domain/entity/ticket/ticket.dart';
import '../../../domain/repository/ticket/ticket_repository.dart';

class MockTicketRepositoryImpl implements TicketRepository {
  // Mock data storage - in-memory
  late List<Ticket> _mockTickets;
  late List<Agent> _mockAgents;

  MockTicketRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Initialize mock agents
    _mockAgents = [
      Agent(
        id: 'agent_1',
        name: 'Agent One',
        email: 'agent1@helpdesk.com',
        avatar: 'https://ui-avatars.com/api/?name=Agent+One',
        department: 'Technical Support',
        isActive: true,
        createdAt: DateTime(2026, 1, 15),
      ),
      Agent(
        id: 'agent_2',
        name: 'Agent Two',
        email: 'agent2@helpdesk.com',
        avatar: 'https://ui-avatars.com/api/?name=Agent+Two',
        department: 'Billing',
        isActive: true,
        createdAt: DateTime(2026, 1, 20),
      ),
      Agent(
        id: 'agent_3',
        name: 'Agent Three',
        email: 'agent3@helpdesk.com',
        avatar: 'https://ui-avatars.com/api/?name=Agent+Three',
        department: 'Technical Support',
        isActive: true,
        createdAt: DateTime(2026, 2, 01),
      ),
      Agent(
        id: 'agent_4',
        name: 'Agent Four',
        email: 'agent4@helpdesk.com',
        avatar: 'https://ui-avatars.com/api/?name=Agent+Four',
        department: 'General Support',
        isActive: true,
        createdAt: DateTime(2026, 2, 10),
      ),
    ];

    // Initialize mock tickets
    _mockTickets = [
      Ticket(
        id: 'TK-001',
        title: 'Cannot login to dashboard',
        description: 'User reports login failure after password reset.',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        category: TicketCategory.technical,
        source: TicketSource.email,
        customerId: 'cust_1',
        customerName: 'Nguyen Van A',
        customerEmail: 'customer1@example.com',
        assignedAgentId: 'agent_1',
        assignedAgentName: 'Agent One',
        createdAt: DateTime(2026, 3, 5, 10, 30),
        updatedAt: DateTime(2026, 3, 5, 10, 30),
      ),
      Ticket(
        id: 'TK-002',
        title: 'Payment processing error',
        description: 'Checkout fails with timeout error on mobile.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.urgent,
        category: TicketCategory.billing,
        source: TicketSource.web,
        customerId: 'cust_2',
        customerName: 'Tran Thi B',
        customerEmail: 'customer2@example.com',
        assignedAgentId: 'agent_2',
        assignedAgentName: 'Agent Two',
        createdAt: DateTime(2026, 3, 6, 14, 15),
        updatedAt: DateTime(2026, 3, 6, 14, 15),
      ),
      Ticket(
        id: 'TK-003',
        title: 'Feature request: dark mode',
        description: 'Customer requests dark mode support for the web app.',
        status: TicketStatus.open,
        priority: TicketPriority.low,
        category: TicketCategory.general,
        source: TicketSource.messenger,
        customerId: 'cust_3',
        customerName: 'Le Van C',
        customerEmail: 'customer3@example.com',
        createdAt: DateTime(2026, 3, 6, 9, 0),
        updatedAt: DateTime(2026, 3, 6, 9, 0),
      ),
      Ticket(
        id: 'TK-004',
        title: 'Shipping status not updating',
        description: 'Order tracking page shows stale data.',
        status: TicketStatus.resolved,
        priority: TicketPriority.medium,
        category: TicketCategory.technical,
        source: TicketSource.email,
        customerId: 'cust_4',
        customerName: 'Pham Thi D',
        customerEmail: 'customer4@example.com',
        assignedAgentId: 'agent_3',
        assignedAgentName: 'Agent Three',
        createdAt: DateTime(2026, 3, 4, 16, 45),
        updatedAt: DateTime(2026, 3, 4, 16, 45),
        resolvedAt: DateTime(2026, 3, 5, 10, 0),
      ),
      Ticket(
        id: 'TK-005',
        title: 'API rate limit exceeded',
        description: 'Integration partner hitting rate limits during peak hours.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        category: TicketCategory.technical,
        source: TicketSource.email,
        customerId: 'cust_5',
        customerName: 'Hoang Van E',
        customerEmail: 'customer5@example.com',
        assignedAgentId: 'agent_4',
        assignedAgentName: 'Agent Four',
        createdAt: DateTime(2026, 3, 7, 8, 0),
        updatedAt: DateTime(2026, 3, 7, 8, 0),
      ),
    ];
  }

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

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Generate a new ID if empty
    final newTicket = ticket.id.isEmpty
        ? ticket.copyWith(
            id: 'TK-${_mockTickets.length + 1}',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
        : ticket.copyWith(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
    _mockTickets.add(newTicket);
    return newTicket;
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockTickets.indexWhere((t) => t.id == ticket.id);
    if (index == -1) {
      throw Exception('Ticket not found');
    }
    final updatedTicket = ticket.copyWith(updatedAt: DateTime.now());
    _mockTickets[index] = updatedTicket;
    return updatedTicket;
  }

  @override
  Future<void> deleteTicket(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTickets.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Agent>> getAvailableAgents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_mockAgents);
  }
}
