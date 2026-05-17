import 'package:ai_helpdesk/data/local/datasources/ticket/mock_ticket_datasource.dart';
import 'package:ai_helpdesk/data/models/ticket/comment_api_model.dart';
import 'package:ai_helpdesk/data/models/ticket/ticket_api_model.dart';
import 'package:ai_helpdesk/data/network/apis/chat_room/chat_room_api.dart';
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
/// **Sub-issue B (customer history + comments)** uses real REST APIs.
/// Comments are sourced from the chat-room REST + Socket.io channel — the
/// ticket's `chatRoomId` is resolved on demand from [TicketApi.getTicketDetail]
/// before each load/send. Optimistic fallbacks keep the UI usable when
/// `chatRoomId` or `channelID` are missing.
///
/// **Customer history** calls the real REST API via [TicketApi] and falls back
/// to [MockTicketDataSource] in debug builds when the backend returns 404/5xx
/// or a network error — so the customer-detail flow stays exercisable before
/// the route is stable. 401/403 still propagate so auth flows behave
/// realistically.
///
/// **Ticket core** (list, detail, create, update, assignment, status) uses
/// real REST APIs. Missing endpoints (delete, history, available-agents)
/// still fall back to the mock for now.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _ticketApi;
  final ChatRoomApi _chatRoomApi;
  final MockTicketRepositoryImpl _mock;
  final MockTicketDataSource? _fallbackTickets;

  TicketRepositoryImpl(
    this._ticketApi,
    this._chatRoomApi,
    this._mock, [
    this._fallbackTickets,
  ]);

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
      final raw = await _ticketApi.getCustomerHistory(customerId);
      return raw
          .whereType<Map<String, dynamic>>()
          .map(TicketApiModel.fromJson)
          .map((m) => m.toDomain())
          .toList();
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

  // ── Chat-room messages (surfaced as "comments") ───────────────────────────

  @override
  Future<List<Comment>> getComments(String ticketId) async {
    try {
      final ticketData = await _ticketApi.getTicketDetail(ticketId);
      final chatRoomId = ticketData['chatRoomId'] as String?;
      if (chatRoomId == null || chatRoomId.isEmpty) return const [];

      final raw = await _chatRoomApi.getMessages(chatRoomId);
      return raw
          .whereType<Map<String, dynamic>>()
          .map(CommentApiModel.fromJson)
          .map((m) => m.toDomain())
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) async {
    try {
      final ticketData = await _ticketApi.getTicketDetail(ticketId);
      final chatRoomId = ticketData['chatRoomId'] as String?;
      if (chatRoomId == null || chatRoomId.isEmpty) {
        return _optimisticComment(comment);
      }

      final detail = await _chatRoomApi.getChatRoomDetail(chatRoomId);
      final lastMessage = detail['lastMessage'] as Map?;
      final channelId = lastMessage?['channelID'] as String? ?? '';
      final contactId = lastMessage?['contactID'] as String?;

      if (channelId.isEmpty) return _optimisticComment(comment);

      final data = await _chatRoomApi.sendMessage(
        chatRoomId: chatRoomId,
        channelId: channelId,
        content: comment.content,
        contactId: contactId,
      );

      if (data.isNotEmpty) {
        final model = CommentApiModel.fromJson(data);
        return comment.copyWith(id: model.id, createdAt: model.createdAt);
      }
      return _optimisticComment(comment);
    } catch (_) {
      return _optimisticComment(comment);
    }
  }

  Comment _optimisticComment(Comment comment) => comment.copyWith(
        id: comment.id.isNotEmpty
            ? comment.id
            : 'tmp_${DateTime.now().millisecondsSinceEpoch}',
      );

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
    final data = await _ticketApi.getTicketDetail(id);
    if (data.isEmpty) return null;
    return TicketApiModel.fromJson(data).toDomain();
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    final data = await _ticketApi.createTicket(
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
    await _ticketApi.updateTicketDetail(
      ticketId: ticket.id,
      title: ticket.title.isEmpty ? null : ticket.title,
      priority: _mapPriorityToApi(ticket.priority),
      assigneeId: ticket.assignedAgentId,
      includeAssigneeId: true,
    );
    final status = _mapStatusToApi(ticket.status);
    if (status != null) {
      await _ticketApi.updateTicketStatus(ticketId: ticket.id, status: status);
    }
    final refreshed = await getTicketById(ticket.id);
    if (refreshed != null) {
      return _mergeTicket(ticket, refreshed);
    }
    return ticket.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteTicket(String id) {
    return _mock.deleteTicket(id);
  }

  @override
  Future<Ticket> assignAgent({
    required String ticketId,
    String? agentId,
  }) async {
    await _ticketApi.updateTicketDetail(
      ticketId: ticketId,
      assigneeId: agentId,
      includeAssigneeId: true,
    );
    final refreshed = await getTicketById(ticketId);
    if (refreshed != null) return refreshed;
    return _mock.assignAgent(ticketId: ticketId, agentId: agentId);
  }

  @override
  Future<List<Agent>> getAvailableAgents() {
    return _mock.getAvailableAgents();
  }

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) {
    return _mock.getTicketHistory(ticketId);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<List<dynamic>> _getTicketsFromApi(TicketQueryParams params) {
    switch (params.tab) {
      case TicketTabScope.my:
        if (params.statuses != null && params.statuses!.length == 1) {
          final status = _mapStatusToApi(params.statuses!.first);
          if (status != null) {
            return _ticketApi.getMyTicketsByStatus(status);
          }
        }
        return _ticketApi.getMyTickets(
          offset: params.offset,
          limit: params.limit,
        );
      case TicketTabScope.unassigned:
        return _ticketApi.getUnassignedTickets(
          offset: params.offset,
          limit: params.limit,
        );
      case TicketTabScope.all:
        return _ticketApi.getAllTickets(
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
      chatRoomId: apiTicket.chatRoomId ?? base.chatRoomId,
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