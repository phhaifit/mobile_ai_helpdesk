import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/usecase/chat_room/get_customer_chat_rooms_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:mobx/mobx.dart';

part 'customer_detail_store.g.dart';

class CustomerDetailStore = _CustomerDetailStoreBase with _$CustomerDetailStore;

abstract class _CustomerDetailStoreBase with Store {
  final GetCustomerHistoryUseCase _getCustomerHistoryUseCase;
  final GetCustomerChatRoomsUseCase _getCustomerChatRoomsUseCase;

  _CustomerDetailStoreBase(
    this._getCustomerHistoryUseCase,
    this._getCustomerChatRoomsUseCase,
  );

  @observable
  ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

  @observable
  ObservableList<Ticket> tickets = ObservableList<Ticket>();

  @observable
  ObservableList<CustomerChatRoom> chatRooms =
      ObservableList<CustomerChatRoom>();

  @observable
  String? errorMessage;

  @computed
  bool get isLoading => fetchFuture.status == FutureStatus.pending;

  @action
  Future<void> fetchCustomerDetail(String customerId) async {
    errorMessage = null;

    fetchFuture = ObservableFuture(_fetch(customerId));
    await fetchFuture;
  }

  Future<void> _fetch(String customerId) async {
    try {
      final ticketsFuture = _getCustomerHistoryUseCase.call(params: customerId);
      final chatRoomsFuture = _getCustomerChatRoomsUseCase.call(
        params: customerId,
      );

      final ticketsResult = await ticketsFuture;
      final chatRoomsResult = await chatRoomsFuture;

      tickets
        ..clear()
        ..addAll(
          (ticketsResult..sort((a, b) => b.updatedAt.compareTo(a.updatedAt))),
        );

      final sortedRooms = [...chatRoomsResult]..sort((a, b) {
        final aAt = a.lastMessageAt;
        final bAt = b.lastMessageAt;

        if (aAt == null && bAt == null) return 0;
        if (aAt == null) return 1;
        if (bAt == null) return -1;
        return bAt.compareTo(aAt);
      });

      chatRooms
        ..clear()
        ..addAll(sortedRooms);
    } catch (e) {
      errorMessage = e.toString();
      tickets.clear();
      chatRooms.clear();
    }
  }
}
