import 'package:mobx/mobx.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/update_ticket_usecase.dart';

part 'edit_ticket_store.g.dart';

class EditTicketStore = _EditTicketStoreBase with _$EditTicketStore;

abstract class _EditTicketStoreBase with Store {
  final UpdateTicketUseCase _updateTicketUseCase;

  _EditTicketStoreBase(this._updateTicketUseCase);

  Ticket? _originalTicket;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  TicketStatus ticketStatus = TicketStatus.open;

  @observable
  TicketPriority priority = TicketPriority.medium;

  @observable
  TicketCategory category = TicketCategory.general;

  @observable
  String? titleError;

  @observable
  ObservableFuture<Ticket?> submitFuture = ObservableFuture.value(null);

  @observable
  String? submitError;

  @computed
  bool get isFormValid => title.isNotEmpty;

  @computed
  bool get isSubmitting => submitFuture.status == FutureStatus.pending;

  @action
  void initFromTicket(Ticket ticket) {
    _originalTicket = ticket;
    title = ticket.title;
    description = ticket.description;
    ticketStatus = ticket.status;
    priority = ticket.priority;
    category = ticket.category;
    titleError = null;
    submitError = null;
  }

  @action
  void setTitle(String value) {
    title = value;
    titleError = null;
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setTicketStatus(TicketStatus status) {
    ticketStatus = status;
  }

  @action
  void setPriority(TicketPriority p) {
    priority = p;
  }

  @action
  void setCategory(TicketCategory c) {
    category = c;
  }

  @action
  void validateForm() {
    if (title.isEmpty) {
      titleError = 'Tiêu đề không được để trống';
    }
  }

  @action
  Future<Ticket?> submitUpdate() async {
    validateForm();
    if (!isFormValid || _originalTicket == null) return null;

    submitError = null;

    final updated = _originalTicket!.copyWith(
      title: title.trim(),
      description: description.trim(),
      status: ticketStatus,
      priority: priority,
      category: category,
    );

    submitFuture = ObservableFuture(_updateTicketUseCase.call(params: updated));

    try {
      return await submitFuture;
    } catch (e) {
      submitError = e.toString();
      return null;
    }
  }
}
