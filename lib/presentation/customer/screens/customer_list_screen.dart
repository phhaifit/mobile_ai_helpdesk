import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/customer/customer.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../widgets/customer_columns_fields_popover.dart';
import '../widgets/customer_filter_sheet.dart';

class CustomerListScreen extends StatefulWidget {
  final CustomerStore store;
  final VoidCallback onMenuTap;
  final Function(Customer) onSelectCustomer;
  final VoidCallback onAddCustomer;

  const CustomerListScreen({
    required this.store,
    required this.onMenuTap,
    required this.onSelectCustomer,
    required this.onAddCustomer,
    super.key,
  });

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final ScrollController _scrollController = ScrollController();
  final LayerLink _columnsButtonLayerLink = LayerLink();
  late final TextEditingController _searchController;
  OverlayEntry? _columnsPopoverEntry;

  final List<_CustomerCustomField> _customFields = [
    const _CustomerCustomField(
      id: 'gender_zalo',
      name: 'Giới tính (Zalo)',
      type: 'text',
    ),
    const _CustomerCustomField(
      id: 'birthday_zalo',
      name: 'Ngày sinh (Zalo)',
      type: 'text',
    ),
    const _CustomerCustomField(
      id: 'status_zalo',
      name: 'Trạng thái (Zalo)',
      type: 'text',
    ),
  ];

  final Set<String> _visibleColumnIds = {
    'name',
    'contact',
    'channel',
    'company',
    'birthday',
    'tags',
    'tickets',
    'last_contact',
    'gender_zalo',
    'birthday_zalo',
    'status_zalo',
  };

  final Map<String, Map<String, String>> _mockCustomFieldValues = {
    'cust_1': {
      'gender_zalo': 'Nam',
      'birthday_zalo': '12/04',
      'status_zalo': 'Đã quan tâm',
    },
    'cust_2': {
      'gender_zalo': 'Nữ',
      'birthday_zalo': '08/11',
      'status_zalo': 'Mới',
    },
    'cust_3': {
      'gender_zalo': 'Nam',
      'birthday_zalo': '23/07',
      'status_zalo': 'VIP',
    },
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.store.searchQuery);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.store.loadCustomers(isLoadMore: true);
    }
  }

  @override
  void dispose() {
    _hideColumnsPopover();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<_CustomerStandardColumn> get _standardColumns => [
    _CustomerStandardColumn(
      id: 'name',
      label: 'HỌ TÊN',
      width: 190,
      cellBuilder: _buildNameCell,
    ),
    _CustomerStandardColumn(
      id: 'contact',
      label: 'LIÊN HỆ',
      width: 190,
      cellBuilder: _buildContactCell,
    ),
    _CustomerStandardColumn(
      id: 'channel',
      label: 'KÊNH',
      width: 190,
      cellBuilder: _buildChannelCell,
    ),
    _CustomerStandardColumn(
      id: 'company',
      label: 'CÔNG TY',
      width: 150,
      cellBuilder: (customer) => _buildMutedCell(customer.tenantName ?? '-'),
    ),
    _CustomerStandardColumn(
      id: 'birthday',
      label: 'NGÀY SINH',
      width: 130,
      cellBuilder: (_) => _buildMutedCell('-'),
    ),
    _CustomerStandardColumn(
      id: 'tags',
      label: 'NHÃN',
      width: 150,
      cellBuilder: _buildTagsCell,
    ),
    _CustomerStandardColumn(
      id: 'tickets',
      label: 'TICKETS',
      width: 100,
      cellBuilder:
          (customer) => _buildMutedCell(customer.totalTickets.toString()),
    ),
    _CustomerStandardColumn(
      id: 'last_contact',
      label: 'LIÊN HỆ GẦN NHẤT',
      width: 150,
      cellBuilder: (customer) => _buildMutedCell(
        customer.lastContactedAt == null
            ? '-'
            : _formatShortDate(customer.lastContactedAt!),
      ),
    ),
  ];

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomerFilterSheet(store: widget.store),
    );
  }

  void _toggleColumnsPopover() {
    if (_columnsPopoverEntry == null) {
      _showColumnsPopover();
    } else {
      _hideColumnsPopover();
    }
  }

  void _showColumnsPopover() {
    final overlay = Overlay.of(context);
    _columnsPopoverEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideColumnsPopover,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _columnsButtonLayerLink,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: CustomerColumnsFieldsPopover(
                  columns: _columnOptions,
                  customFields: _customFieldOptions,
                  onToggleColumn: _toggleColumnVisibility,
                  onAddCustomField: _addCustomField,
                  onRenameCustomField: _renameCustomField,
                  onDeleteCustomField: _deleteCustomField,
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_columnsPopoverEntry!);
  }

  void _hideColumnsPopover() {
    _columnsPopoverEntry?.remove();
    _columnsPopoverEntry = null;
  }

  List<CustomerColumnOption> get _columnOptions {
    return [
      ..._standardColumns.map(
        (column) => CustomerColumnOption(
          id: column.id,
          label: column.label,
          isVisible: _visibleColumnIds.contains(column.id),
          isCustom: false,
        ),
      ),
      ..._customFields.map(
        (field) => CustomerColumnOption(
          id: field.id,
          label: field.name,
          isVisible: _visibleColumnIds.contains(field.id),
          isCustom: true,
        ),
      ),
    ];
  }

  List<CustomerCustomFieldOption> get _customFieldOptions {
    return _customFields
        .map(
          (field) => CustomerCustomFieldOption(
            id: field.id,
            name: field.name,
            type: field.type,
          ),
        )
        .toList();
  }

  void _updateColumnsPopover(VoidCallback action) {
    setState(action);
    _columnsPopoverEntry?.markNeedsBuild();
  }

  void _toggleColumnVisibility(String columnId) {
    _updateColumnsPopover(() {
      if (_visibleColumnIds.contains(columnId)) {
        _visibleColumnIds.remove(columnId);
      } else {
        _visibleColumnIds.add(columnId);
      }
    });
  }

  void _addCustomField(String name, String type) {
    final id = 'custom_${DateTime.now().microsecondsSinceEpoch}';
    _updateColumnsPopover(() {
      _customFields.add(_CustomerCustomField(id: id, name: name, type: type));
      _visibleColumnIds.add(id);
    });
  }

  void _renameCustomField(String id, String name) {
    _updateColumnsPopover(() {
      final index = _customFields.indexWhere((field) => field.id == id);
      if (index != -1) {
        final current = _customFields[index];
        _customFields[index] = current.copyWith(name: name);
      }
    });
  }

  void _deleteCustomField(String id) {
    _updateColumnsPopover(() {
      _customFields.removeWhere((field) => field.id == id);
      _visibleColumnIds.remove(id);
      for (final values in _mockCustomFieldValues.values) {
        values.remove(id);
      }
    });
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'C';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String _formatShortDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Widget _buildErrorState(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context);
    final messageKey = switch (code) {
      'load_subscription' => 'customer_list_error_subscription',
      'load_permission' => 'customer_list_error_permission',
      'load_not_found' => 'customer_list_error_not_found',
      _ => 'customer_list_error_generic',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 56, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            Text(
              l10n.translate('customer_list_error_title'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate(messageKey),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => widget.store.loadCustomers(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.translate('customer_list_retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerResults(List<Customer> customers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 760) {
          return _buildCustomerTable(customers);
        }
        return _buildCustomerCards(customers);
      },
    );
  }

  Widget _buildCustomerCards(List<Customer> customers) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: customers.length + (widget.store.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= customers.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final customer = customers[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => widget.onSelectCustomer(customer),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(customer, radius: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                customer.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (customer.tags.isNotEmpty)
                              _buildTagPill(customer.tags.first.name),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildContactRows(customer),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerTable(List<Customer> customers) {
    final visibleStandardColumns = _standardColumns
        .where((column) => _visibleColumnIds.contains(column.id))
        .toList();
    final visibleCustomFields = _customFields
        .where((field) => _visibleColumnIds.contains(field.id))
        .toList();
    final tableColumns = <_CustomerTableColumn>[
      ...visibleStandardColumns.map(
        (column) => _CustomerTableColumn(
          id: column.id,
          label: column.label,
          width: column.width,
          cellBuilder: column.cellBuilder,
        ),
      ),
      ...visibleCustomFields.map(
        (field) => _CustomerTableColumn(
          id: field.id,
          label: field.name.toUpperCase(),
          width: 160,
          cellBuilder: (customer) => _buildMutedCell(
            _mockCustomFieldValues[customer.id]?[field.id] ?? '-',
          ),
        ),
      ),
    ];

    if (tableColumns.isEmpty) {
      return const Center(
        child: Text(
          'Chọn ít nhất một cột trong Cột & trường',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 312,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.dividerColor),
              ),
              child: Column(
                children: [
                  _buildTableHeader(tableColumns),
                  const Divider(height: 1),
                  ...customers.map(
                    (customer) => _buildTableRow(customer, tableColumns),
                  ),
                  if (widget.store.isLoadingMore)
                    const SizedBox(
                      height: 52,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(List<_CustomerTableColumn> columns) {
    return Container(
      height: 48,
      color: AppColors.backgroundGrey,
      child: Row(
        children: columns
            .map(
              (column) => SizedBox(
                width: column.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          column.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.unfold_more,
                        size: 13,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(
    Customer customer,
    List<_CustomerTableColumn> columns,
  ) {
    return InkWell(
      onTap: () => widget.onSelectCustomer(customer),
      child: Container(
        height: 58,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.dividerColor, width: 0.7),
          ),
        ),
        child: Row(
          children: columns
              .map(
                (column) => SizedBox(
                  width: column.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: column.cellBuilder(customer),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAvatar(Customer customer, {required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
      backgroundImage: customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty
          ? NetworkImage(customer.avatarUrl!)
          : null,
      child: customer.avatarUrl == null || customer.avatarUrl!.isEmpty
          ? Text(
              _getInitials(customer.fullName),
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.65,
              ),
            )
          : null,
    );
  }

  Widget _buildNameCell(Customer customer) {
    return Row(
      children: [
        _buildAvatar(customer, radius: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            customer.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactCell(Customer customer) {
    final contact = customer.phones.isNotEmpty
        ? customer.phones.first
        : customer.emails.isNotEmpty
            ? customer.emails.first
            : '-';
    return _buildMutedCell(contact);
  }

  Widget _buildChannelCell(Customer customer) {
    final channel = customer.zalos.isNotEmpty
        ? 'Zalo'
        : customer.messengers.isNotEmpty
            ? 'Messenger'
            : '-';
    if (channel == '-') return _buildMutedCell('-');
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          channel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsCell(Customer customer) {
    if (customer.tags.isEmpty) return _buildMutedCell('-');
    return _buildTagPill(customer.tags.first.name);
  }

  Widget _buildTagPill(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMutedCell(String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildContactRows(Customer customer) {
    final List<Widget> rows = [];
    Widget buildRow(IconData icon, String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (customer.phones.isNotEmpty) {
      rows.add(buildRow(Icons.phone_outlined, customer.phones.first));
    }
    if (customer.emails.isNotEmpty) {
      rows.add(buildRow(Icons.email_outlined, customer.emails.first));
    }
    if (customer.zalos.isNotEmpty) {
      rows.add(
        buildRow(
          Icons.chat_bubble_outline,
          '${AppLocalizations.of(context).translate('customer_list_zalo')}: ${customer.zalos.first}',
        ),
      );
    }
    if (customer.messengers.isNotEmpty) {
      rows.add(
        buildRow(
          Icons.message_outlined,
          '${AppLocalizations.of(context).translate('customer_list_messenger')}: ${customer.messengers.first}',
        ),
      );
    }

    if (rows.isEmpty) {
      return Text(
        AppLocalizations.of(context).translate('customer_list_no_contact'),
        style: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
          fontSize: 13,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompactToolbar = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onMenuTap,
        ),
        title: Text(
          AppLocalizations.of(context).translate('customer_list_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1,
              color: AppColors.primaryBlue,
            ),
            onPressed: widget.onAddCustomer,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Observer(
                      builder:
                          (_) => TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                context,
                              ).translate('customer_list_search_hint'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              suffixIcon:
                                  widget.store.searchQuery.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          widget.store.setSearchQuery('');
                                        },
                                      )
                                      : null,
                            ),
                            onChanged:
                                (val) => widget.store.setSearchQuery(val),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: AppColors.primaryBlue),
                    onPressed: () => _showFilter(context),
                  ),
                ),
                const SizedBox(width: 8),
                CompositedTransformTarget(
                  link: _columnsButtonLayerLink,
                  child: isCompactToolbar
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dividerColor),
                          ),
                          child: IconButton(
                            tooltip: 'Cột & trường',
                            icon: const Icon(
                              Icons.view_column_outlined,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: _toggleColumnsPopover,
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: _toggleColumnsPopover,
                          icon: const Icon(Icons.view_column_outlined, size: 18),
                          label: const Text('Cột & trường'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryBlue,
                            side: const BorderSide(
                              color: AppColors.dividerColor,
                            ),
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (_) {
                if (widget.store.isLoading && widget.store.customers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.store.customers.isEmpty &&
                    widget.store.errorMessage != null) {
                  return _buildErrorState(context, widget.store.errorMessage!);
                }
                if (widget.store.customers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(
                            context,
                          ).translate('customer_list_empty'),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildCustomerResults(widget.store.customers.toList());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCustomField {
  final String id;
  final String name;
  final String type;

  const _CustomerCustomField({
    required this.id,
    required this.name,
    required this.type,
  });

  _CustomerCustomField copyWith({String? name, String? type}) {
    return _CustomerCustomField(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}

class _CustomerStandardColumn {
  final String id;
  final String label;
  final double width;
  final Widget Function(Customer customer) cellBuilder;

  const _CustomerStandardColumn({
    required this.id,
    required this.label,
    required this.width,
    required this.cellBuilder,
  });
}

class _CustomerTableColumn {
  final String id;
  final String label;
  final double width;
  final Widget Function(Customer customer) cellBuilder;

  const _CustomerTableColumn({
    required this.id,
    required this.label,
    required this.width,
    required this.cellBuilder,
  });
}
