import 'dart:async';
import 'dart:math';

import 'package:ai_helpdesk/data/local/ticket/mock_ticket_local_datasource.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

class MockTicketRepositoryImpl implements TicketRepository {
  final MockTicketLocalDataSource _localDataSource;
  final Random _random = Random();

  MockTicketRepositoryImpl(this._localDataSource);

  Future<void> _simulateDelay() async {
    final milliseconds = 200 + _random.nextInt(601);
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  String _generateTicketId() {
    return 'TKT-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<List<Ticket>> getTickets({
    TicketQueryParams params = const TicketQueryParams(),
  }) async {
    await _simulateDelay();

    var result = List<Ticket>.from(_localDataSource.getTickets());

    switch (params.tab) {
      case TicketTabScope.my:
        if (params.currentAgentId == null || params.currentAgentId!.isEmpty) {
          result = [];
        } else {
          result = result
              .where((ticket) => ticket.assignedAgentId == params.currentAgentId)
              .toList();
        }
        break;
      case TicketTabScope.unassigned:
        result = result.where((ticket) => ticket.assignedAgentId == null).toList();
        break;
      case TicketTabScope.all:
        break;
    }

    if (params.search != null && params.search!.trim().isNotEmpty) {
      final query = params.search!.trim().toLowerCase();
      result = result.where((ticket) {
        return ticket.id.toLowerCase().contains(query) ||
            ticket.title.toLowerCase().contains(query) ||
            ticket.customerName.toLowerCase().contains(query);
      }).toList();
    }

    if (params.statuses != null && params.statuses!.isNotEmpty) {
      result = result.where((ticket) => params.statuses!.contains(ticket.status)).toList();
    }

    if (params.priorities != null && params.priorities!.isNotEmpty) {
      result = result
          .where((ticket) => params.priorities!.contains(ticket.priority))
          .toList();
    }

    if (params.sources != null && params.sources!.isNotEmpty) {
      result = result.where((ticket) => params.sources!.contains(ticket.source)).toList();
    }

    if (params.categories != null && params.categories!.isNotEmpty) {
      result = result
          .where((ticket) => params.categories!.contains(ticket.category))
          .toList();
    }

    if (params.createdById != null && params.createdById!.isNotEmpty) {
      result = result.where((ticket) => ticket.createdByID == params.createdById).toList();
    }

    if (params.customerId != null && params.customerId!.isNotEmpty) {
      result = result.where((ticket) => ticket.customerId == params.customerId).toList();
    }

    if (params.fromDate != null) {
      final fromDateStart = DateTime(
        params.fromDate!.year,
        params.fromDate!.month,
        params.fromDate!.day,
      );
      result = result.where((ticket) => !ticket.createdAt.isBefore(fromDateStart)).toList();
    }

    if (params.toDate != null) {
      final toDateEnd = DateTime(
        params.toDate!.year,
        params.toDate!.month,
        params.toDate!.day,
        23,
        59,
        59,
      );
      result = result.where((ticket) => !ticket.createdAt.isAfter(toDateEnd)).toList();
    }

    return List.unmodifiable(result);
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    await _simulateDelay();
    return _localDataSource.getTicketById(id);
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    await _simulateDelay();

    final now = DateTime.now();
    final newTicket = ticket.copyWith(
      id: ticket.id.isEmpty ? _generateTicketId() : ticket.id,
      createdAt: now,
      updatedAt: now,
      lastModifiedAt: now,
      isSynced: false,
      pendingAction: TicketPendingAction.create,
    );

    _localDataSource.insertTicket(newTicket);
    return newTicket;
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) async {
    await _simulateDelay();

    final existingTicket = _localDataSource.getTicketById(ticket.id);
    if (existingTicket == null) {
      throw Exception('Ticket not found');
    }

    final now = DateTime.now();
    final resolvedAt = ticket.status == TicketStatus.resolved
        ? (ticket.resolvedAt ?? now)
        : ticket.resolvedAt;

    final updatedTicket = ticket.copyWith(
      createdAt: existingTicket.createdAt,
      updatedAt: now,
      resolvedAt: resolvedAt,
      lastModifiedAt: now,
      isSynced: false,
      pendingAction: TicketPendingAction.update,
    );

    final saved = _localDataSource.updateTicket(updatedTicket);
    if (saved == null) {
      throw Exception('Failed to update ticket');
    }

    return updatedTicket;
  }

  @override
  Future<void> deleteTicket(String id) async {
    await _simulateDelay();
    final deleted = _localDataSource.deleteTicket(id);
    if (!deleted) {
      throw Exception('Ticket not found');
    }
  }

  @override
  Future<Ticket> assignAgent({required String ticketId, String? agentId}) async {
    await _simulateDelay();

    final ticket = _localDataSource.getTicketById(ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    String? assignedAgentName;
    if (agentId != null) {
      final agent = _localDataSource.getAgentById(agentId);
      if (agent == null) {
        throw Exception('Agent not found');
      }
      assignedAgentName = agent.name;
    }

    final now = DateTime.now();
    final updatedTicket = ticket.copyWith(
      assignedAgentId: agentId,
      assignedAgentName: assignedAgentName,
      updatedAt: now,
      lastModifiedAt: now,
      isSynced: false,
      pendingAction: TicketPendingAction.update,
    );

    _localDataSource.updateTicket(updatedTicket);
    return updatedTicket;
  }

  @override
  Future<Comment> addComment({required String ticketId, required Comment comment}) async {
    await _simulateDelay();

    final ticket = _localDataSource.getTicketById(ticketId);
    if (ticket == null) {
      throw Exception('Ticket not found');
    }

    final now = DateTime.now();
    final createdComment = comment.copyWith(
      id: comment.id.isEmpty
          ? 'comment_${now.millisecondsSinceEpoch}'
          : comment.id,
      ticketId: ticketId,
      createdAt: comment.createdAt,
      updatedAt: now,
    );

    _localDataSource.addComment(ticketId, createdComment);

    final updatedTicket = ticket.copyWith(
      updatedAt: now,
      lastModifiedAt: now,
      unreadCount: ticket.unreadCount + 1,
      isSynced: false,
      pendingAction: TicketPendingAction.update,
    );
    _localDataSource.updateTicket(updatedTicket);

    return createdComment;
  }

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    await _simulateDelay();
    return _localDataSource
        .getTickets()
        .where((ticket) => ticket.customerId == customerId)
        .toList();
  }

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    await _simulateDelay();
    return _localDataSource.getCommentsByTicketId(ticketId);
  }

  @override
  Future<List<Agent>> getAvailableAgents() async {
    await _simulateDelay();
    return _localDataSource.getAgents();
  }

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) async {
    await _simulateDelay();
    return _localDataSource.getHistoryByTicketId(ticketId);
  }
}
