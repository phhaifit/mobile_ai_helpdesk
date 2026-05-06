import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/models/ticket/ticket_api_model.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';

/// Real [TicketRepository] implementation.
///
/// **My scope** (customer history + comments) calls the real REST API via
/// [TicketApi].
///
/// **Ticket core** (list, detail, create, update, assignment, status) uses
/// real REST APIs when available. Missing endpoints fall back to mock for now.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _api;
  final MockTicketRepositoryImpl _mock;

  TicketRepositoryImpl(this._api, this._mock);

  // ── My scope: Customer ticket history ──────────────────────────────────────

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    final raw = await _api.getCustomerTickets(customerId);
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TicketApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
  }

  // ── My scope: Comments ─────────────────────────────────────────────────────

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    final raw = await _api.getComments(ticketId);
    return raw
        .whereType<Map<String, dynamic>>()
        .map(CommentApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    final data = await _api.addComment(ticketId, comment.content);

    // If the server returned a populated object, use the server-assigned id and
    // timestamp; otherwise fall back to the optimistic comment from the store.
    if (data.isNotEmpty && (data['id'] as String?)?.isNotEmpty == true) {
      final apiModel = CommentApiModel.fromJson(data);
      return comment.copyWith(id: apiModel.id, createdAt: apiModel.createdAt);
    }
    // Assign a temporary id so the UI can display the comment immediately.
    return comment.copyWith(
      id:
          comment.id.isNotEmpty
              ? comment.id
              : 'tmp_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // ── Ticket core APIs ──────────────────────────────────────────────────────

  @override
  Future<List<Ticket>> getTickets({
    TicketQueryParams params = const TicketQueryParams(),
  }) async {
    final raw = await _getTicketsFromApi(params);
    return _mapTickets(raw);
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    final data = await _api.getTicketDetail(id);
    if (data.isEmpty) return null;
    return TicketApiModel.fromJson(data).toDomain();
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    final data = await _api.createTicket(
      title: ticket.title,
      description: ticket.description.isEmpty ? null : ticket.description,
      customerId: ticket.customerId,
      priority: _mapPriorityToApi(ticket.priority),
    );

    if (data.isEmpty || (data['id'] as String?)?.isEmpty == true) {
      return _mock.createTicket(ticket);
    }

    final apiTicket = TicketApiModel.fromJson(data).toDomain();
    return _mergeTicket(ticket, apiTicket);
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) async {
    await _api.updateTicketDetail(
      ticketId: ticket.id,
      title: ticket.title.isEmpty ? null : ticket.title,
      priority: _mapPriorityToApi(ticket.priority),
      assigneeId: ticket.assignedAgentId,
      includeAssigneeId: true,
    );

    final status = _mapStatusToApi(ticket.status);
    if (status != null) {
      await _api.updateTicketStatus(ticketId: ticket.id, status: status);
    }

    final refreshed = await getTicketById(ticket.id);
    if (refreshed != null) {
      return _mergeTicket(ticket, refreshed);
    }

    return ticket.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteTicket(String id) {
    // TODO: Replace with delete ticket API when available.
    return _mock.deleteTicket(id);
  }

  @override
  Future<Ticket> assignAgent({
    required String ticketId,
    String? agentId,
  }) async {
    await _api.updateTicketDetail(
      ticketId: ticketId,
      assigneeId: agentId,
      includeAssigneeId: true,
    );

    final refreshed = await getTicketById(ticketId);
    if (refreshed != null) {
      return refreshed;
    }

    return _mock.assignAgent(ticketId: ticketId, agentId: agentId);
  }

  @override
  Future<List<Agent>> getAvailableAgents() {
    // TODO: Replace with agents API when available.
    return _mock.getAvailableAgents();
  }

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) {
    // TODO: Replace with ticket history API when available.
    return _mock.getTicketHistory(ticketId);
  }

  Future<List<dynamic>> _getTicketsFromApi(TicketQueryParams params) {
    switch (params.tab) {
      case TicketTabScope.my:
        if (params.statuses != null && params.statuses!.length == 1) {
          final status = _mapStatusToApi(params.statuses!.first);
          if (status != null) {
            return _api.getMyTicketsByStatus(status);
          }
        }
        return _api.getMyTickets(offset: params.offset, limit: params.limit);
      case TicketTabScope.unassigned:
        return _api.getUnassignedTickets(
          offset: params.offset,
          limit: params.limit,
        );
      case TicketTabScope.all:
        return _api.getAllTickets(
          offset: params.offset,
          limit: params.limit,
          search: params.search,
        );
    }
  }

  List<Ticket> _mapTickets(List<dynamic> raw) {
    return raw
        .whereType<Map<String, dynamic>>()
        .map(TicketApiModel.fromJson)
        .map((model) => model.toDomain())
        .toList();
  }

  Ticket _mergeTicket(Ticket base, Ticket apiTicket) {
    return base.copyWith(
      id: apiTicket.id.isNotEmpty ? apiTicket.id : base.id,
      title: apiTicket.title.isNotEmpty ? apiTicket.title : base.title,
      status: apiTicket.status,
      priority: apiTicket.priority,
      source: apiTicket.source,
      customerId:
          apiTicket.customerId.isNotEmpty
              ? apiTicket.customerId
              : base.customerId,
      assignedAgentId: apiTicket.assignedAgentId,
      createdAt: apiTicket.createdAt,
      updatedAt: apiTicket.updatedAt,
    );
  }

  String? _mapStatusToApi(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'open';
      case TicketStatus.pending:
        return 'pending';
      case TicketStatus.resolved:
        return 'solved';
      case TicketStatus.closed:
        return 'closed';
      case TicketStatus.inProgress:
      case TicketStatus.processingByAI:
        return null;
    }
  }

  String _mapPriorityToApi(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'low';
      case TicketPriority.medium:
        return 'medium';
      case TicketPriority.high:
        return 'high';
      case TicketPriority.urgent:
        return 'urgent';
    }
  }
}
