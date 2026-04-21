/// WIDGET TREE:
/// Scaffold
///   AppBar(title: marketing_tv_create_campaign)
///   Column
///     _buildStepIndicator(currentStep)   // 3 steps
///     Expanded
///       if step==0: _buildBasicInfoStep()
///       if step==1: _buildAudienceStep() (inline RecipientTargetingForm)
///       if step==2: _buildScheduleStep()
///     _buildNavigationButtons()

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_broadcast_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';

class CampaignCreateScreen extends StatefulWidget {
  const CampaignCreateScreen({super.key});

  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  late final MarketingStore _store;
  late final MarketingBroadcastStore _broadcastStore;
  int _currentStep = 0;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
    _broadcastStore = getIt<MarketingBroadcastStore>();
    _store.clearDraft();
    if (_store.templates.isEmpty) _store.fetchTemplates();
    _broadcastStore.fetchFacebookAdminAccounts();
    _nameController.addListener(
      () => _store.setDraftCampaignName(_nameController.text),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      appBar: AppBar(title: Text(l.translate('marketing_tv_create_campaign'))),
      body: Column(
        children: [
          _buildStepIndicator(l),
          if (!_broadcastStore.hasValidFacebookIntegration)
            Observer(
              builder: (_) => Container(
                color: Colors.orange.withValues(alpha: 0.1),
                padding: EdgeInsets.all(isSmall ? 10 : 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_outline,
                      color: Colors.orange,
                      size: isSmall ? 18 : 20,
                    ),
                    SizedBox(width: isSmall ? 8 : 10),
                    Expanded(
                      child: Text(
                        l.translate(
                          'marketing_error_facebook_not_connected',
                        ),
                        style: TextStyle(fontSize: isSmall ? 12 : 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmall ? 12 : 16),
              child: Observer(
                builder: (_) {
                  switch (_currentStep) {
                    case 0:
                      return _buildBasicInfoStep(l);
                    case 1:
                      return _buildAudienceStep(l);
                    case 2:
                      return _buildScheduleStep(l);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          _buildNavigationButtons(l),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(AppLocalizations l) {
    final steps = [
      l.translate('marketing_tv_step_basic'),
      l.translate('marketing_tv_step_audience'),
      l.translate('marketing_tv_step_schedule'),
    ];
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Container(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 10 : 12,
        horizontal: isSmall ? 12 : 16,
      ),
      child:
          isSmall
              ? SizedBox(
                height: 50,
                child: Row(
                  children: List.generate(steps.length, (i) {
                    final isActive = i == _currentStep;
                    final isDone = i < _currentStep;
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor:
                                isDone
                                    ? Colors.green
                                    : (isActive
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade300),
                            child:
                                isDone
                                    ? const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                    : Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            isActive
                                                ? Colors.white
                                                : Colors.grey.shade600,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
              : Row(
                children: List.generate(steps.length, (i) {
                  final isActive = i == _currentStep;
                  final isDone = i < _currentStep;
                  return Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              isDone
                                  ? Colors.green
                                  : (isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade300),
                          child:
                              isDone
                                  ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                  : Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isActive
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            steps[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        if (i < steps.length - 1)
                          Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                  );
                }),
              ),
    );
  }

  Widget _buildBasicInfoStep(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.translate('marketing_tv_campaign_name'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Nhập tên chiến dịch...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.campaign_outlined),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Kênh gửi', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Observer(
          builder:
              (_) => DropdownButtonFormField<CampaignChannel>(
                value: _store.draftChannel,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.send_outlined),
                ),
                items:
                    CampaignChannel.values
                        .map(
                          (ch) => DropdownMenuItem(
                            value: ch,
                            child: Text(_channelLabel(ch, l)),
                          ),
                        )
                        .toList(),
                onChanged: (v) {
                  if (v != null) _store.setDraftChannel(v);
                },
              ),
        ),
        const SizedBox(height: 16),
        Text(
          l.translate('marketing_tv_template'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Observer(
          builder: (_) {
            if (_store.isLoadingOverview) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_store.templates.isEmpty) {
              return const Center(child: Text('Không có template'));
            }
            return Column(
              children:
                  _store.templates.map((t) {
                    final isSelected = _store.draftTemplateId == t.id;
                    return Card(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                      child: ListTile(
                        leading: Icon(
                          Icons.article_outlined,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                        ),
                        title: Text(t.name),
                        subtitle: Text(_categoryLabel(t.category, l)),
                        trailing:
                            isSelected
                                ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                                : null,
                        onTap: () => _store.setDraftTemplateId(t.id),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAudienceStep(AppLocalizations l) {
    return Observer(
      builder:
          (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại bộ lọc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...RecipientFilterType.values.map(
                (f) => RadioListTile<RecipientFilterType>(
                  value: f,
                  groupValue: _store.draftFilterType,
                  title: Text(_filterLabel(f, l)),
                  onChanged: (v) {
                    if (v != null) _store.setDraftFilterType(v);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (_store.draftFilterType == RecipientFilterType.tag) ...[
                const SizedBox(height: 8),
                const Text(
                  'Chọn tag:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children:
                      ['vip', 'regular', 'new', 'inactive', 'premium'].map((
                        tag,
                      ) {
                        final selected = _store.draftTagValues.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: selected,
                          onSelected: (_) => _store.toggleDraftTag(tag),
                        );
                      }).toList(),
                ),
              ],
              if (_store.draftFilterType == RecipientFilterType.segment) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value:
                      _store.draftSegmentValue.isEmpty
                          ? null
                          : _store.draftSegmentValue,
                  decoration: const InputDecoration(
                    labelText: 'Phân khúc',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'VIP', child: Text('VIP')),
                    DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                    DropdownMenuItem(value: 'New', child: Text('New')),
                  ],
                  onChanged: (v) {
                    if (v != null) _store.setDraftSegmentValue(v);
                  },
                ),
              ],
              if (_store.draftFilterType == RecipientFilterType.channel) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<CampaignChannel>(
                  value: _store.draftChannelFilter,
                  decoration: const InputDecoration(
                    labelText: 'Kênh',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      CampaignChannel.values
                          .map(
                            (ch) => DropdownMenuItem(
                              value: ch,
                              child: Text(_channelLabel(ch, l)),
                            ),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) _store.setDraftChannelFilter(v);
                  },
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed:
                      _store.isSubmitting ? null : _store.estimateAudience,
                  icon:
                      _store.isSubmitting
                          ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.people_outline),
                  label: Text(l.translate('marketing_tv_estimate_audience')),
                ),
              ),
              if (_store.draftEstimatedCount > 0) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.people, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '${l.translate('marketing_tv_estimated_count')}: ',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${_store.draftEstimatedCount}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
    );
  }

  Widget _buildScheduleStep(AppLocalizations l) {
    return Observer(
      builder:
          (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thời gian gửi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RadioListTile<bool>(
                value: false,
                groupValue: _store.draftScheduledAt != null,
                title: Text(l.translate('marketing_tv_send_now')),
                onChanged: (_) => _store.setDraftScheduledAt(null),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<bool>(
                value: true,
                groupValue: _store.draftScheduledAt != null,
                title: Text(l.translate('marketing_tv_schedule')),
                onChanged: (_) async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(hours: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) _store.setDraftScheduledAt(date);
                },
                contentPadding: EdgeInsets.zero,
              ),
              if (_store.draftScheduledAt != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Lên lịch: ${_formatDate(_store.draftScheduledAt!)}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                'Tóm tắt',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _summaryRow(
                        'Tên',
                        _store.draftCampaignName.isEmpty
                            ? '(chưa nhập)'
                            : _store.draftCampaignName,
                      ),
                      const SizedBox(height: 6),
                      _summaryRow(
                        'Kênh',
                        _channelLabel(_store.draftChannel, l),
                      ),
                      const SizedBox(height: 6),
                      _summaryRow(
                        'Template',
                        _store.draftTemplateId.isEmpty
                            ? '(chưa chọn)'
                            : _store.draftTemplateId,
                      ),
                      const SizedBox(height: 6),
                      _summaryRow(
                        'Đối tượng',
                        _filterLabel(_store.draftFilterType, l),
                      ),
                      if (_store.draftEstimatedCount > 0) ...[
                        const SizedBox(height: 6),
                        _summaryRow(
                          'Ước tính',
                          '${_store.draftEstimatedCount} người',
                        ),
                      ],
                      const SizedBox(height: 6),
                      _summaryRow(
                        'Gửi',
                        _store.draftScheduledAt != null
                            ? _formatDate(_store.draftScheduledAt!)
                            : 'Ngay sau khi tạo',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _summaryRow(String label, String value) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Row(
      children: [
        SizedBox(
          width: isSmall ? 60 : 80,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: isSmall ? 12 : 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: isSmall ? 12 : 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(AppLocalizations l) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Container(
      padding: EdgeInsets.all(isSmall ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Observer(
        builder: (_) {
          if (isSmall) {
            return Column(
              children: [
                if (_currentStep > 0)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Quay lại'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child:
                      _currentStep < 2
                          ? FilledButton(
                            onPressed: () => setState(() => _currentStep++),
                            child: const Text('Tiếp theo'),
                          )
                          : Observer(
                            builder: (_) => FilledButton(
                              onPressed:
                                  _store.isSubmitting ||
                                          !_broadcastStore
                                              .hasValidFacebookIntegration
                                      ? null
                                      : () async {
                                        await _store.createCampaign();
                                        if (mounted && _store.actionWasSuccess)
                                          Navigator.pop(context);
                                      },
                              child:
                                  _store.isSubmitting
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      l.translate(
                                        'marketing_btn_create_campaign',
                                      ),
                                    ),
                            ),
                          ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Quay lại'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child:
                      _currentStep < 2
                          ? FilledButton(
                            onPressed: () => setState(() => _currentStep++),
                            child: const Text('Tiếp theo'),
                          )
                          : Observer(
                            builder: (_) => FilledButton(
                              onPressed:
                                  _store.isSubmitting ||
                                          !_broadcastStore
                                              .hasValidFacebookIntegration
                                      ? null
                                      : () async {
                                        await _store.createCampaign();
                                        if (mounted && _store.actionWasSuccess)
                                          Navigator.pop(context);
                                      },
                              child:
                                  _store.isSubmitting
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        l.translate(
                                          'marketing_btn_create_campaign',
                                        ),
                                      ),
                            ),
                          ),
                ),
              ],
            );
          }
        },
      ),
    );
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

  String _categoryLabel(TemplateCategory c, AppLocalizations l) {
    switch (c) {
      case TemplateCategory.promotional:
        return l.translate('marketing_tv_category_promotional');
      case TemplateCategory.transactional:
        return l.translate('marketing_tv_category_transactional');
      case TemplateCategory.announcement:
        return l.translate('marketing_tv_category_announcement');
      case TemplateCategory.reminder:
        return l.translate('marketing_tv_category_reminder');
    }
  }

  String _filterLabel(RecipientFilterType f, AppLocalizations l) {
    switch (f) {
      case RecipientFilterType.all:
        return l.translate('marketing_tv_filter_all');
      case RecipientFilterType.tag:
        return l.translate('marketing_tv_filter_tag');
      case RecipientFilterType.segment:
        return l.translate('marketing_tv_filter_segment');
      case RecipientFilterType.channel:
        return l.translate('marketing_tv_filter_channel');
    }
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
