import 'dart:async';

import 'package:ai_helpdesk/data/local/datasources/ticket/mock_ticket_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/ticket/ticket_api.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_query_params.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/repository/ticket/ticket_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// TicketRepository implementation that uses real APIs where available.
///
/// For Sprint 3 we only wire customer ticket history (and ticket detail) to the backend.
/// Other ticket operations delegate to the existing mock implementation to avoid regressions
/// in the ticket management feature.
///
/// In debug builds, transient/missing-endpoint errors (404/5xx/network) fall back to
/// [MockTicketDataSource] so customer detail remains exercisable.
class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _api;
  final TicketRepository _delegate;
  final MockTicketDataSource? _mock;

  TicketRepositoryImpl(this._api, this._delegate, [this._mock]);

  bool _shouldFallback(DioException e) {
    if (!kDebugMode || _mock == null) return false;
    final code = e.response?.statusCode;
    if (code == null) return true; // connection / timeout / unknown
    if (code == 404) return true; // endpoint missing
    if (code >= 500) return true; // backend crash
    return false; // 401/403/422/etc propagate
  }

  Future<T> _fallback<T>(
    String op,
    Future<T> Function() apiCall,
    Future<T> Function(MockTicketDataSource mock) mockCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(
            '[TicketRepo] $op failed (${e.response?.statusCode ?? e.type.name}); using mock data.',
          );
        }
        return await mockCall(_mock!);
      }
      rethrow;
    }
  }

  @override
  Future<List<Ticket>> getCustomerHistory(String customerId) {
    return _fallback('getCustomerHistory', () async {
      final dtos = await _api.getCustomerTickets(customerId);
      return dtos.map((e) => e.toEntity()).toList();
    }, (mock) => mock.getCustomerTickets(customerId));
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    try {
      final dto = await _api.getTicketById(id);
      return dto?.toEntity();
    } on DioException catch (e) {
      if (_shouldFallback(e)) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(
            '[TicketRepo] getTicketById failed (${e.response?.statusCode ?? e.type.name}); using mock data.',
          );
        }
        return _delegate.getTicketById(id);
      }
      rethrow;
    }
  }

  // ---- Delegated methods (keep existing ticket feature stable) -------------

  @override
  Future<List<Ticket>> getTickets({
    TicketQueryParams params = const TicketQueryParams(),
  }) => _delegate.getTickets(params: params);

  @override
  Future<Ticket> createTicket(Ticket ticket) => _delegate.createTicket(ticket);

  @override
  Future<Ticket> updateTicket(Ticket ticket) => _delegate.updateTicket(ticket);

  @override
  Future<void> deleteTicket(String id) => _delegate.deleteTicket(id);

  @override
  Future<Ticket> assignAgent({required String ticketId, String? agentId}) =>
      _delegate.assignAgent(ticketId: ticketId, agentId: agentId);

  @override
  Future<Comment> addComment({
    required String ticketId,
    required Comment comment,
  }) => _delegate.addComment(ticketId: ticketId, comment: comment);

  @override
  Future<List<Comment>> getComments(String ticketId) =>
      _delegate.getComments(ticketId);

  @override
  Future<List<Agent>> getAvailableAgents() => _delegate.getAvailableAgents();

  @override
  Future<List<TicketHistory>> getTicketHistory(String ticketId) =>
      _delegate.getTicketHistory(ticketId);
}
