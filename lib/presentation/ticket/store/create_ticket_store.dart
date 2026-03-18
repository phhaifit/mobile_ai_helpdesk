import 'package:mobx/mobx.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/contact_info.dart';

part 'create_ticket_store.g.dart';

class CreateTicketStore = _CreateTicketStoreBase with _$CreateTicketStore;

abstract class _CreateTicketStoreBase with Store {
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
  }
}
