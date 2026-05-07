// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_ticket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditTicketStore on _EditTicketStoreBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(
            () => super.isFormValid,
            name: '_EditTicketStoreBase.isFormValid',
          ))
          .value;
  Computed<bool>? _$isSubmittingComputed;

  @override
  bool get isSubmitting =>
      (_$isSubmittingComputed ??= Computed<bool>(
            () => super.isSubmitting,
            name: '_EditTicketStoreBase.isSubmitting',
          ))
          .value;

  late final _$titleAtom = Atom(
    name: '_EditTicketStoreBase.title',
    context: context,
  );

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: '_EditTicketStoreBase.description',
    context: context,
  );

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$ticketStatusAtom = Atom(
    name: '_EditTicketStoreBase.ticketStatus',
    context: context,
  );

  @override
  TicketStatus get ticketStatus {
    _$ticketStatusAtom.reportRead();
    return super.ticketStatus;
  }

  @override
  set ticketStatus(TicketStatus value) {
    _$ticketStatusAtom.reportWrite(value, super.ticketStatus, () {
      super.ticketStatus = value;
    });
  }

  late final _$priorityAtom = Atom(
    name: '_EditTicketStoreBase.priority',
    context: context,
  );

  @override
  TicketPriority get priority {
    _$priorityAtom.reportRead();
    return super.priority;
  }

  @override
  set priority(TicketPriority value) {
    _$priorityAtom.reportWrite(value, super.priority, () {
      super.priority = value;
    });
  }

  late final _$categoryAtom = Atom(
    name: '_EditTicketStoreBase.category',
    context: context,
  );

  @override
  TicketCategory get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(TicketCategory value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  late final _$titleErrorAtom = Atom(
    name: '_EditTicketStoreBase.titleError',
    context: context,
  );

  @override
  String? get titleError {
    _$titleErrorAtom.reportRead();
    return super.titleError;
  }

  @override
  set titleError(String? value) {
    _$titleErrorAtom.reportWrite(value, super.titleError, () {
      super.titleError = value;
    });
  }

  late final _$submitFutureAtom = Atom(
    name: '_EditTicketStoreBase.submitFuture',
    context: context,
  );

  @override
  ObservableFuture<Ticket?> get submitFuture {
    _$submitFutureAtom.reportRead();
    return super.submitFuture;
  }

  @override
  set submitFuture(ObservableFuture<Ticket?> value) {
    _$submitFutureAtom.reportWrite(value, super.submitFuture, () {
      super.submitFuture = value;
    });
  }

  late final _$submitErrorAtom = Atom(
    name: '_EditTicketStoreBase.submitError',
    context: context,
  );

  @override
  String? get submitError {
    _$submitErrorAtom.reportRead();
    return super.submitError;
  }

  @override
  set submitError(String? value) {
    _$submitErrorAtom.reportWrite(value, super.submitError, () {
      super.submitError = value;
    });
  }

  late final _$submitUpdateAsyncAction = AsyncAction(
    '_EditTicketStoreBase.submitUpdate',
    context: context,
  );

  @override
  Future<Ticket?> submitUpdate() {
    return _$submitUpdateAsyncAction.run(() => super.submitUpdate());
  }

  late final _$_EditTicketStoreBaseActionController = ActionController(
    name: '_EditTicketStoreBase',
    context: context,
  );

  @override
  void initFromTicket(Ticket ticket) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.initFromTicket',
    );
    try {
      return super.initFromTicket(ticket);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String value) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.setTitle',
    );
    try {
      return super.setTitle(value);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTicketStatus(TicketStatus status) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.setTicketStatus',
    );
    try {
      return super.setTicketStatus(status);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPriority(TicketPriority p) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.setPriority',
    );
    try {
      return super.setPriority(p);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(TicketCategory c) {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.setCategory',
    );
    try {
      return super.setCategory(c);
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateForm() {
    final _$actionInfo = _$_EditTicketStoreBaseActionController.startAction(
      name: '_EditTicketStoreBase.validateForm',
    );
    try {
      return super.validateForm();
    } finally {
      _$_EditTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
ticketStatus: ${ticketStatus},
priority: ${priority},
category: ${category},
titleError: ${titleError},
submitFuture: ${submitFuture},
submitError: ${submitError},
isFormValid: ${isFormValid},
isSubmitting: ${isSubmitting}
    ''';
  }
}
