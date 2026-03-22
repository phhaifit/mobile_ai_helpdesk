/// WIDGET TREE:
/// Scaffold
///   AppBar (title: marketing_tv_title)
///   Observer
///     if isLoadingOverview → Center(CircularProgressIndicator)
///     else → SingleChildScrollView
///       Column(padding: 16)
///         _buildSummaryRow()   // 3 stat cards
///         SizedBox(16)
///         _buildSectionHeader('Chiến dịch gần đây', Routes.campaignList)
///         ...campaigns.take(3) → _buildCampaignTile(c)
///         if campaigns.isEmpty → _buildEmptyHint('marketing_tv_empty_campaigns')
///         SizedBox(16)
///         _buildSectionHeader('Template', Routes.templateLibrary)
///         ...templates.take(3) → _buildTemplateTile(t)
///         SizedBox(16)
///         _buildActionCard('Tạo chiến dịch mới', Icons.add_circle_outline, Routes.campaignCreate)
///         _buildActionCard('Cài đặt Facebook Admin', Icons.admin_panel_settings, Routes.facebookAdminSetup)

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile_ai_helpdesk/di/service_locator.dart';
import 'package:mobile_ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:mobile_ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:mobile_ai_helpdesk/utils/locale/app_localization.dart';
import 'package:mobile_ai_helpdesk/utils/routes/routes.dart';

class MarketingScreen extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback? onMenuTap;

  const MarketingScreen({super.key, this.showAppBar = true, this.onMenuTap});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  late final MarketingStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _store.fetchOverview();
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
              title: Text(l.translate('marketing_tv_title')),
            )
          : null,
      body: Observer(
        builder: (_) {
          if (_store.isLoadingOverview) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _store.fetchOverview,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow(l),
                  const SizedBox(height: 20),
                  _buildSectionHeader(l.translate('marketing_tv_campaigns'), Routes.campaignList),
                  const SizedBox(height: 8),
                  if (_store.campaigns.isEmpty)
                    _buildEmptyHint(l.translate('marketing_tv_empty_campaigns'))
                  else
                    ..._store.campaigns.take(3).map((c) => _buildCampaignTile(c, l)),
                  const SizedBox(height: 20),
                  _buildSectionHeader(l.translate('marketing_tv_template_library'), Routes.templateLibrary),
                  const SizedBox(height: 8),
                  if (_store.templates.isEmpty)
                    _buildEmptyHint(l.translate('marketing_tv_empty_templates'))
                  else
                    ..._store.templates.take(3).map((t) => _buildTemplateTile(t, l)),
                  const SizedBox(height: 20),
                  _buildActionCard(l.translate('marketing_btn_create_campaign'), Icons.add_circle_outline, Routes.campaignCreate),
                  const SizedBox(height: 8),
                  _buildActionCard(l.translate('marketing_tv_facebook_admin'), Icons.admin_panel_settings_outlined, Routes.facebookAdminSetup),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(AppLocalizations l) {
    return Observer(builder: (_) => Row(
      children: [
        Expanded(child: _buildStatCard(
          label: l.translate('marketing_tv_total_campaigns'),
          value: '${_store.campaigns.length}',
          icon: Icons.campaign,
          color: Colors.blue,
        )),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard(
          label: l.translate('marketing_tv_running_campaigns'),
          value: '${_store.runningCampaignCount}',
          icon: Icons.play_circle_outline,
          color: Colors.green,
        )),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard(
          label: l.translate('marketing_tv_total_sent'),
          value: '${_store.totalSentCount}',
          icon: Icons.send,
          color: Colors.orange,
        )),
      ],
    ));
  }

  Widget _buildStatCard({required String label, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, route),
          child: const Text('Xem tất cả'),
        ),
      ],
    );
  }

  Widget _buildCampaignTile(BroadcastCampaign c, AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: _statusIcon(c.status),
        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(_channelLabel(c.channel, l)),
        trailing: _statusBadge(c.status, l),
        onTap: () {
          _store.selectCampaign(c);
          Navigator.pushNamed(context, Routes.campaignDetail);
        },
      ),
    );
  }

  Widget _buildTemplateTile(MarketingTemplate t, AppLocalizations l) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(_channelIcon(t.channel), color: Colors.blueGrey),
        title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(_categoryLabel(t.category, l)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          _store.initDraftFromTemplate(t);
          Navigator.pushNamed(context, Routes.templateCreateEdit, arguments: t);
        },
      ),
    );
  }

  Widget _buildEmptyHint(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(child: Text(message, style: TextStyle(color: Colors.grey.shade500))),
    );
  }

  Widget _buildActionCard(String label, IconData icon, String route) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  Widget _statusIcon(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.running: return const Icon(Icons.play_circle, color: Colors.green);
      case CampaignStatus.paused: return const Icon(Icons.pause_circle, color: Colors.orange);
      case CampaignStatus.completed: return const Icon(Icons.check_circle, color: Colors.blue);
      case CampaignStatus.failed: return const Icon(Icons.error, color: Colors.red);
      case CampaignStatus.scheduled: return const Icon(Icons.schedule, color: Colors.purple);
      case CampaignStatus.draft: return const Icon(Icons.edit_note, color: Colors.grey);
    }
  }

  Widget _statusBadge(CampaignStatus status, AppLocalizations l) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.4))),
      child: Text(_statusLabel(status, l), style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  String _statusLabel(CampaignStatus status, AppLocalizations l) {
    switch (status) {
      case CampaignStatus.draft: return l.translate('marketing_tv_status_draft');
      case CampaignStatus.scheduled: return l.translate('marketing_tv_status_scheduled');
      case CampaignStatus.running: return l.translate('marketing_tv_status_running');
      case CampaignStatus.paused: return l.translate('marketing_tv_status_paused');
      case CampaignStatus.completed: return l.translate('marketing_tv_status_completed');
      case CampaignStatus.failed: return l.translate('marketing_tv_status_failed');
    }
  }

  String _channelLabel(CampaignChannel channel, AppLocalizations l) {
    switch (channel) {
      case CampaignChannel.messenger: return l.translate('marketing_tv_channel_messenger');
      case CampaignChannel.zalo: return l.translate('marketing_tv_channel_zalo');
      case CampaignChannel.email: return l.translate('marketing_tv_channel_email');
      case CampaignChannel.sms: return l.translate('marketing_tv_channel_sms');
    }
  }

  String _categoryLabel(TemplateCategory cat, AppLocalizations l) {
    switch (cat) {
      case TemplateCategory.promotional: return l.translate('marketing_tv_category_promotional');
      case TemplateCategory.transactional: return l.translate('marketing_tv_category_transactional');
      case TemplateCategory.announcement: return l.translate('marketing_tv_category_announcement');
      case TemplateCategory.reminder: return l.translate('marketing_tv_category_reminder');
    }
  }

  IconData _channelIcon(CampaignChannel channel) {
    switch (channel) {
      case CampaignChannel.messenger: return Icons.chat_bubble_outline;
      case CampaignChannel.zalo: return Icons.message_outlined;
      case CampaignChannel.email: return Icons.email_outlined;
      case CampaignChannel.sms: return Icons.sms_outlined;
    }
  }
}
