import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_broadcast_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BroadcastReceiptsSection extends StatefulWidget {
  const BroadcastReceiptsSection({
    required this.campaignId,
    required this.store,
    super.key,
  });

  final String campaignId;
  final MarketingBroadcastStore store;

  @override
  State<BroadcastReceiptsSection> createState() =>
      _BroadcastReceiptsSectionState();
}

class _BroadcastReceiptsSectionState extends State<BroadcastReceiptsSection> {
  @override
  void initState() {
    super.initState();
    widget.store.fetchDeliveryReceipts(widget.campaignId);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final store = widget.store;
        final items = store.receipts;
        final isLoading = store.isLoadingReceipts;
        final hasMore = store.receiptsHasMore;
        final error = store.receiptsError;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        size: 16, color: Colors.blueGrey),
                    SizedBox(width: 6),
                    Text(
                      'Biên nhận gửi tin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const Divider(height: 16),
                if (items.isEmpty && !isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Chưa có biên nhận',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                  )
                else ...[
                  ...items.map((r) => _buildReceiptRow(r)),
                ],
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                if (hasMore && !isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => store.fetchDeliveryReceipts(
                          widget.campaignId,
                          loadMore: true,
                        ),
                        child: const Text('Tải thêm'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(BroadcastDeliveryReceipt r) {
    final isDelivered = r.status == 'delivered';
    final ts = r.deliveredAt ?? r.failedAt ?? r.sentAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isDelivered ? Icons.check_circle_outline : Icons.error_outline,
            size: 16,
            color: isDelivered ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.recipientId,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (r.errorMessage != null)
                  Text(
                    r.errorMessage!,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.redAccent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (ts != null)
            Text(
              _formatTime(ts),
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          const SizedBox(width: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (isDelivered ? Colors.green : Colors.red)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isDelivered ? 'Đã nhận' : 'Lỗi',
              style: TextStyle(
                fontSize: 10,
                color: isDelivered ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
