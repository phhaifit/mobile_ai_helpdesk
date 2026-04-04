import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/contact_info.dart';
import 'package:ai_helpdesk/domain/usecase/ticket/create_ticket_usecase.dart';
import 'package:ai_helpdesk/presentation/stores/session_store.dart';

part 'create_ticket_store.g.dart';

class CreateTicketStore = _CreateTicketStoreBase with _$CreateTicketStore;

abstract class _CreateTicketStoreBase with Store {
  final CreateTicketUseCase _createTicketUseCase;
  final SessionStore _sessionStore;
  final AnalyticsService _analyticsService;

  _CreateTicketStoreBase(
    this._createTicketUseCase,
    this._sessionStore,
    this._analyticsService,
  );

  @observable
  String title = '';

  @observable
  String selectedCustomer = '';

  @observable
  String customerName = '';

  @observable
  List<ContactInfo> contactInfo = [];

  @observable
  String description = '';

  @observable
  TicketStatus ticketStatus = TicketStatus.open;

  @observable
  TicketPriority priority = TicketPriority.medium;

  @observable
  String supportPerson = '';

  @observable
  String? titleError;

  @observable
  String? customerNameError;

  @observable
  String? contactInfoError;

  @observable
  ObservableFuture<Ticket?> submitFuture = ObservableFuture.value(null);

  @observable
  String? submitError;

  @observable
  Ticket? createdTicket;

  @action
  void setTitle(String value) {
    title = value;
    titleError = null;
  }

  @action
  void setSelectedCustomer(String value) {
    selectedCustomer = value;
  }

  @action
  void setCustomerName(String value) {
    customerName = value;
    customerNameError = null;
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
  void setSupportPerson(String value) {
    supportPerson = value;
  }

  @action
  void addContactInfo(ContactInfo info) {
    contactInfo = [...contactInfo, info];
    contactInfoError = null;
  }

  @action
  void removeContactInfo(int index) {
    contactInfo = [...contactInfo.sublist(0, index), ...contactInfo.sublist(index + 1)];
  }

  @computed
  bool get isFormValid {
    return title.isNotEmpty && customerName.isNotEmpty && contactInfo.isNotEmpty;
  }

  @computed
  bool get isSubmitting => submitFuture.status == FutureStatus.pending;

  Ticket _buildTicketDraft() {
    final now = DateTime.now();
    final emailContact = contactInfo
        .where((info) => info.type == ContactType.email)
        .cast<ContactInfo?>()
        .firstWhere((info) => info != null, orElse: () => null);

    return Ticket(
      id: '',
      title: title.trim(),
      description: description.trim(),
      status: ticketStatus,
      priority: priority,
      category: TicketCategory.general,
      source: TicketSource.web,
      customerId: selectedCustomer.isNotEmpty
          ? selectedCustomer
          : 'customer_${now.millisecondsSinceEpoch}',
      customerName: customerName.trim(),
      customerEmail: emailContact?.value ?? '',
      createdByID: _sessionStore.currentAgentId,
      createdByName: _sessionStore.currentAgentId,
      assignedAgentId: supportPerson.isEmpty ? null : supportPerson,
      assignedAgentName: supportPerson.isEmpty ? null : supportPerson,
      createdAt: now,
      updatedAt: now,
      attachments: const [],
      unreadCount: 0,
    );
  }

  @action
  Future<Ticket?> submitCreateTicket() async {
    validateForm();
    if (!isFormValid) {
      return null;
    }

    submitError = null;

    final draft = _buildTicketDraft();
    submitFuture = ObservableFuture(_createTicketUseCase.call(params: draft));

    try {
      final ticket = await submitFuture;
      createdTicket = ticket;

      // Track ticket creation
      _analyticsService.trackEvent(
        AnalyticsEvents.ticketCreated,
        parameters: {
          'priority': priority.name,
          'status': ticketStatus.name,
          'category': 'general',
        },
      );

      return ticket;
    } catch (e) {
      submitError = e.toString();
      return null;
    }
  }

  @action
  void validateForm() {
    if (title.isEmpty) {
      titleError = 'Tiêu đề không được để trống';
    }
    if (customerName.isEmpty) {
      customerNameError = 'Tên khách hàng không được để trống';
    }
    if (contactInfo.isEmpty) {
      contactInfoError = 'Vui lòng thêm thông tin liên lạc';
    }
  }

  @action
  void resetForm() {
    title = '';
    selectedCustomer = '';
    customerName = '';
    contactInfo = [];
    description = '';
    ticketStatus = TicketStatus.open;
    priority = TicketPriority.medium;
    supportPerson = '';
    titleError = null;
    customerNameError = null;
    contactInfoError = null;
    submitError = null;
    createdTicket = null;
    submitFuture = ObservableFuture.value(null);
  }
}
