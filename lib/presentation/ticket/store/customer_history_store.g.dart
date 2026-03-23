// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CustomerHistoryStore on _CustomerHistoryStoreBase, Store {
  late final _$ticketsAtom = Atom(
    name: '_CustomerHistoryStoreBase.tickets',
    context: context,
  );

  @override
  List<Ticket> get tickets {
    _$ticketsAtom.reportRead();
    return super.tickets;
  }

  @override
  set tickets(List<Ticket> value) {
    _$ticketsAtom.reportWrite(value, super.tickets, () {
      super.tickets = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_CustomerHistoryStoreBase.isLoading',
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

  late final _$errorMessageAtom = Atom(
    name: '_CustomerHistoryStoreBase.errorMessage',
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

  late final _$loadHistoryAsyncAction = AsyncAction(
    '_CustomerHistoryStoreBase.loadHistory',
    context: context,
  );

  @override
  Future<void> loadHistory(String customerId) {
    return _$loadHistoryAsyncAction.run(() => super.loadHistory(customerId));
  }

  @override
  String toString() {
    return '''
tickets: ${tickets},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
