import 'dart:async';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class BroadcastStatusTimeline extends StatefulWidget {
  const BroadcastStatusTimeline({
    required this.campaignId,
    required this.eventBus,
    super.key,
  });

  final String campaignId;
  final EventBus eventBus;

  @override
  State<BroadcastStatusTimeline> createState() =>
      _BroadcastStatusTimelineState();
}

class _BroadcastStatusTimelineState extends State<BroadcastStatusTimeline> {
  final List<BroadcastStatusRealtimeEvent> _events = [];
  StreamSubscription<BroadcastStatusRealtimeEvent>? _sub;
  static const int _maxEvents = 50;

  @override
  void initState() {
    super.initState();
    _sub = widget.eventBus
        .on<BroadcastStatusRealtimeEvent>()
        .where((e) => e.campaignId == widget.campaignId)
        .listen((e) {
      if (!mounted) return;
      setState(() {
        _events.insert(0, e);
        if (_events.length > _maxEvents) _events.removeLast();
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_events.isEmpty) {
      return _emptyState();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.timeline, size: 16, color: Colors.blueGrey),
                SizedBox(width: 6),
                Text(
                  'Nhật ký trạng thái',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const Divider(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _events.length,
              itemBuilder: (_, i) => _buildEntry(i),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.timeline, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 6),
            Text(
              'Chưa có sự kiện nào — chờ chiến dịch bắt đầu',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(int index) {
    final e = _events[index];
    final prev = index + 1 < _events.length ? _events[index + 1] : null;
    final deltaSent = prev != null ? e.sentCount - prev.sentCount : e.sentCount;
    final deltaDelivered =
        prev != null ? e.deliveredCount - prev.deliveredCount : e.deliveredCount;
    final deltaFailed =
        prev != null ? e.failedCount - prev.failedCount : e.failedCount;

    final statusColor = _statusColor(e.status);
    final isLast = index == _events.length - 1;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _statusLabel(e.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(e.occurredAt),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Gửi: ${e.sentCount}  Nhận: ${e.deliveredCount}  Lỗi: ${e.failedCount}'
                    '${deltaSent > 0 ? "  (+$deltaSent / +$deltaDelivered / +$deltaFailed)" : ""}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BroadcastStatus? s) {
    switch (s) {
      case BroadcastStatus.running:
        return Colors.green;
      case BroadcastStatus.paused:
        return Colors.orange;
      case BroadcastStatus.completed:
        return Colors.blue;
      case BroadcastStatus.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(BroadcastStatus? s) {
    switch (s) {
      case BroadcastStatus.running:
        return 'Đang gửi';
      case BroadcastStatus.paused:
        return 'Tạm dừng';
      case BroadcastStatus.completed:
        return 'Hoàn thành';
      case BroadcastStatus.failed:
        return 'Thất bại';
      default:
        return s?.name ?? 'Unknown';
    }
  }

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';
}
