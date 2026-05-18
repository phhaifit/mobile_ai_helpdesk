import 'package:ai_helpdesk/data/local/datasources/ticket/mock_ticket_datasource.dart';
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
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Real [TicketRepository] implementation.
///
/// **Customer history** calls the real REST API via [TicketApi] and falls back
/// to [MockTicketDataSource] in debug builds when the backend returns 404/5xx
/// or a network error — so the customer-detail flow stays exercisable before
/// the route is stable. 401/403 still propagate so auth flows behave
/// realistically.
///
/// **Comments** and **ticket core** (list, detail, create, update, assignment,
/// status) use real REST APIs. Missing endpoints fall back to mock for now.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _api;
  final MockTicketRepositoryImpl _mock;
  final MockTicketDataSource? _fallbackTickets;

  TicketRepositoryImpl(this._api, this._mock, [this._fallbackTickets]);

  // ── Debug fallback helper ─────────────────────────────────────────────────

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _fallbackTickets == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true;
    if (code == 404) return true;
    if (code >= 500) return true;
    return false;
  }

  // ── Customer ticket history ───────────────────────────────────────────────

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    try {
      final dtos = await _api.getCustomerTickets(customerId);
      return dtos.map((d) => d.toEntity()).toList(growable: false);
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(
            '[TicketRepo] getCustomerHistory failed '
            '(${e.response?.statusCode ?? e.type.name}); using mock data.',
          );
        }
        return _fallbackTickets!.getCustomerTickets(customerId);
      }
      rethrow;
    }
  }

  // ── Comments ──────────────────────────────────────────────────────────────

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    final raw = await _api.getComments(ticketId);
    final comments = raw
        .whereType<Map<String, dynamic>>()
        .map(CommentApiModel.fromJson)
        .map((m) => m.toDomain())
        .toList();
    // BE returns newest-first; flip to oldest-first so the comment thread
    // reads top-to-bottom like a conversation (latest at the bottom).
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return comments;
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    final data = await _api.addComment(ticketId, comment.content);
    // BE response includes the full comment object (id, timestamps, author
    // resolved under `customerSupport`). Use it directly so the UI shows the
    // canonical record instead of the optimistic placeholder.
    if (data.isNotEmpty) {
      final apiModel = CommentApiModel.fromJson(data);
      if (apiModel.id.isNotEmpty) {
        // BE doesn't model public/internal — preserve the local choice.
        return apiModel.toDomain().copyWith(type: comment.type);
      }
    }
    // Fallback: keep the comment visible with a temp id when the response
    // shape is unexpected (e.g., legacy gateway).
    return comment.copyWith(
      id: comment.id.isNotEmpty
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
    if (data.isEmpty || ((data['id'] as String?)?.isEmpty ?? false)) {
      return _mock.createTicket(ticket);
    }
    final apiTicket = TicketApiModel.fromJson(data).toDomain();
    return _mergeTicket(ticket, apiTicket);
  }

  @override
  Future<Ticket> updateTicket(Ticket ticket) async {
    // Full-edit save: include every field the user could have changed in
    // a single POST to /ticket/my-ticket/{id}/detail.
    await _api.updateTicketDetail(
      ticketId: ticket.id,
      title: ticket.title.isEmpty ? null : ticket.title,
      priority: _mapPriorityToApi(ticket.priority),
      status: _mapStatusToApi(ticket.status),
      customerSupportId: ticket.assignedAgentId,
      includeCustomerSupportId: true,
    );
    final refreshed = await getTicketById(ticket.id);
    if (refreshed != null) {
      return _mergeTicket(ticket, refreshed);
    }
    return ticket.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<Ticket> updateStatus({
    required String ticketId,
    required TicketStatus status,
  }) async {
    // Web sends only `{ticketID, status}` for a status change — mirror that
    // so the BE doesn't reinterpret the payload as an assignment.
    final mapped = _mapStatusToApi(status);
    if (mapped != null) {
      await _api.updateTicketDetail(ticketId: ticketId, status: mapped);
    }
    final refreshed = await getTicketById(ticketId);
    if (refreshed != null) return refreshed;
    return _mock.updateTicketStatus(ticketId: ticketId, newStatus: status);
  }

  @override
  Future<Ticket> updatePriority({
    required String ticketId,
    required TicketPriority priority,
  }) async {
    // Web sends only `{ticketID, priority}` for a priority change.
    await _api.updateTicketDetail(
      ticketId: ticketId,
      priority: _mapPriorityToApi(priority),
    );
    final refreshed = await getTicketById(ticketId);
    if (refreshed != null) return refreshed;
    // Mock fallback: synthesise the change locally.
    final current = await _mock.getTicketById(ticketId);
    if (current != null) {
      return _mock.updateTicket(current.copyWith(priority: priority));
    }
    throw Exception('Ticket not found');
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
    // Web sends `{customerSupportID, ticketID, status}` — include the current
    // status so the BE keeps it (it can't infer from the payload alone).
    final current = await getTicketById(ticketId);
    final status = current != null ? _mapStatusToApi(current.status) : null;
    await _api.updateTicketDetail(
      ticketId: ticketId,
      customerSupportId: agentId,
      includeCustomerSupportId: true,
      status: status,
    );
    final refreshed = await getTicketById(ticketId);
    if (refreshed != null) return refreshed;
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

  // ── Private helpers ───────────────────────────────────────────────────────

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
      customerId: apiTicket.customerId.isNotEmpty
          ? apiTicket.customerId
          : base.customerId,
      assignedAgentId: apiTicket.assignedAgentId,
      createdAt: apiTicket.createdAt,
      updatedAt: apiTicket.updatedAt,
    );
  }

  /// BE enum is UPPERCASE — `OPEN | PENDING | SOLVED | CLOSED`. Client-only
  /// states (`inProgress`, `processingByAI`) have no server equivalent.
  String? _mapStatusToApi(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'OPEN';
      case TicketStatus.pending:
        return 'PENDING';
      case TicketStatus.resolved:
        return 'SOLVED';
      case TicketStatus.closed:
        return 'CLOSED';
      case TicketStatus.inProgress:
      case TicketStatus.processingByAI:
        return null;
    }
  }

  /// BE enum is UPPERCASE — `LOW | MEDIUM | HIGH | URGENT`.
  String _mapPriorityToApi(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return 'LOW';
      case TicketPriority.medium:
        return 'MEDIUM';
      case TicketPriority.high:
        return 'HIGH';
      case TicketPriority.urgent:
        return 'URGENT';
    }
  }
}