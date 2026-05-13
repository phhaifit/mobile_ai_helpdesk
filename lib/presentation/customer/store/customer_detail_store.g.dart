// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerDetailStore on _CustomerDetailStore, Store {
  Computed<bool>? _$isProfileLoadingComputed;

  @override
  bool get isProfileLoading =>
      (_$isProfileLoadingComputed ??= Computed<bool>(
            () => super.isProfileLoading,
            name: '_CustomerDetailStore.isProfileLoading',
          ))
          .value;
  Computed<bool>? _$isTicketsLoadingComputed;

  @override
  bool get isTicketsLoading =>
      (_$isTicketsLoadingComputed ??= Computed<bool>(
            () => super.isTicketsLoading,
            name: '_CustomerDetailStore.isTicketsLoading',
          ))
          .value;
  Computed<bool>? _$isChatRoomsLoadingComputed;

  @override
  bool get isChatRoomsLoading =>
      (_$isChatRoomsLoadingComputed ??= Computed<bool>(
            () => super.isChatRoomsLoading,
            name: '_CustomerDetailStore.isChatRoomsLoading',
          ))
          .value;
  Computed<Customer?>? _$profileComputed;

  @override
  Customer? get profile =>
      (_$profileComputed ??= Computed<Customer?>(
            () => super.profile,
            name: '_CustomerDetailStore.profile',
          ))
          .value;
  Computed<List<Ticket>>? _$ticketsComputed;

  @override
  List<Ticket> get tickets =>
      (_$ticketsComputed ??= Computed<List<Ticket>>(
            () => super.tickets,
            name: '_CustomerDetailStore.tickets',
          ))
          .value;
  Computed<List<CustomerChatRoom>>? _$chatRoomsComputed;

  @override
  List<CustomerChatRoom> get chatRooms =>
      (_$chatRoomsComputed ??= Computed<List<CustomerChatRoom>>(
            () => super.chatRooms,
            name: '_CustomerDetailStore.chatRooms',
          ))
          .value;

  late final _$profileFutureAtom = Atom(
    name: '_CustomerDetailStore.profileFuture',
    context: context,
  );

  @override
  ObservableFuture<Customer?>? get profileFuture {
    _$profileFutureAtom.reportRead();
    return super.profileFuture;
  }

  @override
  set profileFuture(ObservableFuture<Customer?>? value) {
    _$profileFutureAtom.reportWrite(value, super.profileFuture, () {
      super.profileFuture = value;
    });
  }

  late final _$ticketsFutureAtom = Atom(
    name: '_CustomerDetailStore.ticketsFuture',
    context: context,
  );

  @override
  ObservableFuture<List<Ticket>>? get ticketsFuture {
    _$ticketsFutureAtom.reportRead();
    return super.ticketsFuture;
  }

  @override
  set ticketsFuture(ObservableFuture<List<Ticket>>? value) {
    _$ticketsFutureAtom.reportWrite(value, super.ticketsFuture, () {
      super.ticketsFuture = value;
    });
  }

  late final _$chatRoomsFutureAtom = Atom(
    name: '_CustomerDetailStore.chatRoomsFuture',
    context: context,
  );

  @override
  ObservableFuture<List<CustomerChatRoom>>? get chatRoomsFuture {
    _$chatRoomsFutureAtom.reportRead();
    return super.chatRoomsFuture;
  }

  @override
  set chatRoomsFuture(ObservableFuture<List<CustomerChatRoom>>? value) {
    _$chatRoomsFutureAtom.reportWrite(value, super.chatRoomsFuture, () {
      super.chatRoomsFuture = value;
    });
  }

  late final _$_CustomerDetailStoreActionController = ActionController(
    name: '_CustomerDetailStore',
    context: context,
  );

  @override
  void loadAll(String customerId) {
    final _$actionInfo = _$_CustomerDetailStoreActionController.startAction(
      name: '_CustomerDetailStore.loadAll',
    );
    try {
      return super.loadAll(customerId);
    } finally {
      _$_CustomerDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadProfile(String customerId) {
    final _$actionInfo = _$_CustomerDetailStoreActionController.startAction(
      name: '_CustomerDetailStore.loadProfile',
    );
    try {
      return super.loadProfile(customerId);
    } finally {
      _$_CustomerDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refreshTickets(String customerId) {
    final _$actionInfo = _$_CustomerDetailStoreActionController.startAction(
      name: '_CustomerDetailStore.refreshTickets',
    );
    try {
      return super.refreshTickets(customerId);
    } finally {
      _$_CustomerDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refreshChatRooms(String customerId) {
    final _$actionInfo = _$_CustomerDetailStoreActionController.startAction(
      name: '_CustomerDetailStore.refreshChatRooms',
    );
    try {
      return super.refreshChatRooms(customerId);
    } finally {
      _$_CustomerDetailStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profileFuture: ${profileFuture},
ticketsFuture: ${ticketsFuture},
chatRoomsFuture: ${chatRoomsFuture},
isProfileLoading: ${isProfileLoading},
isTicketsLoading: ${isTicketsLoading},
isChatRoomsLoading: ${isChatRoomsLoading},
profile: ${profile},
tickets: ${tickets},
chatRooms: ${chatRooms}
    ''';
  }
}
