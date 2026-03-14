import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/chat/chat_room.dart';

class ChatRoomInfoPanel extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomInfoPanel({super.key, required this.room});

  @override
  State<ChatRoomInfoPanel> createState() => _ChatRoomInfoPanelState();
}

class _ChatRoomInfoPanelState extends State<ChatRoomInfoPanel> {
  late Map<String, bool> _expandedSections;

  @override
  void initState() {
    super.initState();
    _expandedSections = {
      'details': false,
      'nhân': false,
      'analysis': false,
      'notes': false,
      'history': false,
      'tickets': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header with avatar and info
          _buildHeader(),
          const Divider(height: 1, color: AppColors.dividerColor),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Action buttons
                  _buildActionButton(
                    'Xem hộ sơ khách hàng',
                    Icons.person_outline,
                  ),
                  // Expandable sections
                  _buildSection('Chi tiết phiếu hỗ trợ', 'details'),
                  _buildSection('Nhân', 'nhân'),
                  _buildSection('Phân tích cuộc hội thoại ✨', 'analysis'),
                  _buildSection('Ghi chú nội bộ', 'notes'),
                  _buildSection('Lịch sử hỗ trợ', 'history'),
                  _buildSection('Danh sách phiếu của khách', 'tickets'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and name
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.room.isAI
                        ? [AppColors.messengerBlue, const Color(0xFF9B51E0)]
                        : [const Color(0xFF6BC5F8), AppColors.messengerBlue],
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.room.avatarInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.room.isActive ? 'Active now' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.room.isActive
                            ? AppColors.onlineGreen
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.messengerBlue,
            side: const BorderSide(color: AppColors.messengerBlue, width: 1),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String sectionKey) {
    final isExpanded = _expandedSections[sectionKey] ?? false;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedSections[sectionKey] = !isExpanded;
            });
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            color: AppColors.backgroundGrey,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              _getPlaceholderContent(sectionKey),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        const Divider(height: 1, color: AppColors.dividerColor),
      ],
    );
  }

  String _getPlaceholderContent(String sectionKey) {
    switch (sectionKey) {
      case 'details':
        return 'Chi tiết phiếu hỗ trợ sẽ hiển thị ở đây';
      case 'nhân':
        return 'Thông tin nhân sẽ hiển thị ở đây';
      case 'analysis':
        return 'Phân tích cuộc hội thoại sẽ hiển thị ở đây';
      case 'notes':
        return 'Ghi chú nội bộ sẽ hiển thị ở đây';
      case 'history':
        return 'Lịch sử hỗ trợ sẽ hiển thị ở đây';
      case 'tickets':
        return 'Danh sách phiếu của khách sẽ hiển thị ở đây';
      default:
        return '';
    }
  }
}
