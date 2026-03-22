import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_ai_helpdesk/constants/colors.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';

class CampaignListScreen extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback? onMenuTap;

  const CampaignListScreen({super.key, this.showAppBar = true, this.onMenuTap});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  late final MarketingStore _store;
  int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _store.fetchOverview();
  }

  void _showCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Tạo chiến dịch',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tên chiến dịch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên chiến dịch...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBBDEFB)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFF1976D2)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bạn có thể cấu hình chi tiết kênh gửi, đối tượng nhận và lịch gửi sau khi tạo chiến dịch.',
                        style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);
              _store.setDraftCampaignName(name);
              Navigator.pushNamed(context, Routes.campaignCreate)
                  .then((_) => _store.fetchCampaigns());
            },
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              leading: widget.onMenuTap != null
                  ? IconButton(icon: const Icon(Icons.menu), onPressed: widget.onMenuTap)
                  : null,
              title: Text(l.translate('marketing_tv_campaigns')),
            )
          : null,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, l),
            const SizedBox(height: 16),
            Expanded(child: _buildTable(l)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l) {
    return Row(
      children: [
        Text(
          l.translate('marketing_tv_campaigns'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: () => _showCreateDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: Text(l.translate('marketing_btn_create_campaign')),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.messengerBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(AppLocalizations l) {
    return Observer(
      builder: (_) {
        if (_store.isLoadingOverview) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = _store.campaigns.toList();
        if (all.isEmpty) return _buildEmptyState(l);

        final totalPages = (all.length / _rowsPerPage).ceil();
        final start = (_currentPage - 1) * _rowsPerPage;
        final end = (start + _rowsPerPage).clamp(0, all.length);
        final paged = all.sublist(start, end);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              _buildTableHeader(),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: paged.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (ctx, i) => _buildCampaignRow(ctx, paged[i], l),
                ),
              ),
              const Divider(height: 1),
              _buildPagination(all.length, totalPages),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _HeaderCell('Tên chiến dịch')),
          Expanded(flex: 2, child: _HeaderCell('Kênh')),
          Expanded(flex: 2, child: _HeaderCell('Trạng thái')),
          Expanded(flex: 2, child: _HeaderCell('Người nhận')),
          Expanded(flex: 2, child: _HeaderCell('Thời gian lên lịch')),
          SizedBox(width: 100, child: _HeaderCell('Hành động')),
        ],
      ),
    );
  }

  Widget _buildCampaignRow(BuildContext ctx, BroadcastCampaign c, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    c.name,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    _store.selectCampaign(c);
                    Navigator.pushNamed(ctx, Routes.campaignDetail)
                        .then((_) => _store.fetchCampaigns());
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.open_in_new, size: 14, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _buildChannelBadge(c.channel, l)),
          Expanded(flex: 2, child: _buildStatusChip(c.status, l)),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${c.targeting.estimatedCount}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              c.scheduledAt != null ? _formatDate(c.scheduledAt!) : '—',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          SizedBox(
            width: 130,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuickControl(ctx, c, l),
                _ActionIcon(
                  icon: Icons.open_in_new,
                  tooltip: 'Chi tiết',
                  onTap: () {
                    _store.selectCampaign(c);
                    Navigator.pushNamed(ctx, Routes.campaignDetail)
                        .then((_) => _store.fetchCampaigns());
                  },
                ),
                _ActionIcon(
                  icon: Icons.delete_outlined,
                  tooltip: 'Xóa',
                  color: Colors.red,
                  onTap: () => _confirmDelete(ctx, c, l),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickControl(BuildContext ctx, BroadcastCampaign c, AppLocalizations l) {
    switch (c.status) {
      case CampaignStatus.draft:
      case CampaignStatus.scheduled:
        return _ActionIcon(
          icon: Icons.play_arrow_rounded,
          tooltip: l.translate('marketing_btn_start_campaign'),
          color: Colors.green,
          onTap: () => _confirmAction(
            ctx, l,
            label: l.translate('marketing_btn_start_campaign'),
            message: 'Bắt đầu chiến dịch "${c.name}"?',
            color: Colors.green,
            icon: Icons.play_arrow_rounded,
            onConfirm: () => _store.startCampaign(c.id),
          ),
        );
      case CampaignStatus.running:
        return _ActionIcon(
          icon: Icons.pause_rounded,
          tooltip: l.translate('marketing_btn_stop_campaign'),
          color: Colors.orange,
          onTap: () => _confirmAction(
            ctx, l,
            label: l.translate('marketing_btn_stop_campaign'),
            message: 'Tạm dừng chiến dịch "${c.name}"?',
            color: Colors.orange,
            icon: Icons.pause_rounded,
            onConfirm: () => _store.stopCampaign(c.id),
          ),
        );
      case CampaignStatus.paused:
        return _ActionIcon(
          icon: Icons.play_arrow_rounded,
          tooltip: l.translate('marketing_btn_resume_campaign'),
          color: Colors.green,
          onTap: () => _confirmAction(
            ctx, l,
            label: l.translate('marketing_btn_resume_campaign'),
            message: 'Tiếp tục chiến dịch "${c.name}"?',
            color: Colors.green,
            icon: Icons.play_arrow_rounded,
            onConfirm: () => _store.resumeCampaign(c.id),
          ),
        );
      case CampaignStatus.completed:
      case CampaignStatus.failed:
        return const SizedBox(width: 24);
    }
  }

  void _confirmAction(
    BuildContext ctx,
    AppLocalizations l, {
    required String label,
    required String message,
    required Color color,
    required IconData icon,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: ctx,
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: color),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelBadge(CampaignChannel ch, AppLocalizations l) {
    final icon = _channelIcon(ch);
    final label = _channelLabel(ch, l);
    final color = _channelColor(ch);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(CampaignStatus status, AppLocalizations l) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _statusLabel(status, l),
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.messengerBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.campaign_outlined, size: 40, color: AppColors.messengerBlue.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 16),
          Text(
            l.translate('marketing_tv_empty_campaigns'),
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add, size: 16),
            label: Text(l.translate('marketing_btn_create_campaign')),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int total, int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Số dòng mỗi trang:', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: _rowsPerPage,
            underline: const SizedBox.shrink(),
            isDense: true,
            style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
            items: [5, 10, 20, 50].map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(),
            onChanged: (v) => setState(() {
              _rowsPerPage = v!;
              _currentPage = 1;
            }),
          ),
          const SizedBox(width: 16),
          Text('$_currentPage / $totalPages', style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 18),
            onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 18),
            onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, BroadcastCampaign c, AppLocalizations l) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Xóa chiến dịch'),
        content: Text('Bạn có chắc muốn xóa "${c.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              // Future: _store.deleteCampaign(c.id)
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  Color _statusColor(CampaignStatus s) {
    switch (s) {
      case CampaignStatus.running: return Colors.green;
      case CampaignStatus.paused: return Colors.orange;
      case CampaignStatus.completed: return Colors.blue;
      case CampaignStatus.failed: return Colors.red;
      case CampaignStatus.scheduled: return Colors.purple;
      case CampaignStatus.draft: return Colors.grey;
    }
  }

  String _statusLabel(CampaignStatus s, AppLocalizations l) {
    switch (s) {
      case CampaignStatus.draft: return l.translate('marketing_tv_status_draft');
      case CampaignStatus.scheduled: return l.translate('marketing_tv_status_scheduled');
      case CampaignStatus.running: return l.translate('marketing_tv_status_running');
      case CampaignStatus.paused: return l.translate('marketing_tv_status_paused');
      case CampaignStatus.completed: return l.translate('marketing_tv_status_completed');
      case CampaignStatus.failed: return l.translate('marketing_tv_status_failed');
    }
  }

  String _channelLabel(CampaignChannel ch, AppLocalizations l) {
    switch (ch) {
      case CampaignChannel.messenger: return l.translate('marketing_tv_channel_messenger');
      case CampaignChannel.zalo: return l.translate('marketing_tv_channel_zalo');
      case CampaignChannel.email: return l.translate('marketing_tv_channel_email');
      case CampaignChannel.sms: return l.translate('marketing_tv_channel_sms');
    }
  }

  IconData _channelIcon(CampaignChannel ch) {
    switch (ch) {
      case CampaignChannel.messenger: return Icons.chat_bubble_outline;
      case CampaignChannel.zalo: return Icons.message_outlined;
      case CampaignChannel.email: return Icons.email_outlined;
      case CampaignChannel.sms: return Icons.sms_outlined;
    }
  }

  Color _channelColor(CampaignChannel ch) {
    switch (ch) {
      case CampaignChannel.messenger: return const Color(0xFF1877F2);
      case CampaignChannel.zalo: return const Color(0xFF0068FF);
      case CampaignChannel.email: return Colors.teal;
      case CampaignChannel.sms: return Colors.purple;
    }
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  const _ActionIcon({required this.icon, required this.tooltip, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color ?? const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}
