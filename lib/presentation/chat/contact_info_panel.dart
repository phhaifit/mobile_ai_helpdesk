import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/chat/chat_room.dart';

class ContactInfoPanel extends StatefulWidget {
  final ChatRoom room;

  const ContactInfoPanel({super.key, required this.room});

  @override
  State<ContactInfoPanel> createState() => _ContactInfoPanelState();
}

class _ContactInfoPanelState extends State<ContactInfoPanel> {
  late TextEditingController _descriptionController;
  late TextEditingController _labelInputController;
  String _assignedTo = 'Tên Nguyễn Huy (tôi)';
  String _status = 'Đang hỗ trợ';
  String _priority = 'Trung bình';
  List<String> _labels = ['VIP'];
  final List<String> _suggestedLabels = ['New', 'Tiềm năng'];
  final Set<String> _selectedSuggestedLabels = {};

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _labelInputController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _labelInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Container(
      width: isDesktop ? 320 : double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header - Avatar và thông tin cơ bản
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar lớn
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.room.isAI
                            ? [AppColors.messengerBlue, const Color(0xFF9B51E0)]
                            : [
                                const Color(0xFF6BC5F8),
                                AppColors.messengerBlue,
                              ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.room.avatarInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tên
                  Text(
                    widget.room.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Trạng thái online
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.room.isActive
                              ? AppColors.onlineGreen
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.room.isActive ? 'Đang hoạt động' : 'Ngoại tuyến',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.room.isActive
                              ? AppColors.onlineGreen
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade200, height: 1),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  _buildActionButton(
                    icon: Icons.person_add_outlined,
                    label: 'Xem hồ sơ khách hàng',
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade200, height: 1),

            // Chi tiết phiếu hỗ trợ
            ExpansionTile(
              title: const Text(
                'Chi tiết phiếu hỗ trợ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Assigned To
                      _buildSelectField(
                        label: 'Giao cho',
                        value: _assignedTo,
                        icon: Icons.person,
                        onTap: () {
                          setState(() => _assignedTo = 'Tên Nguyễn Huy (tôi)');
                        },
                      ),
                      const SizedBox(height: 12),

                      // Status
                      _buildSelectField(
                        label: 'Trạng thái',
                        value: _status,
                        icon: Icons.info_outlined,
                        backgroundColor: const Color(0xFFE3F2FD),
                        valueColor: AppColors.messengerBlue,
                        onTap: () {
                          setState(() => _status = 'Đang hỗ trợ');
                        },
                      ),
                      const SizedBox(height: 12),

                      // Priority
                      _buildSelectField(
                        label: 'Mức độ ưu tiên',
                        value: _priority,
                        icon: Icons.flag_outlined,
                        backgroundColor: const Color(0xFFFFF9C4),
                        valueColor: const Color(0xFFFBC02D),
                        onTap: () {
                          setState(() => _priority = 'Trung bình');
                        },
                      ),
                      const SizedBox(height: 12),

                      // Description
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Nhập mô tả phiếu hỗ trợ...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.messengerBlue,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _descriptionController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.textPrimary,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Hủy'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Save changes
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.messengerBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Cập nhật'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Nhãn
            _buildLabelsSection(),

            // Phân tích cuộc hội thoại
            _buildSection(
              title: 'Phân tích cuộc hội thoại ✨',
              expandable: true,
              children: _buildAnalysisContent(),
            ),

            // Ghi chú nội bộ
            _buildSection(
              title: 'Ghi chú nội bộ',
              expandable: true,
              children: [_buildSmallText('Chưa có ghi chú nào')],
            ),

            // Lịch sử hỗ trợ
            _buildSection(
              title: 'Lịch sử hỗ trợ',
              expandable: true,
              children: [_buildSmallText('Lịch sử tương tác trước đây...')],
            ),

            // Danh sách phiếu của khách
            _buildSection(
              title: 'Danh sách phiếu của khách',
              expandable: true,
              children: [_buildSmallText('Các phiếu khác của khách hàng này')],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.messengerBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required IconData icon,
    Color? backgroundColor,
    Color? valueColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white,
                border: Border.all(
                  color: backgroundColor != null
                      ? Colors.transparent
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: valueColor ?? AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelsSection() {
    return ExpansionTile(
      title: const Text(
        'Nhãn',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display labels as chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._labels.map(
                    (label) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _labels.remove(label);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Add label input
              TextField(
                controller: _labelInputController,
                decoration: InputDecoration(
                  hintText: 'Thêm nhãn',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: AppColors.messengerBlue,
                    ),
                  ),
                  suffixIcon: _labelInputController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            if (_labelInputController.text.isNotEmpty) {
                              setState(() {
                                _labels.add(_labelInputController.text);
                                _labelInputController.clear();
                              });
                            }
                          },
                          child: const Icon(
                            Icons.check,
                            color: AppColors.messengerBlue,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),

              // Suggested labels
              const Text(
                'Nhãn gợi ý',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _suggestedLabels.map((suggestedLabel) {
                  final isSelected =
                      _selectedSuggestedLabels.contains(suggestedLabel) ||
                      _labels.contains(suggestedLabel);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSuggestedLabels.remove(suggestedLabel);
                          _labels.remove(suggestedLabel);
                        } else {
                          _selectedSuggestedLabels.add(suggestedLabel);
                          if (!_labels.contains(suggestedLabel)) {
                            _labels.add(suggestedLabel);
                          }
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.messengerBlue
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(3),
                              color: isSelected
                                  ? AppColors.messengerBlue
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            suggestedLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    bool expandable = false,
  }) {
    if (expandable) {
      return ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
        Divider(color: Colors.grey.shade200, height: 16),
      ],
    );
  }

  Widget _buildSmallText(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
  }

  List<Widget> _buildAnalysisContent() {
    return [
      // Sentiment Analysis
      _buildAnalysisSection(
        title: 'Sentiment Analysis',
        icon: Icons.sentiment_satisfied_rounded,
        children: [
          _buildSentimentItem(
            label: 'Positive',
            percentage: 65,
            color: const Color(0xFF34C759),
          ),
          const SizedBox(height: 12),
          _buildSentimentItem(
            label: 'Neutral',
            percentage: 25,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          _buildSentimentItem(
            label: 'Negative',
            percentage: 10,
            color: const Color(0xFFFF3B30),
          ),
        ],
      ),
      const SizedBox(height: 24),
      // Priority Assessment
      _buildAnalysisSection(
        title: 'Priority Assessment',
        icon: Icons.priority_high_rounded,
        children: [
          _buildPriorityItem(
            label: 'Urgency Level',
            value: 'HIGH',
            color: const Color(0xFFFF3B30),
          ),
          const SizedBox(height: 12),
          _buildPriorityItem(
            label: 'Category',
            value: 'Technical Support',
            color: AppColors.messengerBlue,
          ),
          const SizedBox(height: 12),
          _buildPriorityItem(
            label: 'Response Time',
            value: '< 5 minutes',
            color: const Color(0xFF34C759),
          ),
        ],
      ),
      const SizedBox(height: 24),
      // Key Insights
      _buildAnalysisSection(
        title: 'Key Insights',
        icon: Icons.lightbulb_rounded,
        children: [
          _buildInsightItem('User is experiencing an issue'),
          const SizedBox(height: 10),
          _buildInsightItem('Needs immediate technical assistance'),
          const SizedBox(height: 10),
          _buildInsightItem('High satisfaction expected after resolution'),
        ],
      ),
    ];
  }

  Widget _buildAnalysisSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.messengerBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSentimentItem({
    required String label,
    required int percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String insight) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.messengerBlue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
