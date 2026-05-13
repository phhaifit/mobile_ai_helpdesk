import 'package:ai_helpdesk/data/local/datasources/ticket/mock_ticket_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:ai_helpdesk/data/repository/ticket/mock_ticket_repository_impl.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Real ticket repository. Currently only `getCustomerHistory` is wired to
/// the backend (used by the customer detail timeline). The rest of the
/// ticket-management surface still delegates to [MockTicketRepositoryImpl]
/// so we don't break the existing ticket UI before its own migration.
///
/// In debug builds [getCustomerHistory] falls back to [MockTicketDataSource]
/// when the backend returns 404 (route missing) / 5xx / network errors so the
/// customer-detail flow stays exercisable. 401/403 still propagate so
/// upgrade and auth flows behave realistically.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _api;
  final MockTicketDataSource? _fallbackTickets;
  final MockTicketRepositoryImpl _legacy;

  TicketRepositoryImpl(this._api, this._legacy, [this._fallbackTickets]);

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _fallbackTickets == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true;
    if (code == 404) return true;
    if (code >= 500) return true;
    return false;
  }

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) async {
    try {
      final dtos = await _api.getCustomerTickets(customerId);
      return dtos.map((d) => d.toEntity()).toList(growable: false);
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('[TicketRepo] getCustomerHistory failed (${e.response?.statusCode ?? e.type.name}); using mock data.');
        }
        return _fallbackTickets!.getCustomerTickets(customerId);
      }
      rethrow;
    }
  }

  // --- Delegated to the existing mock implementation -----------------------

  @override
  Future<List<Ticket>> getTickets({TicketQueryParams params = const TicketQueryParams()}) =>
      _legacy.getTickets(params: params);

  @override
  Future<Ticket?> getTicketById(String id) => _legacy.getTicketById(id);

  @override
  Future<Ticket> createTicket(Ticket ticket) => _legacy.createTicket(ticket);

  @override
  Future<Ticket> updateTicket(Ticket ticket) => _legacy.updateTicket(ticket);

  @override
  Future<void> deleteTicket(String id) => _legacy.deleteTicket(id);

  @override
  Future<Ticket> assignAgent({required String ticketId, String? agentId}) =>
      _legacy.assignAgent(ticketId: ticketId, agentId: agentId);

  @override
  Future<Comment> addComment({required String ticketId, required Comment comment}) =>
      _legacy.addComment(ticketId: ticketId, comment: comment);

  @override
  Future<List<Comment>> getComments(String ticketId) => _legacy.getComments(ticketId);

  @override
  Future<List<Agent>> getAvailableAgents() => _legacy.getAvailableAgents();

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) => _legacy.getTicketHistory(ticketId);
}
