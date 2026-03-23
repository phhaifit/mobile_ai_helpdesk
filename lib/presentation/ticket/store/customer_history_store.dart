import 'package:mobx/mobx.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';

part 'customer_history_store.g.dart';

class CustomerHistoryStore = _CustomerHistoryStoreBase with _$CustomerHistoryStore;

abstract class _CustomerHistoryStoreBase with Store {
  final GetCustomerHistoryUseCase _getCustomerHistoryUseCase;

  _CustomerHistoryStoreBase(this._getCustomerHistoryUseCase);

  @observable
  List<Ticket> tickets = [];

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadHistory(String customerId) async {
    isLoading = true;
    errorMessage = null;

    try {
      tickets = await _getCustomerHistoryUseCase.call(params: customerId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
