import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';

class TicketSearchFilterWidget extends StatelessWidget {
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterPressed;
  final TextEditingController searchController;

  const TicketSearchFilterWidget({
    super.key,
    this.searchHint = 'Tìm theo tiêu đề',
    required this.onSearchChanged,
    this.onFilterPressed,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Search input
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: const TextStyle(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.dividerColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.dividerColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter button
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: onFilterPressed,
              icon: const Icon(Icons.tune),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
