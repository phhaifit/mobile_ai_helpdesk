/// WIDGET TREE:
/// Scaffold
///   AppBar(title: campaign.name)
///   Observer
///     SingleChildScrollView
///       Column(padding: 16)
///         _buildStatusBadge()
///         _buildInfoCard()         // name, channel, template
///         _buildStatsCard()        // sent/delivered/failed + 2x progress bars
///         BroadcastStatusTimeline  // live event log (running/paused/completed/failed)
///         _buildTargetingCard()    // audience info
///         _buildScheduleCard()     // dates
///         BroadcastReceiptsSection // delivery receipts with pagination
///         _buildActionButtons()    // state-machine gated controls
///           draft/scheduled → FilledButton('Bắt đầu')
///           running → Row[OutlinedButton('Tạm dừng'), FilledButton('Dừng hẳn')]
///           paused  → Row[FilledButton('Tiếp tục'),  FilledButton('Dừng hẳn')]

import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_broadcast_store.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/presentation/marketing/widgets/broadcast_receipts_section.dart';
import 'package:ai_helpdesk/presentation/marketing/widgets/broadcast_status_timeline.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen({super.key});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  late final MarketingStore _store;
  late final MarketingBroadcastStore _broadcastStore;
  late final EventBus _eventBus;
  String? _subscribedCampaignId;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _broadcastStore = getIt<MarketingBroadcastStore>();
    _eventBus = getIt<EventBus>();
    _broadcastStore.fetchFacebookAdminAccounts();

    final id = _store.selectedCampaign?.id;
    if (id != null && id.isNotEmpty) {
      _subscribedCampaignId = id;
      _broadcastStore.startRealtimeStatus(id);
    }
  }

  @override
  void dispose() {
    if (_subscribedCampaignId != null) {
      _broadcastStore.stopRealtimeStatus(_subscribedCampaignId!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Observer(
      builder: (_) {
        final campaign = _store.selectedCampaign;
        if (campaign == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('No campaign selected')),
          );
        }
        final isSmall = MediaQuery.of(context).size.width < 400;
        return Scaffold(
          appBar: AppBar(
            title: Text(campaign.name),
            actions: [
              if (_broadcastStore.activeBroadcastActionId == campaign.id)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isSmall ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildStatusBadge(campaign.status, l)),
                SizedBox(height: isSmall ? 12 : 16),
                if (!_broadcastStore.hasValidFacebookIntegration)
                  Observer(
                    builder: (_) => Column(
                      children: [
                        Container(
                          color: Colors.orange.withValues(alpha: 0.1),
                          padding: EdgeInsets.all(isSmall ? 10 : 12),
                          child: Row(
                            children: [
                              Icon(Icons.warning,
                                  color: Colors.orange,
                                  size: isSmall ? 18 : 20),
                              SizedBox(width: isSmall ? 8 : 10),
                              Expanded(
                                child: Text(
                                  l.translate(
                                    'marketing_error_facebook_not_connected',
                                  ),
                                  style:
                                      TextStyle(fontSize: isSmall ? 12 : 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isSmall ? 10 : 12),
                      ],
                    ),
                  ),
                _buildInfoCard(campaign, l),
                SizedBox(height: isSmall ? 10 : 12),
                _buildStatsCard(campaign, l),
                if (_showTimeline(campaign.status)) ...[
                  SizedBox(height: isSmall ? 10 : 12),
                  BroadcastStatusTimeline(
                    campaignId: campaign.id,
                    eventBus: _eventBus,
                  ),
                ],
                SizedBox(height: isSmall ? 10 : 12),
                _buildTargetingCard(campaign, l),
                SizedBox(height: isSmall ? 10 : 12),
                _buildScheduleCard(campaign, l),
                if (_showReceipts(campaign.status)) ...[
                  SizedBox(height: isSmall ? 10 : 12),
                  BroadcastReceiptsSection(
                    campaignId: campaign.id,
                    store: _broadcastStore,
                  ),
                ],
                SizedBox(height: isSmall ? 16 : 20),
                _buildActionButtons(campaign, l),
                if (_store.actionMessageKey != null) ...[
                  SizedBox(height: isSmall ? 10 : 12),
                  _buildFeedbackBanner(l),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  bool _showTimeline(CampaignStatus s) =>
      s == CampaignStatus.running ||
      s == CampaignStatus.paused ||
      s == CampaignStatus.completed ||
      s == CampaignStatus.failed;

  bool _showReceipts(CampaignStatus s) =>
      s == CampaignStatus.running ||
      s == CampaignStatus.paused ||
      s == CampaignStatus.completed ||
      s == CampaignStatus.failed;

  Widget _buildStatusBadge(CampaignStatus status, AppLocalizations l) {
    final colors = {
      CampaignStatus.running: Colors.green,
      CampaignStatus.paused: Colors.orange,
      CampaignStatus.completed: Colors.blue,
      CampaignStatus.failed: Colors.red,
      CampaignStatus.scheduled: Colors.purple,
      CampaignStatus.draft: Colors.grey,
    };
    final color = colors[status] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            _statusLabel(status, l),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BroadcastCampaign c, AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin chiến dịch',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: isSmall ? 14 : 15),
            ),
            const Divider(height: 16),
            _infoRow(Icons.label_outline, 'Tên', c.name),
            SizedBox(height: isSmall ? 6 : 8),
            _infoRow(
              _channelIcon(c.channel),
              l.translate('marketing_tv_channel_messenger'),
              _channelLabel(c.channel, l),
            ),
            SizedBox(height: isSmall ? 6 : 8),
            _infoRow(
              Icons.article_outlined,
              l.translate('marketing_tv_template'),
              'ID: ${c.templateId}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Row(
      children: [
        Icon(icon, size: isSmall ? 14 : 16, color: Colors.grey),
        SizedBox(width: isSmall ? 6 : 8),
        Text(
          '$label: ',
          style: TextStyle(
              color: Colors.grey.shade600, fontSize: isSmall ? 12 : 13),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: isSmall ? 12 : 13),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BroadcastCampaign c, AppLocalizations l) {
    final deliveredRatio =
        c.sentCount > 0 ? c.deliveredCount / c.sentCount : 0.0;
    final sendRatio = c.targeting.estimatedCount > 0
        ? (c.sentCount / c.targeting.estimatedCount).clamp(0.0, 1.0)
        : 0.0;
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: isSmall ? 14 : 15),
            ),
            const Divider(height: 16),
            if (isSmall)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    child: _statColumn(
                        l.translate('marketing_tv_sent'),
                        '${c.sentCount}',
                        Colors.blue),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    child: _statColumn(
                        l.translate('marketing_tv_delivered'),
                        '${c.deliveredCount}',
                        Colors.green),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 2,
                    child: _statColumn(
                        l.translate('marketing_tv_failed_count'),
                        '${c.failedCount}',
                        Colors.red),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statColumn(l.translate('marketing_tv_sent'),
                      '${c.sentCount}', Colors.blue),
                  _statColumn(l.translate('marketing_tv_delivered'),
                      '${c.deliveredCount}', Colors.green),
                  _statColumn(l.translate('marketing_tv_failed_count'),
                      '${c.failedCount}', Colors.red),
                ],
              ),
            if (c.targeting.estimatedCount > 0) ...[
              SizedBox(height: isSmall ? 10 : 12),
              Text(
                'Tiến độ gửi: ${c.sentCount}/${c.targeting.estimatedCount} (${(sendRatio * 100).toStringAsFixed(1)}%)',
                style: TextStyle(
                    fontSize: isSmall ? 11 : 12, color: Colors.grey),
              ),
              const SizedBox(height: 3),
              LinearProgressIndicator(
                value: sendRatio,
                backgroundColor: Colors.grey.shade200,
                color: Colors.blue,
              ),
            ],
            if (c.sentCount > 0) ...[
              SizedBox(height: isSmall ? 8 : 10),
              Text(
                'Tỷ lệ nhận: ${(deliveredRatio * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                    fontSize: isSmall ? 11 : 12, color: Colors.grey),
              ),
              const SizedBox(height: 3),
              LinearProgressIndicator(
                value: deliveredRatio.clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, Color color) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: isSmall ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: color),
        ),
        Text(
          label,
          style:
              TextStyle(fontSize: isSmall ? 11 : 12, color: Colors.grey),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTargetingCard(BroadcastCampaign c, AppLocalizations l) {
    final t = c.targeting;
    final isSmall = MediaQuery.of(context).size.width < 400;

    String filterDesc;
    switch (t.filterType) {
      case RecipientFilterType.all:
        filterDesc = l.translate('marketing_tv_filter_all');
      case RecipientFilterType.tag:
        filterDesc =
            '${l.translate('marketing_tv_filter_tag')}: ${t.tagValues.join(', ')}';
      case RecipientFilterType.segment:
        filterDesc =
            '${l.translate('marketing_tv_filter_segment')}: ${t.segmentValue ?? ''}';
      case RecipientFilterType.channel:
        filterDesc =
            '${l.translate('marketing_tv_filter_channel')}: ${t.channelFilter?.name ?? ''}';
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đối tượng nhận',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: isSmall ? 14 : 15),
            ),
            const Divider(height: 16),
            _infoRow(Icons.people_outline, 'Bộ lọc', filterDesc),
            if (t.estimatedCount > 0) ...[
              SizedBox(height: isSmall ? 6 : 8),
              _infoRow(
                Icons.person_outline,
                l.translate('marketing_tv_estimated_count'),
                '${t.estimatedCount}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(BroadcastCampaign c, AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: isSmall ? 14 : 15),
            ),
            const Divider(height: 16),
            _infoRow(
                Icons.calendar_today_outlined, 'Tạo lúc', _formatDate(c.createdAt)),
            if (c.scheduledAt != null) ...[
              SizedBox(height: isSmall ? 6 : 8),
              _infoRow(Icons.schedule, 'Lên lịch', _formatDate(c.scheduledAt!)),
            ],
            if (c.startedAt != null) ...[
              SizedBox(height: isSmall ? 6 : 8),
              _infoRow(Icons.play_arrow, 'Bắt đầu', _formatDate(c.startedAt!)),
            ],
            if (c.completedAt != null) ...[
              SizedBox(height: isSmall ? 6 : 8),
              _infoRow(Icons.check, 'Hoàn thành', _formatDate(c.completedAt!)),
            ],
            if (c.errorMessage != null) ...[
              SizedBox(height: isSmall ? 6 : 8),
              _infoRow(Icons.error_outline, 'Lỗi', c.errorMessage!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BroadcastCampaign c, AppLocalizations l) {
    if (c.status == CampaignStatus.completed ||
        c.status == CampaignStatus.failed) {
      return const SizedBox.shrink();
    }
    final isSmall = MediaQuery.of(context).size.width < 400;
    return Card(
      color: const Color(0xFFF8FAFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFDDE3F5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings_outlined,
                    size: 16, color: Color(0xFF6B7280)),
                SizedBox(width: 6),
                Text(
                  'Điều khiển chiến dịch',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: isSmall ? 10 : 12),
            Observer(
              builder: (_) {
                final busy =
                    _broadcastStore.activeBroadcastActionId == c.id;
                if (busy) return const LinearProgressIndicator();
                return _buildControlRow(c, l);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRow(BroadcastCampaign c, AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    switch (c.status) {
      case CampaignStatus.draft:
      case CampaignStatus.scheduled:
        return Observer(
          builder: (_) => SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: !_broadcastStore.hasValidFacebookIntegration
                  ? null
                  : () => _confirmAction(
                        label: l.translate('marketing_btn_start_campaign'),
                        message: 'Bắt đầu chiến dịch "${c.name}"?',
                        color: Colors.green,
                        icon: Icons.play_arrow_rounded,
                        onConfirm: () => _broadcastStore.executeCampaign(c.id),
                      ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l.translate('marketing_btn_start_campaign')),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
              ),
            ),
          ),
        );

      case CampaignStatus.running:
        final pauseBtn = OutlinedButton.icon(
          onPressed: () => _confirmAction(
            label: l.translate('marketing_btn_stop_campaign'),
            message: 'Tạm dừng chiến dịch "${c.name}"?',
            color: Colors.orange,
            icon: Icons.pause_rounded,
            onConfirm: () => _broadcastStore.stopCampaign(c.id),
          ),
          icon: const Icon(Icons.pause_rounded, color: Colors.orange),
          label: Text(
            l.translate('marketing_btn_stop_campaign'),
            style: const TextStyle(color: Colors.orange),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange),
            padding: EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
          ),
        );
        final stopBtn = FilledButton.icon(
          onPressed: () => _confirmAction(
            label: 'Dừng hẳn',
            message:
                'Dừng hẳn chiến dịch "${c.name}"? Hành động này không thể hoàn tác.',
            color: Colors.red,
            icon: Icons.stop_rounded,
            onConfirm: () => _broadcastStore.stopCampaign(c.id),
          ),
          icon: const Icon(Icons.stop_rounded),
          label: const Text('Dừng hẳn'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            padding:
                EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
          ),
        );
        return isSmall
            ? Column(children: [
                SizedBox(width: double.infinity, child: pauseBtn),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: stopBtn),
              ])
            : Row(children: [
                Expanded(child: pauseBtn),
                const SizedBox(width: 10),
                Expanded(child: stopBtn),
              ]);

      case CampaignStatus.paused:
        final resumeBtn = FilledButton.icon(
          onPressed: () => _confirmAction(
            label: l.translate('marketing_btn_resume_campaign'),
            message: 'Tiếp tục chiến dịch "${c.name}"?',
            color: Colors.green,
            icon: Icons.play_arrow_rounded,
            onConfirm: () => _broadcastStore.resumeCampaign(c.id),
          ),
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(l.translate('marketing_btn_resume_campaign')),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
          ),
        );
        final stopBtn2 = FilledButton.icon(
          onPressed: () => _confirmAction(
            label: 'Dừng hẳn',
            message:
                'Dừng hẳn chiến dịch "${c.name}"? Hành động này không thể hoàn tác.',
            color: Colors.red,
            icon: Icons.stop_rounded,
            onConfirm: () => _broadcastStore.stopCampaign(c.id),
          ),
          icon: const Icon(Icons.stop_rounded),
          label: const Text('Dừng hẳn'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            padding:
                EdgeInsets.symmetric(vertical: isSmall ? 12 : 14),
          ),
        );
        return isSmall
            ? Column(children: [
                SizedBox(width: double.infinity, child: resumeBtn),
                const SizedBox(height: 8),
                SizedBox(width: double.infinity, child: stopBtn2),
              ])
            : Row(children: [
                Expanded(child: resumeBtn),
                const SizedBox(width: 10),
                Expanded(child: stopBtn2),
              ]);

      case CampaignStatus.completed:
      case CampaignStatus.failed:
        return const SizedBox.shrink();
    }
  }

  void _confirmAction({
    required String label,
    required String message,
    required Color color,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackBanner(AppLocalizations l) {
    final msg = _store.actionMessageKey ?? '';
    final isSuccess = _store.actionWasSuccess;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isSuccess ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isSuccess ? Colors.green : Colors.red)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess
                ? Icons.check_circle_outline
                : Icons.error_outline,
            color: isSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(l.translate(msg))),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: _store.clearActionFeedback,
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(CampaignStatus s) {
    switch (s) {
      case CampaignStatus.running:
        return Icons.play_circle;
      case CampaignStatus.paused:
        return Icons.pause_circle;
      case CampaignStatus.completed:
        return Icons.check_circle;
      case CampaignStatus.failed:
        return Icons.error;
      case CampaignStatus.scheduled:
        return Icons.schedule;
      case CampaignStatus.draft:
        return Icons.edit_note;
    }
  }

  String _statusLabel(CampaignStatus s, AppLocalizations l) {
    switch (s) {
      case CampaignStatus.draft:
        return l.translate('marketing_tv_status_draft');
      case CampaignStatus.scheduled:
        return l.translate('marketing_tv_status_scheduled');
      case CampaignStatus.running:
        return l.translate('marketing_tv_status_running');
      case CampaignStatus.paused:
        return l.translate('marketing_tv_status_paused');
      case CampaignStatus.completed:
        return l.translate('marketing_tv_status_completed');
      case CampaignStatus.failed:
        return l.translate('marketing_tv_status_failed');
    }
  }

  String _channelLabel(CampaignChannel c, AppLocalizations l) {
    switch (c) {
      case CampaignChannel.messenger:
        return l.translate('marketing_tv_channel_messenger');
      case CampaignChannel.zalo:
        return l.translate('marketing_tv_channel_zalo');
      case CampaignChannel.email:
        return l.translate('marketing_tv_channel_email');
      case CampaignChannel.sms:
        return l.translate('marketing_tv_channel_sms');
    }
  }

  IconData _channelIcon(CampaignChannel c) {
    switch (c) {
      case CampaignChannel.messenger:
        return Icons.chat_bubble_outline;
      case CampaignChannel.zalo:
        return Icons.message_outlined;
      case CampaignChannel.email:
        return Icons.email_outlined;
      case CampaignChannel.sms:
        return Icons.sms_outlined;
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
}
