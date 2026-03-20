import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';

import '../mock_data.dart';

class MockTicketLocalDataSource {
  late final List<Agent> _agents;
  late final List<Customer> _customers;
  late final List<Ticket> _tickets;
  final Map<String, List<Comment>> _ticketComments = {};

  MockTicketLocalDataSource() {
    _seedInitialData();
  }

  void _seedInitialData() {
    _agents = MockDataGenerator.generateAgents();
    _customers = MockDataGenerator.generateCustomers();
    _tickets = MockDataGenerator.generateTickets(_agents, _customers);

    for (final ticket in _tickets) {
      _ticketComments[ticket.id] = MockDataGenerator.generateCommentsForTicket(
        ticket.id,
        _agents,
      );
    }
  }

  List<Agent> getAgents() => List.unmodifiable(_agents);

  List<Customer> getCustomers() => List.unmodifiable(_customers);

  List<Ticket> getTickets() => List.unmodifiable(_tickets);

  Ticket? getTicketById(String id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (_) {
      return null;
    }
  }

  void insertTicket(Ticket ticket) {
    _tickets.add(ticket);
  }

  Ticket? updateTicket(Ticket ticket) {
    final index = _tickets.indexWhere((item) => item.id == ticket.id);
    if (index == -1) {
      return null;
    }

    _tickets[index] = ticket;
    return _tickets[index];
  }

  bool deleteTicket(String id) {
    final beforeCount = _tickets.length;
    _tickets.removeWhere((ticket) => ticket.id == id);
    _ticketComments.remove(id);
    return _tickets.length < beforeCount;
  }

  Agent? getAgentById(String id) {
    try {
      return _agents.firstWhere((agent) => agent.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Comment> getCommentsByTicketId(String ticketId) {
    return List.unmodifiable(_ticketComments[ticketId] ?? const []);
  }

  Comment addComment(String ticketId, Comment comment) {
    final comments = _ticketComments[ticketId] ?? <Comment>[];
    final next = [...comments, comment];
    _ticketComments[ticketId] = next;
    return comment;
  }
}