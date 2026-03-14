import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/entity/chat/chat_room.dart';

class ContactInfoPanel extends StatelessWidget {
  final ChatRoom room;

  const ContactInfoPanel({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header - Avatar và thông tin cơ bản
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
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
                        colors: room.isAI
                            ? [AppColors.messengerBlue, const Color(0xFF9B51E0)]
                            : [
                                const Color(0xFF6BC5F8),
                                AppColors.messengerBlue,
                              ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        room.avatarInitials,
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
                    room.name,
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
                          color: room.isActive
                              ? AppColors.onlineGreen
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        room.isActive ? 'Đang hoạt động' : 'Ngoại tuyến',
                        style: TextStyle(
                          fontSize: 12,
                          color: room.isActive
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

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  _buildActionButton(
                    icon: Icons.person_add_outlined,
                    label: 'Xem hồ sơ khách hàng',
                  ),
                  const SizedBox(height: 8),
                  _buildActionButton(
                    icon: Icons.history_outlined,
                    label: 'Lịch sử tương tác',
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade200, height: 1),

            // Chi tiết phiếu hỗ trợ
            _buildSection(
              title: 'Chi tiết phiếu hỗ trợ',
              children: [
                _buildDetailRow(
                  'Thẻ phân loại',
                  'Phiếu đang được xử lý bởi nhân viên',
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Mức độ ưu tiên', 'Bình thường'),
                const SizedBox(height: 12),
                _buildDetailRow('Ngày tạo', 'Hôm nay lúc 09:30 AM'),
              ],
            ),

            // Nhân viên xử lý
            _buildSection(
              title: 'Nhân viên',
              expandable: true,
              children: [_buildPersonItem('Quản lý nhân viên')],
            ),

            // Phân tích cuộc hội thoại
            _buildSection(
              title: 'Phân tích cuộc hội thoại ✨',
              expandable: true,
              children: [
                _buildSmallText(
                  'Tự động phân tích cảm xúc và suy luận từ cuộc hội thoại...',
                ),
              ],
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonItem(String name) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.messengerBlue,
          ),
          child: Center(
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallText(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
  }
}
