import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/history_item_widget.dart';

class TicketHistoryTimelineWidget extends StatelessWidget {
  final TicketDetailStore store;

  const TicketHistoryTimelineWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            final sorted = List.of(store.history)
              ..sort((a, b) => b.changedAt.compareTo(a.changedAt));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lịch sử thay đổi (${sorted.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (sorted.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Chưa có lịch sử thay đổi',
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                else
                  ...List.generate(sorted.length, (index) {
                    return HistoryItemWidget(
                      entry: sorted[index],
                      isLast: index == sorted.length - 1,
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}
