import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/repository/marketing/marketing_broadcast_repository.dart';

class _FakeCustomer {
  final String id;
  final String displayName;
  final String channel;
  final String channelAddress;
  final String segment;
  final List<String> tags;

  const _FakeCustomer({
    required this.id,
    required this.displayName,
    required this.channel,
    required this.channelAddress,
    required this.segment,
    required this.tags,
  });
}

class MockMarketingBroadcastRepositoryImpl
    implements MarketingBroadcastRepository {
  static const Duration _delay = Duration(milliseconds: 400);

  final List<BroadcastTemplate> _templates = <BroadcastTemplate>[
    BroadcastTemplate(
      id: 'btpl_001',
      name: 'Chào mừng khách mới',
      content: 'Xin chào {{name}}, cảm ơn bạn đã tham gia.',
      category: 'promotional',
      channel: 'messenger',
      variableKeys: const ['name'],
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
    ),
    BroadcastTemplate(
      id: 'btpl_002',
      name: 'Khuyến mãi Flash Sale',
      content: 'Flash Sale 50% – mã {{code}}.',
      category: 'promotional',
      channel: 'messenger',
      variableKeys: const ['code'],
      isActive: true,
      createdAt: DateTime(2025, 1, 2),
    ),
    BroadcastTemplate(
      id: 'btpl_003',
      name: 'Nhắc nhở đơn hàng',
      content: 'Đơn #{{orderId}} sẽ giao {{date}}.',
      category: 'transactional',
      channel: 'zalo',
      variableKeys: const ['orderId', 'date'],
      isActive: true,
      createdAt: DateTime(2025, 1, 3),
    ),
  ];

  final List<BroadcastItem> _broadcasts = <BroadcastItem>[
    BroadcastItem(
      id: 'bc_001',
      name: 'Chiến dịch Tết 2026',
      templateId: 'btpl_002',
      status: BroadcastStatus.completed,
      recipientCount: 1200,
      sentCount: 1200,
      deliveredCount: 1150,
      failedCount: 50,
      scheduledAt: DateTime(2026, 1, 15),
      startedAt: DateTime(2026, 1, 15, 9),
      completedAt: DateTime(2026, 1, 15, 10),
      createdAt: DateTime(2026, 1, 10),
    ),
    BroadcastItem(
      id: 'bc_002',
      name: 'Flash Sale Tháng 4',
      templateId: 'btpl_002',
      status: BroadcastStatus.running,
      recipientCount: 800,
      sentCount: 430,
      deliveredCount: 415,
      failedCount: 15,
      scheduledAt: DateTime(2026, 4, 25),
      startedAt: DateTime(2026, 4, 25, 9),
      createdAt: DateTime(2026, 4, 20),
    ),
    BroadcastItem(
      id: 'bc_003',
      name: 'Chào mừng khách mới Q2',
      templateId: 'btpl_001',
      status: BroadcastStatus.scheduled,
      recipientCount: 350,
      sentCount: 0,
      deliveredCount: 0,
      failedCount: 0,
      scheduledAt: DateTime(2026, 5, 1),
      createdAt: DateTime(2026, 4, 22),
    ),
    BroadcastItem(
      id: 'bc_004',
      name: 'Sinh nhật khách hàng',
      templateId: 'btpl_001',
      status: BroadcastStatus.draft,
      recipientCount: 0,
      sentCount: 0,
      deliveredCount: 0,
      failedCount: 0,
      createdAt: DateTime(2026, 4, 28),
    ),
  ];

  final List<FacebookAdAccount> _facebookAccounts = <FacebookAdAccount>[
    FacebookAdAccount(
      id: 'fb_acc_001',
      adminName: 'Admin Demo',
      adminEmail: 'admin@demo.com',
      pageId: 'page_001',
      pageName: 'Jarvis Demo Page',
      status: 'connected',
      connectedAt: DateTime(2026, 4, 1),
      tokenExpiresAt: DateTime(2027, 4, 1),
    ),
  ];

  final List<FacebookPage> _facebookPages = <FacebookPage>[
    const FacebookPage(id: 'page_001', name: 'Jarvis Demo Page', isSelected: true),
    const FacebookPage(id: 'page_002', name: 'Jarvis Beta Page', isSelected: false),
  ];

  final List<_FakeCustomer> _customers = _buildFakeCustomers();

  static List<_FakeCustomer> _buildFakeCustomers() {
    const segments = <String>['VIP', 'Regular', 'New'];
    const channels = <String>['messenger', 'zalo', 'email', 'sms'];
    const tagPool = <String>['vip', 'regular', 'new', 'promo', 'returning'];
    final result = <_FakeCustomer>[];
    for (var i = 0; i < 50; i++) {
      final segment = segments[i % segments.length];
      final channel = channels[i % channels.length];
      final tags = <String>[
        tagPool[i % tagPool.length],
        if (i % 3 == 0) 'promo',
        if (i % 5 == 0) 'returning',
      ];
      final addressByChannel = <String, String>{
        'messenger': 'msgr_user_$i',
        'zalo': 'zalo_user_$i',
        'email': 'user$i@example.com',
        'sms': '+84900${i.toString().padLeft(6, '0')}',
      };
      result.add(_FakeCustomer(
        id: 'cust_${i.toString().padLeft(3, '0')}',
        displayName: 'Khách hàng $i',
        channel: channel,
        channelAddress: addressByChannel[channel] ?? 'addr_$i',
        segment: segment,
        tags: tags,
      ));
    }
    return result;
  }

  // ---------- Templates ----------
  @override
  Future<BroadcastPage<BroadcastTemplate>> getBroadcastTemplates({
    required BroadcastTemplateQuery query,
  }) async {
    await Future<void>.delayed(_delay);
    final filtered = _templates.where((t) {
      final matchesSearch = query.search == null ||
          query.search!.isEmpty ||
          t.name.toLowerCase().contains(query.search!.toLowerCase());
      final matchesCategory =
          query.category == null || query.category == t.category;
      final matchesChannel =
          query.channel == null || query.channel == t.channel;
      return matchesSearch && matchesCategory && matchesChannel;
    }).toList();
    return _paginate<BroadcastTemplate>(filtered, query.offset, query.limit);
  }

  @override
  Future<BroadcastTemplate> getBroadcastTemplateDetail(String templateId) async {
    await Future<void>.delayed(_delay);
    return _templates.firstWhere((t) => t.id == templateId);
  }

  @override
  Future<BroadcastTemplate> createBroadcastTemplate(
    BroadcastTemplateUpsertData data,
  ) async {
    await Future<void>.delayed(_delay);
    final created = BroadcastTemplate(
      id: 'btpl_${DateTime.now().millisecondsSinceEpoch}',
      name: data.name,
      content: data.content,
      category: data.category,
      channel: data.channel,
      variableKeys: data.variableKeys,
      isActive: data.isActive,
      createdAt: DateTime.now(),
    );
    _templates.add(created);
    return created;
  }

  @override
  Future<BroadcastTemplate> updateBroadcastTemplate({
    required String templateId,
    required BroadcastTemplateUpsertData data,
  }) async {
    await Future<void>.delayed(_delay);
    final index = _templates.indexWhere((t) => t.id == templateId);
    final updated = BroadcastTemplate(
      id: templateId,
      name: data.name,
      content: data.content,
      category: data.category,
      channel: data.channel,
      variableKeys: data.variableKeys,
      isActive: data.isActive,
      createdAt: index >= 0 ? _templates[index].createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (index >= 0) {
      _templates[index] = updated;
    } else {
      _templates.add(updated);
    }
    return updated;
  }

  @override
  Future<bool> deleteBroadcastTemplate(String templateId) async {
    await Future<void>.delayed(_delay);
    _templates.removeWhere((t) => t.id == templateId);
    return true;
  }

  // ---------- Broadcasts ----------
  @override
  Future<BroadcastPage<BroadcastItem>> getBroadcasts({
    required BroadcastQuery query,
  }) async {
    await Future<void>.delayed(_delay);
    final filtered = query.status == null
        ? _broadcasts
        : _broadcasts.where((b) => b.status == query.status).toList();
    return _paginate<BroadcastItem>(filtered, query.offset, query.limit);
  }

  @override
  Future<BroadcastItem> getBroadcastDetail(String broadcastId) async {
    await Future<void>.delayed(_delay);
    return _broadcasts.firstWhere((b) => b.id == broadcastId);
  }

  @override
  Future<BroadcastItem> createBroadcast(BroadcastUpsertData data) async {
    await Future<void>.delayed(_delay);
    final created = BroadcastItem(
      id: 'bc_${DateTime.now().millisecondsSinceEpoch}',
      name: data.name,
      templateId: data.templateId,
      status: data.scheduledAt != null
          ? BroadcastStatus.scheduled
          : BroadcastStatus.draft,
      recipientCount: 0,
      sentCount: 0,
      deliveredCount: 0,
      failedCount: 0,
      scheduledAt: data.scheduledAt,
      createdAt: DateTime.now(),
    );
    _broadcasts.add(created);
    return created;
  }

  @override
  Future<BroadcastItem> updateBroadcast({
    required String broadcastId,
    required BroadcastUpsertData data,
  }) async {
    await Future<void>.delayed(_delay);
    final index = _broadcasts.indexWhere((b) => b.id == broadcastId);
    if (index < 0) {
      throw StateError('Broadcast not found: $broadcastId');
    }
    final current = _broadcasts[index];
    final updated = BroadcastItem(
      id: current.id,
      name: data.name,
      templateId: data.templateId,
      status: data.scheduledAt != null && current.status == BroadcastStatus.draft
          ? BroadcastStatus.scheduled
          : current.status,
      recipientCount: current.recipientCount,
      sentCount: current.sentCount,
      deliveredCount: current.deliveredCount,
      failedCount: current.failedCount,
      scheduledAt: data.scheduledAt,
      startedAt: current.startedAt,
      completedAt: current.completedAt,
      createdAt: current.createdAt,
    );
    _broadcasts[index] = updated;
    return updated;
  }

  @override
  Future<bool> deleteBroadcast(String broadcastId) async {
    await Future<void>.delayed(_delay);
    _broadcasts.removeWhere((b) => b.id == broadcastId);
    return true;
  }

  @override
  Future<BroadcastItem> executeBroadcast(String broadcastId) async {
    await Future<void>.delayed(_delay);
    return _transitionBroadcast(
      broadcastId,
      status: BroadcastStatus.running,
      startedAt: DateTime.now(),
    );
  }

  @override
  Future<BroadcastItem> stopBroadcast(String broadcastId) async {
    await Future<void>.delayed(_delay);
    return _transitionBroadcast(broadcastId, status: BroadcastStatus.paused);
  }

  @override
  Future<BroadcastItem> resumeBroadcast(String broadcastId) async {
    await Future<void>.delayed(_delay);
    return _transitionBroadcast(broadcastId, status: BroadcastStatus.running);
  }

  // ---------- Recipients ----------
  @override
  Future<BroadcastPage<BroadcastRecipient>> getBroadcastRecipients({
    required BroadcastRecipientsQuery query,
  }) async {
    await Future<void>.delayed(_delay);
    final filtered = _customers.where((c) => _matchesFilter(c, query.filter));
    final mapped = filtered
        .map((c) => BroadcastRecipient(
              id: c.id,
              displayName: c.displayName,
              channelAddress: c.channelAddress,
              segmentValue: c.segment,
              tags: c.tags,
            ))
        .toList();
    return _paginate<BroadcastRecipient>(mapped, query.offset, query.limit);
  }

  bool _matchesFilter(_FakeCustomer c, BroadcastRecipientsFilter filter) {
    if (filter.tagValues.isNotEmpty) {
      final hasTag = filter.tagValues.any((t) => c.tags.contains(t.toLowerCase()));
      if (!hasTag) return false;
    }
    if (filter.segmentValue != null && filter.segmentValue!.isNotEmpty) {
      if (c.segment != filter.segmentValue) return false;
    }
    if (filter.channel != null && filter.channel!.isNotEmpty) {
      if (c.channel != filter.channel) return false;
    }
    return true;
  }

  // ---------- Receipts ----------
  @override
  Future<BroadcastPage<BroadcastDeliveryReceipt>> getBroadcastDeliveryReceipts({
    required String broadcastId,
    required PaginationQuery query,
  }) async {
    await Future<void>.delayed(_delay);
    final broadcast = _broadcasts.firstWhere(
      (b) => b.id == broadcastId,
      orElse: () => throw StateError('Broadcast not found'),
    );
    final receipts = <BroadcastDeliveryReceipt>[];
    final total = broadcast.sentCount;
    for (var i = 0; i < total; i++) {
      final isFailed = i < broadcast.failedCount;
      receipts.add(BroadcastDeliveryReceipt(
        id: 'rcp_${broadcastId}_$i',
        broadcastId: broadcastId,
        recipientId: 'cust_${i.toString().padLeft(3, '0')}',
        status: isFailed ? 'failed' : 'delivered',
        channelMessageId: isFailed ? null : 'msg_$i',
        errorCode: isFailed ? 'ERR_DELIVERY' : null,
        errorMessage: isFailed ? 'Không gửi được' : null,
        sentAt: broadcast.startedAt,
        deliveredAt: isFailed ? null : broadcast.startedAt,
        failedAt: isFailed ? broadcast.startedAt : null,
      ));
    }
    return _paginate<BroadcastDeliveryReceipt>(receipts, query.offset, query.limit);
  }

  // ---------- Facebook ----------
  @override
  Future<List<FacebookAdAccount>> getFacebookAdminAccounts() async {
    await Future<void>.delayed(_delay);
    return List<FacebookAdAccount>.unmodifiable(_facebookAccounts);
  }

  @override
  Future<FacebookAdAccount> createFacebookAdminAccount(
    FacebookAdminAccountCreateData data,
  ) async {
    await Future<void>.delayed(_delay);
    final created = FacebookAdAccount(
      id: data.accountId ?? 'fb_acc_${DateTime.now().millisecondsSinceEpoch}',
      adminName: data.adminName ?? data.name,
      adminEmail: data.adminEmail,
      pageId: data.pageId,
      pageName: data.pageName,
      status: 'connected',
      connectedAt: DateTime.now(),
      tokenExpiresAt: DateTime.now().add(const Duration(days: 365)),
    );
    final index = _facebookAccounts.indexWhere((a) => a.id == created.id);
    if (index >= 0) {
      _facebookAccounts[index] = created;
    } else {
      _facebookAccounts.add(created);
    }
    return created;
  }

  @override
  Future<bool> disconnectFacebookAdminAccount(String accountId) async {
    await Future<void>.delayed(_delay);
    _facebookAccounts.removeWhere((a) => a.id == accountId);
    return true;
  }

  @override
  Future<FacebookAdAccount> reauthFacebookAdminAccount({
    required String accountId,
    required String accessToken,
  }) async {
    await Future<void>.delayed(_delay);
    final index = _facebookAccounts.indexWhere((a) => a.id == accountId);
    if (index < 0) {
      throw StateError('Facebook account not found: $accountId');
    }
    final current = _facebookAccounts[index];
    final reauthed = FacebookAdAccount(
      id: current.id,
      adminName: current.adminName,
      adminEmail: current.adminEmail,
      pageId: current.pageId,
      pageName: current.pageName,
      status: 'connected',
      connectedAt: current.connectedAt,
      tokenExpiresAt: DateTime.now().add(const Duration(days: 365)),
    );
    _facebookAccounts[index] = reauthed;
    return reauthed;
  }

  @override
  Future<List<FacebookPage>> getFacebookAdminPages(String accountId) async {
    await Future<void>.delayed(_delay);
    return List<FacebookPage>.unmodifiable(_facebookPages);
  }

  @override
  Future<FacebookAdAccount> selectFacebookAdminPage({
    required String accountId,
    required String pageId,
  }) async {
    await Future<void>.delayed(_delay);
    final index = _facebookAccounts.indexWhere((a) => a.id == accountId);
    if (index < 0) {
      throw StateError('Facebook account not found: $accountId');
    }
    final page = _facebookPages.firstWhere(
      (p) => p.id == pageId,
      orElse: () => FacebookPage(id: pageId, name: 'Page $pageId'),
    );
    final current = _facebookAccounts[index];
    final updated = FacebookAdAccount(
      id: current.id,
      adminName: current.adminName,
      adminEmail: current.adminEmail,
      pageId: page.id,
      pageName: page.name,
      status: current.status ?? 'connected',
      connectedAt: current.connectedAt,
      tokenExpiresAt: current.tokenExpiresAt,
    );
    _facebookAccounts[index] = updated;
    for (var i = 0; i < _facebookPages.length; i++) {
      _facebookPages[i] = FacebookPage(
        id: _facebookPages[i].id,
        name: _facebookPages[i].name,
        isSelected: _facebookPages[i].id == pageId,
      );
    }
    return updated;
  }

  // ---------- Helpers ----------
  BroadcastPage<T> _paginate<T>(List<T> items, int offset, int limit) {
    final safeOffset = offset < 0 ? 0 : offset;
    final safeLimit = limit <= 0 ? items.length : limit;
    final end = (safeOffset + safeLimit).clamp(0, items.length);
    final slice = safeOffset >= items.length
        ? <T>[]
        : items.sublist(safeOffset, end);
    return BroadcastPage<T>(
      items: slice,
      total: items.length,
      offset: safeOffset,
      limit: safeLimit,
    );
  }

  BroadcastItem _transitionBroadcast(
    String broadcastId, {
    required BroadcastStatus status,
    DateTime? startedAt,
  }) {
    final index = _broadcasts.indexWhere((b) => b.id == broadcastId);
    if (index < 0) {
      throw StateError('Broadcast not found: $broadcastId');
    }
    final current = _broadcasts[index];
    final updated = BroadcastItem(
      id: current.id,
      name: current.name,
      templateId: current.templateId,
      status: status,
      recipientCount: current.recipientCount,
      sentCount: current.sentCount,
      deliveredCount: current.deliveredCount,
      failedCount: current.failedCount,
      scheduledAt: current.scheduledAt,
      startedAt: startedAt ?? current.startedAt,
      completedAt:
          status == BroadcastStatus.completed ? DateTime.now() : current.completedAt,
      createdAt: current.createdAt,
    );
    _broadcasts[index] = updated;
    return updated;
  }
}
