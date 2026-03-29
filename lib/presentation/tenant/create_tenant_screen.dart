import 'package:ai_helpdesk/constants/colors.dart';
import 'package:ai_helpdesk/di/service_locator.dart';
import 'package:ai_helpdesk/domain/entity/team_member/team_member.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:ai_helpdesk/presentation/tenant/store/tenant_store.dart';
import 'package:ai_helpdesk/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

/// Multi-step onboarding to create a new organization (tenant), Jarvis Helpdesk style.
class CreateTenantScreen extends StatefulWidget {
  const CreateTenantScreen({super.key});

  @override
  State<CreateTenantScreen> createState() => _CreateTenantScreenState();
}

class _CreateTenantScreenState extends State<CreateTenantScreen> {
  final TenantStore _tenantStore = getIt<TenantStore>();
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteStep3Controller = TextEditingController();
  final TextEditingController _otherProblemController = TextEditingController();
  final TextEditingController _trialInputController = TextEditingController();
  final TextEditingController _websiteStep5Controller = TextEditingController();
  final ScrollController _trialScrollController = ScrollController();

  int _stepIndex = 0;

  static const List<String> _stepLabelKeys = [
    'create_tenant_step_info',
    'create_tenant_step_personalize',
    'create_tenant_step_data',
    'create_tenant_step_trial',
    'create_tenant_step_upgrade',
  ];

  static const List<String> _industryKeys = [
    'create_tenant_industry_fnb',
    'create_tenant_industry_retail',
    'create_tenant_industry_services',
    'create_tenant_industry_tech',
    'create_tenant_industry_other',
  ];

  static const List<String> _scaleKeys = [
    'create_tenant_scale_1_10',
    'create_tenant_scale_11_50',
    'create_tenant_scale_51_200',
    'create_tenant_scale_200_plus',
  ];

  static const List<String> _problemKeys = [
    'create_tenant_problem_slow',
    'create_tenant_problem_repeat',
    'create_tenant_problem_after_hours',
    'create_tenant_problem_channels',
  ];

  static const List<String> _trialQuickReplyKeys = [
    'create_tenant_trial_q_hours',
    'create_tenant_trial_q_menu',
    'create_tenant_trial_q_price',
    'create_tenant_trial_q_parking',
    'create_tenant_trial_q_booking',
  ];

  String _industryKey = _industryKeys.first;
  String _scaleKey = _scaleKeys.first;
  final Set<String> _selectedProblems = {};
  final List<String> _customProblems = [];
  final List<String> _mockDocumentNames = [];
  final List<_TrialBubble> _trialBubbles = [];

  static const Color _brandBlue = Color(0xFF1890FF);
  static const Color _brandPurple = Color(0xFF7C3AED);
  static const Color _titleBlue = Color(0xFF1E40AF);
  static const Color _mutedLine = Color(0xFFE5E7EB);

  @override
  void dispose() {
    _orgNameController.dispose();
    _phoneController.dispose();
    _websiteStep3Controller.dispose();
    _otherProblemController.dispose();
    _trialInputController.dispose();
    _websiteStep5Controller.dispose();
    _trialScrollController.dispose();
    super.dispose();
  }

  String _slugFromName(String name) {
    return name
        .toLowerCase()
        .trim()
        .replaceAll(RegExp('[^a-z0-9]+'), '-')
        .replaceAll(RegExp('^-|-\$'), '');
  }

  Future<void> _finishAndCreateTenant() async {
    final name = _orgNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _stepIndex = 0);
      _step1FormKey.currentState?.validate();
      return;
    }

    final now = DateTime.now();
    await _tenantStore.createTenant(
      Tenant(
        id: 'tn-${now.millisecondsSinceEpoch}',
        name: name,
        slug: _slugFromName(name).isEmpty ? null : _slugFromName(name),
        settings: const TenantSettings(
          allowInvitations: true,
          defaultRole: TeamRole.member,
          enableAuditLog: false,
        ),
        createdAt: now,
      ),
    );

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  void _goNext() {
    if (_stepIndex == 0) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) {
        return;
      }
    }
    if (_stepIndex < 4) {
      setState(() => _stepIndex++);
    }
  }

  void _goBack() {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _addCustomProblem() {
    final t = _otherProblemController.text.trim();
    if (t.isEmpty) {
      return;
    }
    setState(() {
      _customProblems.add(t);
      _otherProblemController.clear();
    });
  }

  void _toggleProblem(String key) {
    setState(() {
      if (_selectedProblems.contains(key)) {
        _selectedProblems.remove(key);
      } else {
        _selectedProblems.add(key);
      }
    });
  }

  void _addMockDocument(AppLocalizations l) {
    setState(() {
      final name = l
          .translate('create_tenant_doc_filename')
          .replaceAll('{n}', '${_mockDocumentNames.length + 1}');
      _mockDocumentNames.add(name);
    });
  }

  void _sendTrialMessage(AppLocalizations l, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }
    setState(() {
      _trialBubbles.add(_TrialBubble(text: trimmed, isUser: true));
      _trialBubbles.add(
        _TrialBubble(
          text: l.translate('create_tenant_trial_bot_reply'),
          isUser: false,
        ),
      );
      _trialInputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_trialScrollController.hasClients) {
        _trialScrollController.animateTo(
          _trialScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Observer(
              builder: (_) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final maxCard = constraints.maxWidth > 560 ? 520.0 : constraints.maxWidth - 32;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxCard.clamp(280, 560)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildBrandBlock(l),
                              const SizedBox(height: 28),
                              _buildStepperRow(l),
                              const SizedBox(height: 28),
                              _buildCard(l),
                              if (_tenantStore.isLoading) ...[
                                const SizedBox(height: 16),
                                const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              top: 4,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: l.translate('create_tenant_close_tooltip'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBlock(AppLocalizations l) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_brandBlue, _brandPurple],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _brandBlue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l.translate('create_tenant_brand_name'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _brandBlue,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          l.translate('create_tenant_welcome_title'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_welcome_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepperRow(AppLocalizations l) {
    return LayoutBuilder(
      builder: (context, c) {
        final compact = c.maxWidth < 420;
        final circleSize = compact ? 26.0 : 30.0;
        final fontSize = compact ? 9.0 : 10.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < 5; i++) ...[
              if (i > 0)
                Padding(
                  padding: EdgeInsets.only(top: circleSize / 2 - 1),
                  child: Container(
                    width: compact ? 6 : 12,
                    height: 2,
                    color: i <= _stepIndex ? _brandBlue : _mutedLine,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _stepCircle(i, circleSize),
                    SizedBox(height: compact ? 4 : 6),
                    Text(
                      l.translate(_stepLabelKeys[i]),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: i == _stepIndex ? FontWeight.w700 : FontWeight.w500,
                        color: i <= _stepIndex ? _brandBlue : Colors.grey.shade500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _stepCircle(int index, double size) {
    final completed = index < _stepIndex;
    final active = index == _stepIndex;
    final Color bg = completed || active ? _brandBlue : const Color(0xFFD1D5DB);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(
        child: completed
            ? Icon(Icons.check, color: Colors.white, size: size * 0.5)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: size * 0.42,
                ),
              ),
      ),
    );
  }

  Widget _buildCard(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey<int>(_stepIndex),
              child: _stepBody(l),
            ),
          ),
          const SizedBox(height: 22),
          _stepFooter(l),
        ],
      ),
    );
  }

  Widget _stepBody(AppLocalizations l) {
    switch (_stepIndex) {
      case 0:
        return _step1Info(l);
      case 1:
        return _step2Personalize(l);
      case 2:
        return _step3Data(l);
      case 3:
        return _step4Trial(l);
      case 4:
        return _step5Upgrade(l);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _step1Info(AppLocalizations l) {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.translate('create_tenant_step1_title'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _titleBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.translate('create_tenant_step1_subtitle'),
            style: TextStyle(fontSize: 13, height: 1.45, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 22),
          Text(
            l.translate('create_tenant_org_name_label'),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _orgNameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: l.translate('create_tenant_org_name_hint'),
              prefixIcon: const Icon(Icons.business_outlined, color: AppColors.textTertiary),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l.translate('create_tenant_org_name_error');
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          Text(
            l.translate('create_tenant_phone_label'),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: l.translate('create_tenant_phone_hint'),
              prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textTertiary),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step2Personalize(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.translate('create_tenant_step2_title'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _titleBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_step2_subtitle'),
          style: TextStyle(fontSize: 13, height: 1.45, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Text(
          l.translate('create_tenant_industry_label'),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _industryKey,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: _industryKeys
                  .map(
                    (key) => DropdownMenuItem(
                      value: key,
                      child: Row(
                        children: [
                          Icon(Icons.local_cafe_outlined, size: 20, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          Expanded(child: Text(l.translate(key))),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _industryKey = v);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.translate('create_tenant_scale_label'),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _scaleKey,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: _scaleKeys
                  .map((key) => DropdownMenuItem(value: key, child: Text(l.translate(key))))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _scaleKey = v);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.translate('create_tenant_problems_label'),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _problemKeys.map((key) {
            final sel = _selectedProblems.contains(key);
            return FilterChip(
              label: Text(l.translate(key)),
              selected: sel,
              onSelected: (_) => _toggleProblem(key),
              selectedColor: _brandBlue.withValues(alpha: 0.15),
              checkmarkColor: _brandBlue,
              labelStyle: TextStyle(
                color: sel ? _brandBlue : Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              side: BorderSide(color: sel ? _brandBlue : Colors.grey.shade300),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _otherProblemController,
          decoration: InputDecoration(
            hintText: l.translate('create_tenant_other_problem_hint'),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          onSubmitted: (_) => _addCustomProblem(),
        ),
        if (_customProblems.isNotEmpty) ...[
          const SizedBox(height: 10),
          ..._customProblems.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.arrow_right, size: 18, color: Colors.grey.shade600),
                  Expanded(child: Text(p, style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _step3Data(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.translate('create_tenant_step3_title'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _titleBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_step3_subtitle'),
          style: TextStyle(fontSize: 13, height: 1.45, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Text(
          l.translate('create_tenant_website_label'),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _websiteStep3Controller,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: l.translate('create_tenant_website_hint'),
            prefixIcon: const Icon(Icons.language_outlined, color: AppColors.textTertiary),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          l.translate('create_tenant_docs_label'),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _addMockDocument(l),
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _DottedRectPainter(color: Colors.grey.shade400),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 40, color: _brandBlue.withValues(alpha: 0.9)),
                    const SizedBox(height: 12),
                    Text(
                      l.translate('create_tenant_docs_drop_hint'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.translate('create_tenant_docs_formats'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_mockDocumentNames.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._mockDocumentNames.map(
            (n) => ListTile(
              dense: true,
              leading: const Icon(Icons.insert_drive_file_outlined, size: 20),
              title: Text(n, style: const TextStyle(fontSize: 13)),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _mockDocumentNames.remove(n)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _step4Trial(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.translate('create_tenant_step4_title'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _titleBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_step4_subtitle'),
          style: TextStyle(fontSize: 13, height: 1.45, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: const Color(0xFFFAFBFC),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(colors: [_brandBlue, _brandPurple]),
                      ),
                      child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l.translate('create_tenant_trial_agent_name'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.translate('create_tenant_trial_hint'),
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _trialQuickReplyKeys.map((key) {
                        return ActionChip(
                          label: Text(l.translate(key), style: const TextStyle(fontSize: 12)),
                          onPressed: () => _sendTrialMessage(l, l.translate(key)),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        controller: _trialScrollController,
                        shrinkWrap: true,
                        itemCount: _trialBubbles.length,
                        itemBuilder: (context, i) {
                          final b = _trialBubbles[i];
                          return Align(
                            alignment: b.isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              constraints: const BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: b.isUser ? _brandBlue : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: b.isUser ? null : Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                b.text,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: b.isUser ? Colors.white : Colors.grey.shade800,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _trialInputController,
                        decoration: InputDecoration(
                          hintText: l.translate('create_tenant_trial_input_hint'),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onSubmitted: (v) => _sendTrialMessage(l, v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: _brandBlue,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _sendTrialMessage(l, _trialInputController.text),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step5Upgrade(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_brandBlue, _brandPurple],
              ),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l.translate('create_tenant_step5_title'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _titleBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.translate('create_tenant_step5_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, height: 1.45, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF3F4F6),
            border: Border.all(color: Color(0xFFD1D5DB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.translate('create_tenant_step5_website_optional'),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _websiteStep5Controller,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: l.translate('create_tenant_website_hint'),
                  prefixIcon: const Icon(Icons.language_outlined, color: AppColors.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l.translate('create_tenant_step5_website_helper'),
                style: TextStyle(fontSize: 12, height: 1.4, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepFooter(AppLocalizations l) {
    if (_stepIndex == 0) {
      return _gradientButton(
        label: l.translate('create_tenant_continue'),
        onPressed: _tenantStore.isLoading ? null : _goNext,
        fullWidth: true,
      );
    }
    if (_stepIndex == 4) {
      return Row(
        children: [
          Expanded(
            child: _secondaryButton(
              label: l.translate('create_tenant_skip'),
              onPressed: _tenantStore.isLoading ? null : _finishAndCreateTenant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _gradientButton(
              label: l.translate('create_tenant_finish'),
              onPressed: _tenantStore.isLoading ? null : _finishAndCreateTenant,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: _secondaryButton(
            label: l.translate('create_tenant_back'),
            onPressed: _tenantStore.isLoading ? null : _goBack,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _gradientButton(
            label: l.translate('create_tenant_continue'),
            onPressed: _tenantStore.isLoading ? null : _goNext,
          ),
        ),
      ],
    );
  }

  Widget _secondaryButton({required String label, required VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: _brandBlue,
        backgroundColor: const Color(0xFFEFF6FF),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: _brandBlue.withValues(alpha: 0.35)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _gradientButton({
    required String label,
    required VoidCallback? onPressed,
    bool fullWidth = false,
  }) {
    final inner = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: onPressed == null
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF1890FF), Color(0xFF6366F1)],
                ),
          color: onPressed == null ? Colors.grey.shade400 : null,
        ),
        child: inner,
      ),
    );
  }
}

class _TrialBubble {
  const _TrialBubble({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

class _DottedRectPainter extends CustomPainter {
  _DottedRectPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const dash = 5.0;
    const gap = 4.0;
    const radius = Radius.circular(12);
    final r = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(r);
    for (final metric in path.computeMetrics(forceClosed: true)) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
