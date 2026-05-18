import 'dart:async';

import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/services/websocket/ticket_websocket_service.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/agent/agent.dart';
import 'package:ai_helpdesk/domain/entity/comment/comment.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket_history/ticket_history.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/add_comment_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/assign_agent_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/delete_ticket_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_available_agents_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_comments_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_by_id_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_ticket_history_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_priority_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_status_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_usecase.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';
import 'package:mobx/mobx.dart';

part 'ticket_detail_store.g.dart';

class TicketDetailStore = _TicketDetailStoreBase with _$TicketDetailStore;

abstract class _TicketDetailStoreBase with Store {
  final GetTicketByIdUseCase _getTicketByIdUseCase;
  final UpdateTicketUseCase _updateTicketUseCase;
  final UpdateTicketStatusUseCase _updateTicketStatusUseCase;
  final UpdateTicketPriorityUseCase _updateTicketPriorityUseCase;
  final AssignAgentUseCase _assignAgentUseCase;
  final GetAvailableAgentsUseCase _getAvailableAgentsUseCase;
  final DeleteTicketUseCase _deleteTicketUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final GetTicketHistoryUseCase _getTicketHistoryUseCase;
  final SessionStore _sessionStore;
  final AnalyticsService _analyticsService;
  final TicketWebSocketService _wsService;

  StreamSubscription<Comment>? _wsSubscription;

  _TicketDetailStoreBase(
    this._getTicketByIdUseCase,
    this._updateTicketUseCase,
    this._updateTicketStatusUseCase,
    this._updateTicketPriorityUseCase,
    this._assignAgentUseCase,
    this._getAvailableAgentsUseCase,
    this._deleteTicketUseCase,
    this._getCommentsUseCase,
    this._addCommentUseCase,
    this._getTicketHistoryUseCase,
    this._sessionStore,
    this._analyticsService,
    this._wsService,
  );

  @observable
  Ticket? ticket;

  @observable
  List<Agent> availableAgents = [];

  @observable
  List<Comment> comments = [];

  @observable
  List<TicketHistory> history = [];

  @observable
  bool isLoading = false;

  @observable
  bool isDeleted = false;

  @observable
  String? errorMessage;

  @observable
  String newCommentText = '';

  @observable
  CommentType commentType = CommentType.public;

  @action
  Future<void> loadTicket(String ticketId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final results = await Future.wait([
        _getTicketByIdUseCase.call(params: ticketId),
        _getCommentsUseCase.call(params: ticketId),
        _getTicketHistoryUseCase.call(params: ticketId),
        _getAvailableAgentsUseCase.call(params: null),
      ]);

      ticket = results[0] as Ticket?;
      comments = List<Comment>.from(results[1] as List);
      history = List<TicketHistory>.from(results[2] as List);
      availableAgents = List<Agent>.from(results[3] as List);

      if (ticket != null) {
        _analyticsService.trackEvent(
          AnalyticsEvents.ticketViewed,
          parameters: {
            'ticket_id': ticket!.id,
            'status': ticket!.status.name,
            'priority': ticket!.priority.name,
          },
        );
        final chatRoomId = ticket!.chatRoomId;
        if (chatRoomId != null && chatRoomId.isNotEmpty) {
          _connectWebSocket(chatRoomId);
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  void _connectWebSocket(String chatRoomId) {
    _wsSubscription?.cancel();
    _wsService.connect(chatRoomId).then((_) {
      _wsSubscription = _wsService.commentStream.listen(_onIncomingComment);
    });
  }

  void _onIncomingComment(Comment comment) {
    runInAction(() {
      // Skip if the same id already exists (server echoed an already-stored comment).
      if (comments.any((c) => c.id == comment.id)) return;

      // Replace any optimistic placeholder (tmp_*) that matches this
      // comment's author + content. tmp_* ids are only assigned when the BE
      // add-comment response omits the comment object — the happy path uses
      // the server-issued id directly.
      final tmpIndex = comments.indexWhere(
        (c) =>
            c.id.startsWith('tmp_') &&
            c.authorId == comment.authorId &&
            c.content == comment.content,
      );
      if (tmpIndex != -1) {
        final updated = [...comments];
        updated[tmpIndex] = comment;
        comments = updated;
        return;
      }

      comments = [...comments, comment];
    });
  }

  void dispose() {
    _wsSubscription?.cancel();
    _wsService.disconnect();
  }

  @action
  Future<void> updateStatus(TicketStatus newStatus) async {
    if (ticket == null) return;
    errorMessage = null;

    try {
      final updated = await _updateTicketStatusUseCase.call(
        params: UpdateTicketStatusParams(
          ticketId: ticket!.id,
          newStatus: newStatus,
        ),
      );
      ticket = updated;

      _analyticsService.trackEvent(
        AnalyticsEvents.ticketUpdated,
        parameters: {
          'ticket_id': updated.id,
          'field_updated': 'status',
          'new_value': newStatus.name,
        },
      );
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> updatePriority(TicketPriority newPriority) async {
    if (ticket == null) return;
    errorMessage = null;

    try {
      final updated = await _updateTicketPriorityUseCase.call(
        params: UpdateTicketPriorityParams(
          ticketId: ticket!.id,
          newPriority: newPriority,
        ),
      );
      ticket = updated;

      _analyticsService.trackEvent(
        AnalyticsEvents.ticketUpdated,
        parameters: {
          'ticket_id': updated.id,
          'field_updated': 'priority',
          'new_value': newPriority.name,
        },
      );
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> assignAgent(String? agentId) async {
    if (ticket == null) return;
    errorMessage = null;

    try {
      final updated = await _assignAgentUseCase.call(
        params: AssignAgentParams(
          ticketId: ticket!.id,
          agentId: agentId,
        ),
      );
      ticket = updated;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> deleteTicket() async {
    if (ticket == null) return;
    errorMessage = null;

    try {
      await _deleteTicketUseCase.call(params: ticket!.id);
      isDeleted = true;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> updateTicket(Ticket updated) async {
    errorMessage = null;

    try {
      final result = await _updateTicketUseCase.call(params: updated);
      ticket = result;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<void> addComment() async {
    if (ticket == null || newCommentText.trim().isEmpty) return;
    final pending = newCommentText.trim();
    final ticketId = ticket!.id;
    errorMessage = null;

    try {
      final comment = Comment(
        id: '',
        ticketId: ticketId,
        authorId: _sessionStore.currentAgentId,
        authorName: _sessionStore.currentAgentName,
        content: pending,
        type: commentType,
        createdAt: DateTime.now(),
      );

      // BE returns the canonical comment (real id, server timestamp, author
      // resolved from `customerSupport`). The repository surfaces it directly,
      // so no refetch is needed — WS echo, if any, is deduped in
      // [_onIncomingComment].
      final created = await _addCommentUseCase.call(
        params: AddCommentParams(ticketId: ticketId, comment: comment),
      );

      comments = [...comments, created];
      newCommentText = '';
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  void setNewCommentText(String value) {
    newCommentText = value;
  }

  @action
  void setCommentType(CommentType type) {
    commentType = type;
  }
}
