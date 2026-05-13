import 'package:ai_helpdesk/domain/entity/chat_room/customer_chat_room.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/repository/customer/customer_repository.dart';
import 'package:ai_helpdesk/domain/usecase/chat_room/get_customer_chat_rooms_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/get_customer_history_usecase.dart';
import 'package:mobx/mobx.dart';

part 'customer_detail_store.g.dart';

/// Multi-source store backing [CustomerDetailScreen]. Profile / tickets /
/// conversations each have their own [ObservableFuture] so a partial failure
/// in one section does not block the other two.
class CustomerDetailStore = _CustomerDetailStore with _$CustomerDetailStore;

abstract class _CustomerDetailStore with Store {
  final CustomerRepository _customerRepository;
  final GetCustomerHistoryUseCase _getCustomerTickets;
  final GetCustomerChatRoomsUseCase _getCustomerChatRooms;

  _CustomerDetailStore(
    this._customerRepository,
    this._getCustomerTickets,
    this._getCustomerChatRooms,
  );

  @observable
  ObservableFuture<Customer?>? profileFuture;

  @observable
  ObservableFuture<List<Ticket>>? ticketsFuture;

  @observable
  ObservableFuture<List<CustomerChatRoom>>? chatRoomsFuture;

  @computed
  bool get isProfileLoading => profileFuture?.status == FutureStatus.pending;

  @computed
  bool get isTicketsLoading => ticketsFuture?.status == FutureStatus.pending;

  @computed
  bool get isChatRoomsLoading => chatRoomsFuture?.status == FutureStatus.pending;

  @computed
  Customer? get profile {
    final f = profileFuture;
    if (f == null || f.status != FutureStatus.fulfilled) return null;
    return f.result as Customer?;
  }

  @computed
  List<Ticket> get tickets {
    final f = ticketsFuture;
    if (f == null || f.status != FutureStatus.fulfilled) return const [];
    return f.result as List<Ticket>;
  }

  @computed
  List<CustomerChatRoom> get chatRooms {
    final f = chatRoomsFuture;
    if (f == null || f.status != FutureStatus.fulfilled) return const [];
    return f.result as List<CustomerChatRoom>;
  }

  /// Kicks off all three loads in parallel.
  @action
  void loadAll(String customerId) {
    loadProfile(customerId);
    refreshTickets(customerId);
    refreshChatRooms(customerId);
  }

  @action
  void loadProfile(String customerId) {
    profileFuture = ObservableFuture(_loadProfile(customerId));
  }

  Future<Customer?> _loadProfile(String customerId) async {
    final customer = await _customerRepository.getCustomerById(customerId);
    if (customer == null) return null;
    if (customer.tenantId == null || (customer.tenantName ?? '').isNotEmpty) {
      return customer;
    }
    final tenantName = await _customerRepository.getTenantName(customer.tenantId!);
    return customer.copyWith(tenantName: tenantName);
  }

  @action
  void refreshTickets(String customerId) {
    ticketsFuture = ObservableFuture(
      _getCustomerTickets.call(params: customerId),
    );
  }

  @action
  void refreshChatRooms(String customerId) {
    chatRoomsFuture = ObservableFuture(
      _getCustomerChatRooms.call(params: customerId),
    );
  }
}
