import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket_filter.dart';

class TicketFilterDialog extends StatefulWidget {
  final TicketFilter initialFilter;
  final List<Ticket> allTickets;
  final ValueChanged<TicketFilter> onFilterChanged;
  final VoidCallback onFilterCleared;

  const TicketFilterDialog({
    super.key,
    required this.initialFilter,
    required this.allTickets,
    required this.onFilterChanged,
    required this.onFilterCleared,
  });

  @override
  State<TicketFilterDialog> createState() => _TicketFilterDialogState();
}

class _TicketFilterDialogState extends State<TicketFilterDialog> {
  late TicketFilter _currentFilter;
  late DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _selectedDateRange = widget.initialFilter.fromDate != null &&
            widget.initialFilter.toDate != null
        ? DateTimeRange(
            start: widget.initialFilter.fromDate!,
            end: widget.initialFilter.toDate!,
          )
        : null;
  }

  /// Get unique customers from tickets
  List<String> _getUniqueCustomers() {
    final customers = <String>{};
    for (var ticket in widget.allTickets) {
      customers.add(ticket.customerId);
    }
    return customers.toList();
  }

  /// Get unique creators from tickets
  List<String> _getUniqueCreators() {
    final creators = <String>{};
    for (var ticket in widget.allTickets) {
      creators.add(ticket.createdByID);
    }
    return creators.toList();
  }

  /// Get customer name by ID
  String _getCustomerName(String customerId) {
    try {
      return widget.allTickets
          .firstWhere((t) => t.customerId == customerId)
          .customerName;
    } catch (_) {
      return customerId;
    }
  }

  /// Get creator name by ID
  String _getCreatorName(String creatorId) {
    try {
      return widget.allTickets
          .firstWhere((t) => t.createdByID == creatorId)
          .createdByName;
    } catch (_) {
      return creatorId;
    }
  }

  void _updateFilter(TicketFilter newFilter) {
    print('[DEBUG] _updateFilter called with: $newFilter');
    print('[DEBUG] createdById: ${newFilter.createdById}');
    print('[DEBUG] customerId: ${newFilter.customerId}');
    setState(() {
      _currentFilter = newFilter;
    });
    widget.onFilterChanged(newFilter);
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilter = TicketFilter.empty();
      _selectedDateRange = null;
    });
    widget.onFilterCleared();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 620,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bộ lọc',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: AppColors.textSecondary,
                      onPressed: () => Navigator.pop(context),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2-Column Grid Layout
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusDropdown(),
                      const SizedBox(height: 12),
                      _buildPriorityDropdown(),
                      const SizedBox(height: 12),
                      _buildCustomerDropdown(),
                      const SizedBox(height: 12),
                      _buildSourceDropdown(),
                      const SizedBox(height: 12),
                      _buildCreatorDropdown(),
                      const SizedBox(height: 12),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 12),
                      _buildDateRangeFilter(),
                    ],
                  )
                else
                  // 2-Column layout for desktop
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Status | Priority
                      Row(
                        children: [
                          Expanded(child: _buildStatusDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildPriorityDropdown()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 2: Customer | Source
                      Row(
                        children: [
                          Expanded(child: _buildCustomerDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSourceDropdown()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 3: Creator | Category
                      Row(
                        children: [
                          Expanded(child: _buildCreatorDropdown()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildCategoryDropdown()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 4: Date Range (full width)
                      SizedBox(width: double.infinity, child: _buildDateRangeFilter()),
                    ],
                  ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _clearAllFilters,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Làm mới bộ lọc'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Status Dropdown
  Widget _buildStatusDropdown() {
    final selectedStatus = _currentFilter.statuses?.isNotEmpty ?? false 
        ? _currentFilter.statuses!.first 
        : null;
    
    return _buildDropdownField<TicketStatus>(
      label: 'Chọn trạng thái',
      value: selectedStatus,
      items: [
        const DropdownMenuItem<TicketStatus>(
          value: null,
          child: Text('Tất cả'),
        ),
        ...TicketStatus.values.map((status) => DropdownMenuItem<TicketStatus>(
              value: status,
              child: Text(status.displayName),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(
          statuses: value != null ? [value] : [],
        ));
      },
    );
  }

  /// Priority Dropdown
  Widget _buildPriorityDropdown() {
    final selectedPriority = _currentFilter.priorities?.isNotEmpty ?? false 
        ? _currentFilter.priorities!.first 
        : null;
    
    return _buildDropdownField<TicketPriority>(
      label: 'Chọn độ ưu tiên',
      value: selectedPriority,
      items: [
        const DropdownMenuItem<TicketPriority>(
          value: null,
          child: Text('Tất cả'),
        ),
        ...TicketPriority.values.map((priority) => DropdownMenuItem<TicketPriority>(
              value: priority,
              child: Text(priority.displayName),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(
          priorities: value != null ? [value] : [],
        ));
      },
    );
  }

  /// Category Dropdown
  Widget _buildCategoryDropdown() {
    final selectedCategory = _currentFilter.categories?.isNotEmpty ?? false 
        ? _currentFilter.categories!.first 
        : null;
    
    return _buildDropdownField<TicketCategory>(
      label: 'Chọn loại phiếu',
      value: selectedCategory,
      items: [
        const DropdownMenuItem<TicketCategory>(
          value: null,
          child: Text('Tất cả'),
        ),
        ...TicketCategory.values.map((category) => DropdownMenuItem<TicketCategory>(
              value: category,
              child: Text(category.displayName),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(
          categories: value != null ? [value] : [],
        ));
      },
    );
  }

  /// Source Dropdown
  Widget _buildSourceDropdown() {
    final selectedSource = _currentFilter.sources?.isNotEmpty ?? false 
        ? _currentFilter.sources!.first 
        : null;
    
    return _buildDropdownField<TicketSource>(
      label: 'Chọn nguồn tiếp nhận',
      value: selectedSource,
      items: [
        const DropdownMenuItem<TicketSource>(
          value: null,
          child: Text('Tất cả'),
        ),
        ...TicketSource.values.map((source) => DropdownMenuItem<TicketSource>(
              value: source,
              child: Text(source.displayName),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(
          sources: value != null ? [value] : [],
        ));
      },
    );
  }

  /// Customer Dropdown
  Widget _buildCustomerDropdown() {
    final customers = _getUniqueCustomers();
    return DropdownButtonFormField<String?>(
      value: _currentFilter.customerId ?? '',
      items: [
        const DropdownMenuItem<String?>(
          value: '',
          child: Text('Tất cả khách hàng'),
        ),
        ...customers.map((customerId) => DropdownMenuItem<String?>(
              value: customerId,
              child: Text(_getCustomerName(customerId)),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(customerId: value ?? ''));
      },
      decoration: InputDecoration(
        labelText: 'Khách hàng',
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }

  /// Creator Dropdown
  Widget _buildCreatorDropdown() {
    final creators = _getUniqueCreators();
    return DropdownButtonFormField<String?>(
      value: _currentFilter.createdById ?? '',
      items: [
        const DropdownMenuItem<String?>(
          value: '',
          child: Text('Tất cả người tạo'),
        ),
        ...creators.map((creatorId) => DropdownMenuItem<String?>(
              value: creatorId,
              child: Text(_getCreatorName(creatorId)),
            )),
      ],
      onChanged: (value) {
        _updateFilter(_currentFilter.copyWith(createdById: value ?? ''));
      },
      decoration: InputDecoration(
        labelText: 'Người tạo',
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }

  /// Date Range Picker
  Widget _buildDateRangeFilter() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: _selectedDateRange,
        );
        if (picked != null) {
          setState(() {
            _selectedDateRange = picked;
          });
          _updateFilter(_currentFilter.copyWith(
            fromDate: picked.start,
            toDate: picked.end,
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedDateRange != null
                    ? '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}'
                    : 'Chọn khoảng ngày',
                style: TextStyle(
                  color: _selectedDateRange != null
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  /// Generic Dropdown Field Widget
  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }
}
