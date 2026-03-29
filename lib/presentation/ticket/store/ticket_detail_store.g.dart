// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TicketDetailStore on _TicketDetailStoreBase, Store {
  late final _$ticketAtom = Atom(
    name: '_TicketDetailStoreBase.ticket',
    context: context,
  );

  @override
  Ticket? get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(Ticket? value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$availableAgentsAtom = Atom(
    name: '_TicketDetailStoreBase.availableAgents',
    context: context,
  );

  @override
  List<Agent> get availableAgents {
    _$availableAgentsAtom.reportRead();
    return super.availableAgents;
  }

  @override
  set availableAgents(List<Agent> value) {
    _$availableAgentsAtom.reportWrite(value, super.availableAgents, () {
      super.availableAgents = value;
    });
  }

  late final _$commentsAtom = Atom(
    name: '_TicketDetailStoreBase.comments',
    context: context,
  );

  @override
  List<Comment> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(List<Comment> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  late final _$historyAtom = Atom(
    name: '_TicketDetailStoreBase.history',
    context: context,
  );

  @override
  List<TicketHistory> get history {
    _$historyAtom.reportRead();
    return super.history;
  }

  @override
  set history(List<TicketHistory> value) {
    _$historyAtom.reportWrite(value, super.history, () {
      super.history = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TicketDetailStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isDeletedAtom = Atom(
    name: '_TicketDetailStoreBase.isDeleted',
    context: context,
  );

  @override
  bool get isDeleted {
    _$isDeletedAtom.reportRead();
    return super.isDeleted;
  }

  @override
  set isDeleted(bool value) {
    _$isDeletedAtom.reportWrite(value, super.isDeleted, () {
      super.isDeleted = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TicketDetailStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$newCommentTextAtom = Atom(
    name: '_TicketDetailStoreBase.newCommentText',
    context: context,
  );

  @override
  String get newCommentText {
    _$newCommentTextAtom.reportRead();
    return super.newCommentText;
  }

  @override
  set newCommentText(String value) {
    _$newCommentTextAtom.reportWrite(value, super.newCommentText, () {
      super.newCommentText = value;
    });
  }

  late final _$commentTypeAtom = Atom(
    name: '_TicketDetailStoreBase.commentType',
    context: context,
  );

  @override
  CommentType get commentType {
    _$commentTypeAtom.reportRead();
    return super.commentType;
  }

  @override
  set commentType(CommentType value) {
    _$commentTypeAtom.reportWrite(value, super.commentType, () {
      super.commentType = value;
    });
  }

  late final _$loadTicketAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.loadTicket',
    context: context,
  );

  @override
  Future<void> loadTicket(String ticketId) {
    return _$loadTicketAsyncAction.run(() => super.loadTicket(ticketId));
  }

  late final _$updateStatusAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.updateStatus',
    context: context,
  );

  @override
  Future<void> updateStatus(TicketStatus newStatus) {
    return _$updateStatusAsyncAction.run(() => super.updateStatus(newStatus));
  }

  late final _$assignAgentAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.assignAgent',
    context: context,
  );

  @override
  Future<void> assignAgent(String? agentId) {
    return _$assignAgentAsyncAction.run(() => super.assignAgent(agentId));
  }

  late final _$deleteTicketAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.deleteTicket',
    context: context,
  );

  @override
  Future<void> deleteTicket() {
    return _$deleteTicketAsyncAction.run(() => super.deleteTicket());
  }

  late final _$updateTicketAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.updateTicket',
    context: context,
  );

  @override
  Future<void> updateTicket(Ticket updated) {
    return _$updateTicketAsyncAction.run(() => super.updateTicket(updated));
  }

  late final _$addCommentAsyncAction = AsyncAction(
    '_TicketDetailStoreBase.addComment',
    context: context,
  );

  @override
  Future<void> addComment() {
    return _$addCommentAsyncAction.run(() => super.addComment());
  }

  late final _$_TicketDetailStoreBaseActionController = ActionController(
    name: '_TicketDetailStoreBase',
    context: context,
  );

  @override
  void setNewCommentText(String value) {
    final _$actionInfo = _$_TicketDetailStoreBaseActionController.startAction(
      name: '_TicketDetailStoreBase.setNewCommentText',
    );
    try {
      return super.setNewCommentText(value);
    } finally {
      _$_TicketDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCommentType(CommentType type) {
    final _$actionInfo = _$_TicketDetailStoreBaseActionController.startAction(
      name: '_TicketDetailStoreBase.setCommentType',
    );
    try {
      return super.setCommentType(type);
    } finally {
      _$_TicketDetailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ticket: ${ticket},
availableAgents: ${availableAgents},
comments: ${comments},
history: ${history},
isLoading: ${isLoading},
isDeleted: ${isDeleted},
errorMessage: ${errorMessage},
newCommentText: ${newCommentText},
commentType: ${commentType}
    ''';
  }
}
