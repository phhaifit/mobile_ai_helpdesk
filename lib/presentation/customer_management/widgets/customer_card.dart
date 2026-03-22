import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../domain/entity/customer/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  final bool showUnblockButton;
  final VoidCallback? onUnblock;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
    this.showUnblockButton = false,
    this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(child: _buildInfo()),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDetailButton(),
                  if (showUnblockButton) ...[
                    const SizedBox(height: 6),
                    _buildUnblockButton(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          customer.fullName.isNotEmpty
              ? customer.fullName[0].toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          customer.fullName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        if (customer.phoneNumber?.isNotEmpty == true)
          _buildContactRow(Icons.phone_outlined, customer.phoneNumber!),
        if (customer.email?.isNotEmpty == true)
          _buildContactRow(Icons.email_outlined, customer.email!),
        if (customer.zalo?.isNotEmpty == true)
          _buildContactRow(Icons.chat_outlined, 'Zalo: ${customer.zalo}'),
        if (customer.segment?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          _buildSegmentBadge(customer.segment!),
        ],
        if (customer.tags.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: customer.tags
                .take(3)
                .map(
                  (tag) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.primaryBlue),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentBadge(String segment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        segment,
        style: const TextStyle(fontSize: 10, color: Colors.purple),
      ),
    );
  }

  Widget _buildDetailButton() {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('Chi ti\u1ebft', style: TextStyle(fontSize: 11)),
    );
  }

  Widget _buildUnblockButton() {
    return OutlinedButton(
      onPressed: onUnblock,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: const BorderSide(color: Colors.green),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('B\u1ecf ch\u1eb7n', style: TextStyle(fontSize: 11)),
    );
  }
}
