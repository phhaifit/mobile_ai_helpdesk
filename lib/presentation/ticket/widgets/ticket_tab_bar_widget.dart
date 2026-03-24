import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class TicketTabBarWidget extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;

  const TicketTabBarWidget({
    super.key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      'Phiếu hỗ trợ của tôi',
      'Phiếu chưa tiếp nhận',
      'Tất cả phiếu hỗ trợ'
    ];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                tabs.length,
                (index) {
                  final isSelected = selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => onTabChanged(index),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            height: 3,
                            width: 150,
                            color: AppColors.primaryBlue,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 1,
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }
}
