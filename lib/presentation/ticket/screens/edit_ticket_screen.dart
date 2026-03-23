import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/domain/entity/ticket/ticket.dart';
import 'package:ai_helpdesk/presentation/ticket/store/edit_ticket_store.dart';

final _getIt = GetIt.instance;

class EditTicketScreen extends StatefulWidget {
  final Ticket ticket;

  const EditTicketScreen({super.key, required this.ticket});

  @override
  State<EditTicketScreen> createState() => _EditTicketScreenState();
}

class _EditTicketScreenState extends State<EditTicketScreen> {
  late final EditTicketStore _store;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _store = _getIt<EditTicketStore>();
    _store.initFromTicket(widget.ticket);
    _titleController = TextEditingController(text: widget.ticket.title);
    _descriptionController = TextEditingController(text: widget.ticket.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa phiếu #${widget.ticket.id}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(20),
                child: isMobile
                    ? _buildMobileLayout()
                    : _buildDesktopLayout(),
              ),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusField(),
              const SizedBox(height: 16),
              _buildPriorityField(),
              const SizedBox(height: 16),
              _buildCategoryField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleField(),
        const SizedBox(height: 16),
        _buildStatusField(),
        const SizedBox(height: 16),
        _buildPriorityField(),
        const SizedBox(height: 16),
        _buildCategoryField(),
        const SizedBox(height: 16),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildTitleField() {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tiêu đề *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            onChanged: _store.setTitle,
            decoration: InputDecoration(
              hintText: 'Nhập tiêu đề phiếu',
              errorText: _store.titleError,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mô tả', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          onChanged: _store.setDescription,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Nhập mô tả chi tiết',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<TicketStatus>(
            value: _store.ticketStatus,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: TicketStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) _store.setTicketStatus(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityField() {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mức độ ưu tiên', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<TicketPriority>(
            value: _store.priority,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: TicketPriority.values.map((p) {
              return DropdownMenuItem(
                value: p,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.getPriorityColor(p),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(p.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) _store.setPriority(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField() {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Danh mục', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<TicketCategory>(
            value: _store.category,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: TicketCategory.values.map((c) {
              return DropdownMenuItem(value: c, child: Text(c.displayName));
            }).toList(),
            onChanged: (v) {
              if (v != null) _store.setCategory(v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Observer(
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _store.isSubmitting ? null : () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _store.isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: _store.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Lưu thay đổi'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final result = await _store.submitUpdate();
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật phiếu thành công')),
      );
      Navigator.pop(context, true);
    } else if (_store.submitError != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${_store.submitError}')),
      );
    }
  }
}
