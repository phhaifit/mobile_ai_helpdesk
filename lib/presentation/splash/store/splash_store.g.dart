// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SplashStore on _SplashStoreBase, Store {
  late final _$destinationAtom = Atom(
    name: '_SplashStoreBase.destination',
    context: context,
  );

  @override
  SplashDestination? get destination {
    _$destinationAtom.reportRead();
    return super.destination;
  }

  @override
  set destination(SplashDestination? value) {
    _$destinationAtom.reportWrite(value, super.destination, () {
      super.destination = value;
    });
  }

  late final _$transientErrorAtom = Atom(
    name: '_SplashStoreBase.transientError',
    context: context,
  );

  @override
  String? get transientError {
    _$transientErrorAtom.reportRead();
    return super.transientError;
  }

  @override
  set transientError(String? value) {
    _$transientErrorAtom.reportWrite(value, super.transientError, () {
      super.transientError = value;
    });
  }

  late final _$bootAsyncAction = AsyncAction(
    '_SplashStoreBase.boot',
    context: context,
  );

  @override
  Future<SplashDestination> boot() {
    return _$bootAsyncAction.run(() => super.boot());
  }

  @override
  String toString() {
    return '''
destination: ${destination},
transientError: ${transientError}
    ''';
  }
}
