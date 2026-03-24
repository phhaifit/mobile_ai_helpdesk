import 'package:mobx/mobx.dart';

part 'ticket_column_visibility_store.g.dart';

enum TicketColumn {
  title,
  statusPriority,
  customer,
  source,
  createdBy,
  csAgent,
  createdDate,
  updatedDate,
  actions,
}

class TicketColumnVisibilityStore = _TicketColumnVisibilityStoreBase
    with _$TicketColumnVisibilityStore;

abstract class _TicketColumnVisibilityStoreBase with Store {
  @observable
  bool showTitle = true;

  @observable
  bool showStatusPriority = true;

  @observable
  bool showCustomer = true;

  @observable
  bool showSource = true;

  @observable
  bool showCreatedBy = true;

  @observable
  bool showCSAgent = true;

  @observable
  bool showCreatedDate = true;

  @observable
  bool showUpdatedDate = true;

  @observable
  bool showActions = true;

  @action
  void setColumnVisibility(TicketColumn column, bool visible) {
    switch (column) {
      case TicketColumn.title:
        showTitle = visible;
        break;
      case TicketColumn.statusPriority:
        showStatusPriority = visible;
        break;
      case TicketColumn.customer:
        showCustomer = visible;
        break;
      case TicketColumn.source:
        showSource = visible;
        break;
      case TicketColumn.createdDate:
        showCreatedDate = visible;
        break;
      case TicketColumn.createdBy:
        showCreatedBy = visible;
        break;
      case TicketColumn.csAgent:
        showCSAgent = visible;
        break;
      case TicketColumn.updatedDate:
        showUpdatedDate = visible;
        break;
      case TicketColumn.actions:
        showActions = visible;
        break;
    }
  }

  bool isColumnVisible(TicketColumn column) {
    switch (column) {
      case TicketColumn.title:
        return showTitle;
      case TicketColumn.statusPriority:
        return showStatusPriority;
      case TicketColumn.customer:
        return showCustomer;
      case TicketColumn.source:
        return showSource;
      case TicketColumn.createdDate:
        return showCreatedDate;
      case TicketColumn.createdBy:
        return showCreatedBy;
      case TicketColumn.csAgent:
        return showCSAgent;
      case TicketColumn.updatedDate:
        return showUpdatedDate;
      case TicketColumn.actions:
        return showActions;
    }
  }

  @computed
  List<TicketColumn> get visibleColumns {
    final columns = <TicketColumn>[];
    if (showTitle) columns.add(TicketColumn.title);
    if (showStatusPriority) columns.add(TicketColumn.statusPriority);
    if (showCustomer) columns.add(TicketColumn.customer);
    if (showSource) columns.add(TicketColumn.source);
    if (showCreatedDate) columns.add(TicketColumn.createdDate);
    if (showCreatedBy) columns.add(TicketColumn.createdBy);
    if (showCSAgent) columns.add(TicketColumn.csAgent);
    if (showUpdatedDate) columns.add(TicketColumn.updatedDate);
    if (showActions) columns.add(TicketColumn.actions);
    return columns;
  }

  String getColumnLabel(TicketColumn column) {
    switch (column) {
      case TicketColumn.title:
        return 'Tiêu đề';
      case TicketColumn.statusPriority:
        return 'Trạng thái & Độ ưu tiên';
      case TicketColumn.customer:
        return 'Khách hàng';
      case TicketColumn.source:
        return 'Nguồn tiếp nhận';
      case TicketColumn.createdDate:
        return 'Ngày tạo';
      case TicketColumn.createdBy:
        return 'Người tạo';
      case TicketColumn.csAgent:
        return 'Người hỗ trợ';
      case TicketColumn.updatedDate:
        return 'Ngày cập nhật gần nhất';
      case TicketColumn.actions:
        return 'Hành động';
    }
  }
}
