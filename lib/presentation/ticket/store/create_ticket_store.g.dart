// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ticket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateTicketStore on _CreateTicketStoreBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(
            () => super.isFormValid,
            name: '_CreateTicketStoreBase.isFormValid',
          ))
          .value;
  Computed<bool>? _$isSubmittingComputed;

  @override
  bool get isSubmitting =>
      (_$isSubmittingComputed ??= Computed<bool>(
            () => super.isSubmitting,
            name: '_CreateTicketStoreBase.isSubmitting',
          ))
          .value;

  late final _$titleAtom = Atom(
    name: '_CreateTicketStoreBase.title',
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

  late final _$selectedCustomerAtom = Atom(
    name: '_CreateTicketStoreBase.selectedCustomer',
    context: context,
  );

  @override
  String get selectedCustomer {
    _$selectedCustomerAtom.reportRead();
    return super.selectedCustomer;
  }

  @override
  set selectedCustomer(String value) {
    _$selectedCustomerAtom.reportWrite(value, super.selectedCustomer, () {
      super.selectedCustomer = value;
    });
  }

  late final _$customerNameAtom = Atom(
    name: '_CreateTicketStoreBase.customerName',
    context: context,
  );

  @override
  String get customerName {
    _$customerNameAtom.reportRead();
    return super.customerName;
  }

  @override
  set customerName(String value) {
    _$customerNameAtom.reportWrite(value, super.customerName, () {
      super.customerName = value;
    });
  }

  late final _$contactInfoAtom = Atom(
    name: '_CreateTicketStoreBase.contactInfo',
    context: context,
  );

  @override
  List<ContactInfo> get contactInfo {
    _$contactInfoAtom.reportRead();
    return super.contactInfo;
  }

  @override
  set contactInfo(List<ContactInfo> value) {
    _$contactInfoAtom.reportWrite(value, super.contactInfo, () {
      super.contactInfo = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: '_CreateTicketStoreBase.description',
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
    name: '_CreateTicketStoreBase.ticketStatus',
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
    name: '_CreateTicketStoreBase.priority',
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

  late final _$supportPersonAtom = Atom(
    name: '_CreateTicketStoreBase.supportPerson',
    context: context,
  );

  @override
  String get supportPerson {
    _$supportPersonAtom.reportRead();
    return super.supportPerson;
  }

  @override
  set supportPerson(String value) {
    _$supportPersonAtom.reportWrite(value, super.supportPerson, () {
      super.supportPerson = value;
    });
  }

  late final _$titleErrorAtom = Atom(
    name: '_CreateTicketStoreBase.titleError',
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

  late final _$customerNameErrorAtom = Atom(
    name: '_CreateTicketStoreBase.customerNameError',
    context: context,
  );

  @override
  String? get customerNameError {
    _$customerNameErrorAtom.reportRead();
    return super.customerNameError;
  }

  @override
  set customerNameError(String? value) {
    _$customerNameErrorAtom.reportWrite(value, super.customerNameError, () {
      super.customerNameError = value;
    });
  }

  late final _$contactInfoErrorAtom = Atom(
    name: '_CreateTicketStoreBase.contactInfoError',
    context: context,
  );

  @override
  String? get contactInfoError {
    _$contactInfoErrorAtom.reportRead();
    return super.contactInfoError;
  }

  @override
  set contactInfoError(String? value) {
    _$contactInfoErrorAtom.reportWrite(value, super.contactInfoError, () {
      super.contactInfoError = value;
    });
  }

  late final _$submitFutureAtom = Atom(
    name: '_CreateTicketStoreBase.submitFuture',
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
    name: '_CreateTicketStoreBase.submitError',
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

  late final _$createdTicketAtom = Atom(
    name: '_CreateTicketStoreBase.createdTicket',
    context: context,
  );

  @override
  Ticket? get createdTicket {
    _$createdTicketAtom.reportRead();
    return super.createdTicket;
  }

  @override
  set createdTicket(Ticket? value) {
    _$createdTicketAtom.reportWrite(value, super.createdTicket, () {
      super.createdTicket = value;
    });
  }

  late final _$submitCreateTicketAsyncAction = AsyncAction(
    '_CreateTicketStoreBase.submitCreateTicket',
    context: context,
  );

  @override
  Future<Ticket?> submitCreateTicket() {
    return _$submitCreateTicketAsyncAction.run(
      () => super.submitCreateTicket(),
    );
  }

  late final _$_CreateTicketStoreBaseActionController = ActionController(
    name: '_CreateTicketStoreBase',
    context: context,
  );

  @override
  void setTitle(String value) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setTitle',
    );
    try {
      return super.setTitle(value);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedCustomer(String value) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setSelectedCustomer',
    );
    try {
      return super.setSelectedCustomer(value);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCustomerName(String value) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setCustomerName',
    );
    try {
      return super.setCustomerName(value);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTicketStatus(TicketStatus status) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setTicketStatus',
    );
    try {
      return super.setTicketStatus(status);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPriority(TicketPriority p) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setPriority',
    );
    try {
      return super.setPriority(p);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSupportPerson(String value) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.setSupportPerson',
    );
    try {
      return super.setSupportPerson(value);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addContactInfo(ContactInfo info) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.addContactInfo',
    );
    try {
      return super.addContactInfo(info);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeContactInfo(int index) {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.removeContactInfo',
    );
    try {
      return super.removeContactInfo(index);
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateForm() {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.validateForm',
    );
    try {
      return super.validateForm();
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetForm() {
    final _$actionInfo = _$_CreateTicketStoreBaseActionController.startAction(
      name: '_CreateTicketStoreBase.resetForm',
    );
    try {
      return super.resetForm();
    } finally {
      _$_CreateTicketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
selectedCustomer: ${selectedCustomer},
customerName: ${customerName},
contactInfo: ${contactInfo},
description: ${description},
ticketStatus: ${ticketStatus},
priority: ${priority},
supportPerson: ${supportPerson},
titleError: ${titleError},
customerNameError: ${customerNameError},
contactInfoError: ${contactInfoError},
submitFuture: ${submitFuture},
submitError: ${submitError},
createdTicket: ${createdTicket},
isFormValid: ${isFormValid},
isSubmitting: ${isSubmitting}
    ''';
  }
}
