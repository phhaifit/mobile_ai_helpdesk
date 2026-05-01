import 'package:mobx/mobx.dart';

part 'error_store.g.dart';

// ignore: library_private_types_in_public_api
class ErrorStore = _ErrorStore with _$ErrorStore;

abstract class _ErrorStore with Store {
  late List<ReactionDisposer> _disposers;

  _ErrorStore() {
    _disposers = [reaction((_) => errorMessage, reset, delay: 200)];
  }

  @observable
  String errorMessage = '';

  @action
  // ignore: use_setters_to_change_properties
  void setErrorMessage(String message) {
    errorMessage = message;
  }

  @action
  void reset(String value) {
    errorMessage = '';
  }

  @action
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}
