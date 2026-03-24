import 'package:flutter/material.dart';
import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

class CommentInputWidget extends StatelessWidget {
  final String text;
  final CommentType commentType;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<CommentType> onTypeChanged;
  final VoidCallback onSend;

  const CommentInputWidget({
    super.key,
    required this.text,
    required this.commentType,
    required this.onTextChanged,
    required this.onTypeChanged,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onTextChanged,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: text,
                      selection: TextSelection.collapsed(offset: text.length),
                    ),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nhập bình luận...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              IconButton(
                onPressed: text.trim().isNotEmpty ? onSend : null,
                icon: Icon(
                  Icons.send,
                  color: text.trim().isNotEmpty
                      ? AppColors.primaryBlue
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: CommentType.values.map((type) {
              final isSelected = type == commentType;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    type.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: type == CommentType.internal
                      ? AppColors.warningOrange
                      : AppColors.primaryBlue,
                  backgroundColor: AppColors.backgroundGrey,
                  onSelected: (_) => onTypeChanged(type),
                  visualDensity: VisualDensity.compact,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
