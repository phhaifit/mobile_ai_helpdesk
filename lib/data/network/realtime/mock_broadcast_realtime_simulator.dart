import 'dart:async';
import 'dart:math';

import 'package:ai_helpdesk/data/network/realtime/marketing_broadcast_realtime_service.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:event_bus/event_bus.dart';

typedef BroadcastTickCallback = void Function(
  String broadcastId,
  int sentCount,
  int deliveredCount,
  int failedCount,
  BroadcastStatus status,
);

class _RunState {
  final int totalRecipients;
  final BroadcastTickCallback applyTick;
  int sentCount;
  int deliveredCount;
  int failedCount;

  _RunState({
    required this.totalRecipients,
    required this.applyTick,
    required this.sentCount,
    required this.deliveredCount,
    required this.failedCount,
  });
}

class MockBroadcastRealtimeSimulator {
  final EventBus _eventBus;
  final _rng = Random();
  final Map<String, _RunState> _states = {};
  final Map<String, Timer> _timers = {};

  MockBroadcastRealtimeSimulator(this._eventBus);

  void start(
    String broadcastId,
    int totalRecipients, {
    required BroadcastTickCallback applyTick,
    int sentCount = 0,
    int deliveredCount = 0,
    int failedCount = 0,
  }) {
    _timers[broadcastId]?.cancel();
    _states[broadcastId] = _RunState(
      totalRecipients: totalRecipients,
      applyTick: applyTick,
      sentCount: sentCount,
      deliveredCount: deliveredCount,
      failedCount: failedCount,
    );
    _scheduleTimer(broadcastId);
  }

  void pause(String broadcastId) {
    _timers[broadcastId]?.cancel();
    _timers.remove(broadcastId);
    final state = _states[broadcastId];
    if (state == null) return;
    state.applyTick(
      broadcastId,
      state.sentCount,
      state.deliveredCount,
      state.failedCount,
      BroadcastStatus.paused,
    );
    _eventBus.fire(BroadcastStatusRealtimeEvent(
      campaignId: broadcastId,
      status: BroadcastStatus.paused,
      rawStatus: 'paused',
      sentCount: state.sentCount,
      deliveredCount: state.deliveredCount,
      failedCount: state.failedCount,
      occurredAt: DateTime.now(),
      fromWebSocket: false,
    ));
  }

  void resume(String broadcastId) {
    final state = _states[broadcastId];
    if (state == null) return;
    _scheduleTimer(broadcastId);
  }

  void cancel(String broadcastId) {
    _timers[broadcastId]?.cancel();
    _timers.remove(broadcastId);
    _states.remove(broadcastId);
  }

  void dispose() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    _states.clear();
  }

  void _scheduleTimer(String broadcastId) {
    _timers[broadcastId] = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick(broadcastId);
    });
  }

  void _tick(String broadcastId) {
    final state = _states[broadcastId];
    if (state == null) return;

    final remaining = state.totalRecipients - state.sentCount;
    if (remaining <= 0) {
      _timers[broadcastId]?.cancel();
      _timers.remove(broadcastId);
      state.applyTick(
        broadcastId,
        state.sentCount,
        state.deliveredCount,
        state.failedCount,
        BroadcastStatus.completed,
      );
      _eventBus.fire(BroadcastStatusRealtimeEvent(
        campaignId: broadcastId,
        status: BroadcastStatus.completed,
        rawStatus: 'completed',
        sentCount: state.sentCount,
        deliveredCount: state.deliveredCount,
        failedCount: state.failedCount,
        occurredAt: DateTime.now(),
        fromWebSocket: false,
      ));
      _states.remove(broadcastId);
      return;
    }

    final batch = min(3 + _rng.nextInt(5), remaining);
    final newFailed = (batch * 0.1).round();
    final newDelivered = batch - newFailed;

    state.sentCount += batch;
    state.deliveredCount += newDelivered;
    state.failedCount += newFailed;

    state.applyTick(
      broadcastId,
      state.sentCount,
      state.deliveredCount,
      state.failedCount,
      BroadcastStatus.running,
    );
    _eventBus.fire(BroadcastStatusRealtimeEvent(
      campaignId: broadcastId,
      status: BroadcastStatus.running,
      rawStatus: 'running',
      sentCount: state.sentCount,
      deliveredCount: state.deliveredCount,
      failedCount: state.failedCount,
      occurredAt: DateTime.now(),
      fromWebSocket: false,
    ));
  }
}
