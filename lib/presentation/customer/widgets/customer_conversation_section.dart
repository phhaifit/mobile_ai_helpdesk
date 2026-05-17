import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/presentation/customer/store/customer_detail_store.dart';
import 'package:ai_helpdesk/presentation/customer/widgets/chat_room_card.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class CustomerConversationSection extends StatelessWidget {
  final CustomerDetailStore store;
  final String customerId;

  const CustomerConversationSection({
    required this.store,
    required this.customerId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('customer_detail_section_conversations'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(height: 24, color: Colors.grey.shade300),
            Observer(builder: (_) => _buildBody(context, l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final future = store.chatRoomsFuture;
    if (future == null || future.status == FutureStatus.pending) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (future.status == FutureStatus.rejected) {
      return _errorState(context, l10n);
    }
    final rooms = store.chatRooms;
    if (rooms.isEmpty) {
      return _emptyState(l10n);
    }
    return Column(
      children: rooms
          .map(
            (r) => ChatRoomCard(
              room: r,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.translate('customer_detail_chat_open_soon')),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _emptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.forum_outlined, size: 36, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              l10n.translate('customer_detail_conversations_empty'),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 32),
            const SizedBox(height: 8),
            Text(
              l10n.translate('customer_detail_section_error'),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => store.refreshChatRooms(customerId),
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(l10n.translate('customer_detail_section_retry')),
              style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}
