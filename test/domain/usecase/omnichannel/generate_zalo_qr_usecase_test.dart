import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/generate_zalo_qr_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOmnichannelRepository implements OmnichannelRepository {
  @override
  Future<ZaloQr> generateZaloQr() async {
    return const ZaloQr(
      code: 'test_qr_code_data',
      url: 'test_url',
    );
  }

  @override
  Future<ZaloQrStatusUpdate> getZaloQrStatus(String qrCode) async =>
      throw UnimplementedError();
  @override
  Future<ActionFeedback> connectZalo(String authCode) async =>
      throw UnimplementedError();
  @override
  Future<ActionFeedback> deleteZalo() async => throw UnimplementedError();
  @override
  Future<OmnichannelOverview> getOverview() async => throw UnimplementedError();
  @override
  Future<ActionFeedback> connectMessenger({String? authCode}) async =>
      throw UnimplementedError();
  @override
  Future<ActionFeedback> disconnectMessenger({String? channelId}) async =>
      throw UnimplementedError();
  @override
  Future<ActionFeedback> retryZaloSync() async => throw UnimplementedError();
  @override
  Future<ActionFeedback> syncMessengerData() async =>
      throw UnimplementedError();
  @override
  Future<ActionFeedback> updateMessengerSettings(
    MessengerSettingsUpdate settings,
  ) async => throw UnimplementedError();
  @override
  Future<ActionFeedback> updateZaloAssignments(
    List<ZaloAssignmentUpdate> updates,
  ) async => throw UnimplementedError();
  @override
  Future<ActionFeedback> disconnectZalo() async => throw UnimplementedError();
}

void main() {
  group('GenerateZaloQrUseCase', () {
    late GenerateZaloQrUseCase useCase;
    late MockOmnichannelRepository repository;

    setUp(() {
      repository = MockOmnichannelRepository();
      useCase = GenerateZaloQrUseCase(repository);
    });

    test('should return ZaloQr from repository', () async {
      final result = await useCase.call(params: null);

      expect(result.code, 'test_qr_code_data');
      expect(result.url, 'test_url');
    });
  });
}
