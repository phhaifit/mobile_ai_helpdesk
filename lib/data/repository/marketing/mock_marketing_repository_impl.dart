import 'package:ai_helpdesk/domain/entity/marketing/marketing.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_repository.dart';

class MockMarketingRepositoryImpl implements MarketingRepository {
  final List<MarketingTemplate> _templates = [
    MarketingTemplate(
      id: 'tpl_001',
      name: 'Chào mừng khách hàng mới',
      content:
          'Xin chào {{customerName}}! Chào mừng bạn đến với dịch vụ của chúng tôi.',
      category: TemplateCategory.promotional,
      channel: CampaignChannel.messenger,
      variableKeys: ['customerName'],
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
    ),
    MarketingTemplate(
      id: 'tpl_002',
      name: 'Nhắc nhở đơn hàng sắp giao',
      content:
          'Đơn hàng #{{orderId}} của bạn sẽ được giao vào {{deliveryDate}}.',
      category: TemplateCategory.transactional,
      channel: CampaignChannel.zalo,
      variableKeys: ['orderId', 'deliveryDate'],
      isActive: true,
      createdAt: DateTime(2025, 1, 2),
    ),
    MarketingTemplate(
      id: 'tpl_003',
      name: 'Khuyến mãi Flash Sale 50%',
      content:
          '🎉 Flash Sale! Giảm 50% tất cả sản phẩm. Dùng mã {{promoCode}} để nhận ưu đãi.',
      category: TemplateCategory.promotional,
      channel: CampaignChannel.messenger,
      variableKeys: ['promoCode'],
      isActive: true,
      createdAt: DateTime(2025, 1, 3),
    ),
    MarketingTemplate(
      id: 'tpl_004',
      name: 'Xác nhận đặt hàng thành công',
      content:
          'Cảm ơn {{customerName}} đã đặt hàng. Mã đơn: {{orderId}}.',
      category: TemplateCategory.transactional,
      channel: CampaignChannel.email,
      variableKeys: ['customerName', 'orderId'],
      isActive: true,
      createdAt: DateTime(2025, 1, 4),
    ),
    MarketingTemplate(
      id: 'tpl_005',
      name: 'Chương trình tích điểm VIP',
      content:
          'Bạn có {{points}} điểm tích lũy. Đổi ngay hôm nay!',
      category: TemplateCategory.promotional,
      channel: CampaignChannel.zalo,
      variableKeys: ['points'],
      isActive: true,
      createdAt: DateTime(2025, 1, 5),
    ),
    MarketingTemplate(
      id: 'tpl_006',
      name: 'Thông báo bảo trì hệ thống',
      content:
          'Hệ thống sẽ bảo trì từ {{startTime}} đến {{endTime}}.',
      category: TemplateCategory.announcement,
      channel: CampaignChannel.sms,
      variableKeys: ['startTime', 'endTime'],
      isActive: true,
      createdAt: DateTime(2025, 1, 6),
    ),
    MarketingTemplate(
      id: 'tpl_007',
      name: 'Nhắc nhở gia hạn dịch vụ',
      content:
          'Dịch vụ của bạn sẽ hết hạn vào {{expiryDate}}. Gia hạn ngay!',
      category: TemplateCategory.reminder,
      channel: CampaignChannel.email,
      variableKeys: ['expiryDate'],
      isActive: true,
      createdAt: DateTime(2025, 1, 7),
    ),
    MarketingTemplate(
      id: 'tpl_008',
      name: 'Happy Birthday',
      content:
          'Chúc mừng sinh nhật {{customerName}}! 🎂 Nhận quà đặc biệt từ chúng tôi.',
      category: TemplateCategory.promotional,
      channel: CampaignChannel.messenger,
      variableKeys: ['customerName'],
      isActive: true,
      createdAt: DateTime(2025, 1, 8),
    ),
    MarketingTemplate(
      id: 'tpl_009',
      name: 'Đánh giá trải nghiệm',
      content:
          'Bạn vừa sử dụng dịch vụ. Hãy đánh giá trải nghiệm của bạn!',
      category: TemplateCategory.transactional,
      channel: CampaignChannel.zalo,
      variableKeys: [],
      isActive: true,
      createdAt: DateTime(2025, 1, 9),
    ),
    MarketingTemplate(
      id: 'tpl_010',
      name: 'Thông báo cập nhật chính sách',
      content:
          'Chúng tôi đã cập nhật chính sách bảo mật. Xem chi tiết tại đây.',
      category: TemplateCategory.announcement,
      channel: CampaignChannel.email,
      variableKeys: [],
      isActive: true,
      createdAt: DateTime(2025, 1, 10),
    ),
  ];

  final List<BroadcastCampaign> _campaigns = [
    BroadcastCampaign(
      id: 'cmp_001',
      name: 'Chiến dịch Tết 2025',
      templateId: 'tpl_003',
      status: CampaignStatus.completed,
      channel: CampaignChannel.messenger,
      sentCount: 1200,
      deliveredCount: 1150,
      failedCount: 50,
      createdAt: DateTime(2025, 1, 15),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.all,
        tagValues: [],
        estimatedCount: 1200,
      ),
    ),
    BroadcastCampaign(
      id: 'cmp_002',
      name: 'Flash Sale Tháng 3',
      templateId: 'tpl_003',
      status: CampaignStatus.running,
      channel: CampaignChannel.zalo,
      sentCount: 430,
      deliveredCount: 415,
      failedCount: 15,
      createdAt: DateTime(2025, 3, 1),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.segment,
        tagValues: [],
        segmentValue: 'VIP',
        estimatedCount: 800,
      ),
    ),
    BroadcastCampaign(
      id: 'cmp_003',
      name: 'Chào mừng khách mới Q1',
      templateId: 'tpl_001',
      status: CampaignStatus.scheduled,
      channel: CampaignChannel.messenger,
      sentCount: 0,
      deliveredCount: 0,
      failedCount: 0,
      createdAt: DateTime(2025, 3, 5),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.all,
        tagValues: [],
        estimatedCount: 350,
      ),
    ),
    BroadcastCampaign(
      id: 'cmp_004',
      name: 'Nhắc nhở tái mua hàng',
      templateId: 'tpl_007',
      status: CampaignStatus.paused,
      channel: CampaignChannel.email,
      sentCount: 320,
      deliveredCount: 300,
      failedCount: 20,
      createdAt: DateTime(2025, 2, 10),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.tag,
        tagValues: ['vip', 'regular'],
        estimatedCount: 500,
      ),
    ),
    BroadcastCampaign(
      id: 'cmp_005',
      name: 'Sinh nhật khách hàng tháng 3',
      templateId: 'tpl_008',
      status: CampaignStatus.draft,
      channel: CampaignChannel.messenger,
      sentCount: 0,
      deliveredCount: 0,
      failedCount: 0,
      createdAt: DateTime(2025, 3, 10),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.all,
        tagValues: [],
        estimatedCount: 0,
      ),
    ),
    BroadcastCampaign(
      id: 'cmp_006',
      name: 'Thông báo chính sách mới',
      templateId: 'tpl_010',
      status: CampaignStatus.failed,
      channel: CampaignChannel.sms,
      sentCount: 50,
      deliveredCount: 10,
      failedCount: 40,
      errorMessage: 'SMS gateway error',
      createdAt: DateTime(2025, 3, 12),
      targeting: const CampaignRecipientTarget(
        filterType: RecipientFilterType.all,
        tagValues: [],
        estimatedCount: 200,
      ),
    ),
  ];

  FacebookAdminState _facebookAdminState = const FacebookAdminState(
    status: FacebookAdminStatus.notConnected,
  );

  @override
  Future<MarketingOverview> getMarketingOverview() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MarketingOverview(
      campaigns: List.unmodifiable(_campaigns),
      templates: List.unmodifiable(_templates),
      facebookAdmin: _facebookAdminState,
    );
  }

  @override
  Future<List<BroadcastCampaign>> getCampaigns() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_campaigns);
  }

  @override
  Future<List<MarketingTemplate>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_templates);
  }

  @override
  Future<TemplateSaveResult> saveTemplate(MarketingTemplate template) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final MarketingTemplate toSave;
    if (template.id.isEmpty) {
      toSave = template.copyWith(
        id: 'tpl_new_${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      toSave = template;
    }
    final index = _templates.indexWhere((t) => t.id == toSave.id);
    if (index >= 0) {
      _templates[index] = toSave;
    } else {
      _templates.add(toSave);
    }
    return TemplateSaveResult(
      isSuccess: true,
      messageKey: 'marketing_success_template_saved',
      template: toSave,
    );
  }

  @override
  Future<TemplateSaveResult> deleteTemplate(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _templates.removeWhere((t) => t.id == id);
    return const TemplateSaveResult(
      isSuccess: true,
      messageKey: 'marketing_success_template_deleted',
    );
  }

  @override
  Future<BroadcastCampaign> createCampaign(BroadcastCampaign campaign) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final newCampaign = campaign.copyWith(
      id: 'cmp_new_${DateTime.now().millisecondsSinceEpoch}',
    );
    _campaigns.add(newCampaign);
    return newCampaign;
  }

  @override
  Future<CampaignActionResult> startCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _campaigns[index] = _campaigns[index].copyWith(
        status: CampaignStatus.running,
        startedAt: DateTime.now(),
      );
    }
    return CampaignActionResult(
      campaignId: id,
      newStatus: CampaignStatus.running,
      messageKey: 'marketing_success_campaign_started',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignActionResult> stopCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _campaigns[index] = _campaigns[index].copyWith(
        status: CampaignStatus.paused,
      );
    }
    return CampaignActionResult(
      campaignId: id,
      newStatus: CampaignStatus.paused,
      messageKey: 'marketing_success_campaign_stopped',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignActionResult> resumeCampaign(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _campaigns[index] = _campaigns[index].copyWith(
        status: CampaignStatus.running,
      );
    }
    return CampaignActionResult(
      campaignId: id,
      newStatus: CampaignStatus.running,
      messageKey: 'marketing_success_campaign_resumed',
      isSuccess: true,
    );
  }

  @override
  Future<CampaignRecipientTarget> estimateAudience(
      CampaignRecipientTarget target) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final int estimated;
    switch (target.filterType) {
      case RecipientFilterType.all:
        estimated = 1500;
        break;
      case RecipientFilterType.segment:
        estimated = 800;
        break;
      case RecipientFilterType.tag:
        estimated = 400;
        break;
      case RecipientFilterType.channel:
        estimated = 600;
        break;
    }
    return target.copyWith(estimatedCount: estimated);
  }

  @override
  Future<FacebookAdminState> connectFacebookAdmin(String accessToken) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _facebookAdminState = FacebookAdminState(
      status: FacebookAdminStatus.connected,
      adminName: 'Test Admin',
      adminEmail: 'admin@test.com',
      pageId: '12345',
      pageName: 'Jarvis Demo Page',
      connectedAt: DateTime.now(),
    );
  }

  @override
  Future<FacebookAdminState> disconnectFacebookAdmin() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _facebookAdminState =
        const FacebookAdminState(status: FacebookAdminStatus.notConnected);
  }
}
