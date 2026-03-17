import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';
import 'package:ai_helpdesk/presentation/ticket/store/create_ticket_store.dart';

final getIt = GetIt.instance;

class CreateTicketScreenBody extends StatefulWidget {
  final VoidCallback onClose;
  final CreateTicketStore store;

  const CreateTicketScreenBody({
    super.key,
    required this.onClose,
    required this.store,
  });

  @override
  State<CreateTicketScreenBody> createState() => _CreateTicketScreenBodyState();
}

class _CreateTicketScreenBodyState extends State<CreateTicketScreenBody> {
  late TextEditingController titleController;
  late TextEditingController customerNameController;
  late TextEditingController descriptionController;
  late TextEditingController contactInfoController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    customerNameController = TextEditingController();
    descriptionController = TextEditingController();
    contactInfoController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    customerNameController.dispose();
    descriptionController.dispose();
    contactInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and title
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onClose,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tạo phiếu hỗ trợ mới',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                const Text(
                  'Tạo phiếu hỗ trợ mới trong hệ thống',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Form Container with border
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.dividerColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Two-column layout
            Observer(
              builder: (_) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề
                        Row(
                          children: [
                            Text(
                              'Tiêu đề: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: titleController,
                          onChanged: widget.store.setTitle,
                          decoration: InputDecoration(
                            hintText: 'Nhập tiêu đề của phiếu hỗ trợ',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB0B3B8),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            errorText: widget.store.titleError,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tìm khách hàng
                        const Text(
                          'Tìm khách hàng:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: widget.store.selectedCustomer.isEmpty
                              ? null
                              : widget.store.selectedCustomer,
                          items: const [
                            DropdownMenuItem(
                              value: 'customer1',
                              child: Text('Khách hàng 1'),
                            ),
                            DropdownMenuItem(
                              value: 'customer2',
                              child: Text('Khách hàng 2'),
                            ),
                            DropdownMenuItem(
                              value: 'customer3',
                              child: Text('Khách hàng 3'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              widget.store.setSelectedCustomer(value);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm khách hàng',
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tên khách hàng
                        Row(
                          children: [
                            const Text(
                              'Tên khách hàng: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: customerNameController,
                          onChanged: widget.store.setCustomerName,
                          decoration: InputDecoration(
                            hintText: 'Nhập tên khách hàng mới',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB0B3B8),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            errorText: widget.store.customerNameError,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Thông tin liên lạc
                        Row(
                          children: [
                            const Text(
                              'Thông tin liên lạc: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Contact info list
                        if (widget.store.contactInfo.isNotEmpty)
                          Column(
                            children: List.generate(
                              widget.store.contactInfo.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.store.contactInfo[index],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      GestureDetector(
                                        onTap: () => widget.store
                                            .removeContactInfo(index),
                                        child: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Color(0xFFB0B3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        // Add contact info button
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: contactInfoController,
                                decoration: InputDecoration(
                                  hintText: 'Thêm thông tin liên lạc',
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                if (contactInfoController.text.isNotEmpty) {
                                  widget.store
                                      .addContactInfo(contactInfoController.text);
                                  contactInfoController.clear();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Mô tả phiếu
                        const Text(
                          'Mô tả phiếu:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          onChanged: widget.store.setDescription,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: 'Nhập nội dung mô tả phiếu',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB0B3B8),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  // Right Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trạng thái phiếu
                        const Text(
                          'Trạng thái phiếu:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<TicketStatus>(
                          value: widget.store.ticketStatus,
                          items: TicketStatus.values
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status.displayName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.store.setTicketStatus(value);
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFE8F4FD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Độ ưu tiên
                        const Text(
                          'Độ ưu tiên:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<TicketPriority>(
                          value: widget.store.priority,
                          items: TicketPriority.values
                              .map((priority) => DropdownMenuItem(
                                    value: priority,
                                    child: Text(priority.displayName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.store.setPriority(value);
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFFFF8E1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Người hỗ trợ
                        const Text(
                          'Người hỗ trợ:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: widget.store.supportPerson.isEmpty
                              ? null
                              : widget.store.supportPerson,
                          items: const [
                            DropdownMenuItem(
                              value: 'agent1',
                              child: Text('Nhân viên 1'),
                            ),
                            DropdownMenuItem(
                              value: 'agent2',
                              child: Text('Nhân viên 2'),
                            ),
                            DropdownMenuItem(
                              value: 'agent3',
                              child: Text('Nhân viên 3'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              widget.store.setSupportPerson(value);
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.store.validateForm();
                    if (widget.store.isFormValid) {
                      // TODO: Submit ticket
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Phiếu đã được tạo')),
                      );
                      widget.store.resetForm();
                      titleController.clear();
                      customerNameController.clear();
                      descriptionController.clear();
                      widget.onClose();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Tạo phiếu',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      )],
      ),
    );
  }
}

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  late CreateTicketStore _store;

  @override
  void initState() {
    super.initState();
    _store = CreateTicketStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CreateTicketScreenBody(
        store: _store,
        onClose: () => Navigator.pop(context),
      ),
    );
  }
}
