/// WIDGET TREE:
/// Scaffold
///   AppBar(title: marketing_tv_recipient_targeting)
///   SingleChildScrollView
///     Column(padding: 16)
///       _buildFilterTypeSection()
///       _buildConditionalInputs()
///       OutlinedButton(estimate audience)
///       _buildEstimateResult()
///       FilledButton('Xác nhận') → pop with result

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/presentation/marketing/store/marketing_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';

class RecipientTargetingScreen extends StatefulWidget {
  const RecipientTargetingScreen({super.key});

  @override
  State<RecipientTargetingScreen> createState() =>
      _RecipientTargetingScreenState();
}

class _RecipientTargetingScreenState extends State<RecipientTargetingScreen> {
  late final MarketingStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<MarketingStore>();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate('marketing_tv_recipient_targeting')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Observer(
          builder:
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loại bộ lọc',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 13 : 16,
                    ),
                  ),
                  SizedBox(height: isSmall ? 8 : 12),
                  ...RecipientFilterType.values.map(
                    (f) => Card(
                      color:
                          _store.draftFilterType == f
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                      margin: EdgeInsets.only(bottom: isSmall ? 6 : 8),
                      child: RadioListTile<RecipientFilterType>(
                        value: f,
                        groupValue: _store.draftFilterType,
                        title: Text(_filterLabel(f, l)),
                        subtitle: Text(_filterDescription(f)),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isSmall ? 8 : 12,
                          vertical: isSmall ? 2 : 4,
                        ),
                        dense: isSmall,
                        onChanged: (v) {
                          if (v != null) _store.setDraftFilterType(v);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isSmall ? 12 : 16),
                  _buildConditionalInputs(l),
                  SizedBox(height: isSmall ? 12 : 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 8 : 12,
                        ),
                      ),
                      onPressed:
                          _store.isSubmitting ? null : _store.estimateAudience,
                      icon:
                          _store.isSubmitting
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.people_outline),
                      label: Text(
                        l.translate('marketing_tv_estimate_audience'),
                      ),
                    ),
                  ),
                  if (_store.draftEstimatedCount > 0) ...[
                    SizedBox(height: isSmall ? 10 : 12),
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: EdgeInsets.all(isSmall ? 12 : 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.blue.shade700,
                              size: isSmall ? 24 : 32,
                            ),
                            SizedBox(width: isSmall ? 10 : 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.translate('marketing_tv_estimated_count'),
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: isSmall ? 11 : 12,
                                  ),
                                ),
                                Text(
                                  '${_store.draftEstimatedCount}',
                                  style: TextStyle(
                                    fontSize: isSmall ? 22 : 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: isSmall ? 18 : 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 10 : 12,
                        ),
                      ),
                      onPressed: () {
                        final result = CampaignRecipientTarget(
                          filterType: _store.draftFilterType,
                          tagValues: List.from(_store.draftTagValues),
                          segmentValue:
                              _store.draftSegmentValue.isEmpty
                                  ? null
                                  : _store.draftSegmentValue,
                          channelFilter: _store.draftChannelFilter,
                          estimatedCount: _store.draftEstimatedCount,
                        );
                        Navigator.pop(context, result);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildConditionalInputs(AppLocalizations l) {
    switch (_store.draftFilterType) {
      case RecipientFilterType.tag:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn tag:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  ['vip', 'regular', 'new', 'inactive', 'premium', 'loyal'].map(
                    (tag) {
                      final selected = _store.draftTagValues.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: selected,
                        onSelected: (_) => _store.toggleDraftTag(tag),
                        selectedColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      );
                    },
                  ).toList(),
            ),
          ],
        );
      case RecipientFilterType.segment:
        return DropdownButtonFormField<String>(
          value:
              _store.draftSegmentValue.isEmpty
                  ? null
                  : _store.draftSegmentValue,
          decoration: const InputDecoration(
            labelText: 'Phân khúc khách hàng',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'VIP', child: Text('VIP')),
            DropdownMenuItem(value: 'Regular', child: Text('Regular')),
            DropdownMenuItem(value: 'New', child: Text('Khách mới')),
          ],
          onChanged: (v) {
            if (v != null) _store.setDraftSegmentValue(v);
          },
        );
      case RecipientFilterType.channel:
        return DropdownButtonFormField<CampaignChannel>(
          value: _store.draftChannelFilter,
          decoration: const InputDecoration(
            labelText: 'Kênh liên lạc',
            border: OutlineInputBorder(),
          ),
          items:
              CampaignChannel.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(_channelLabel(c, l)),
                    ),
                  )
                  .toList(),
          onChanged: (v) {
            if (v != null) _store.setDraftChannelFilter(v);
          },
        );
      case RecipientFilterType.all:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.people_alt, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text('Tất cả khách hàng trong hệ thống sẽ nhận tin.'),
            ],
          ),
        );
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

  String _filterDescription(RecipientFilterType f) {
    switch (f) {
      case RecipientFilterType.all:
        return 'Gửi đến toàn bộ khách hàng';
      case RecipientFilterType.tag:
        return 'Lọc theo tag đã gán cho khách hàng';
      case RecipientFilterType.segment:
        return 'Lọc theo phân khúc khách hàng';
      case RecipientFilterType.channel:
        return 'Lọc theo kênh liên lạc';
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
}
