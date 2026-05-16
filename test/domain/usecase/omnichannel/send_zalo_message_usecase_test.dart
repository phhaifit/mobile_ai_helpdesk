import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';
import 'package:ai_helpdesk/domain/usecase/omnichannel/send_zalo_message_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOmnichannelRepository extends Mock implements OmnichannelRepository {}

void main() {
  late SendZaloMessageUseCase useCase;
  late MockOmnichannelRepository mockRepository;

  setUp(() {
    mockRepository = MockOmnichannelRepository();
    useCase = SendZaloMessageUseCase(mockRepository);
  });

  group('SendZaloMessageUseCase', () {
    const tRecipient = '0912345678';
    const tMessage = 'Hello from unit test';
    const tParams = SendZaloMessageParams(recipient: tRecipient, message: tMessage);
    const tFeedback = ActionFeedback(isSuccess: true, messageKey: 'success_key');

    test('should call sendZaloMessage on the repository with correct parameters', () async {
      // arrange
      when(() => mockRepository.sendZaloMessage(
            recipient: any(named: 'recipient'),
            message: any(named: 'message'),
          )).thenAnswer((_) async => tFeedback);

      // act
      final result = await useCase.call(params: tParams);

      // assert
      expect(result, tFeedback);
      verify(() => mockRepository.sendZaloMessage(
            recipient: tRecipient,
            message: tMessage,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return isSuccess: false when repository fails', () async {
      // arrange
      const errorFeedback = ActionFeedback(isSuccess: false, messageKey: 'error_key');
      when(() => mockRepository.sendZaloMessage(
            recipient: any(named: 'recipient'),
            message: any(named: 'message'),
          )).thenAnswer((_) async => errorFeedback);

      // act
      final result = await useCase.call(params: tParams);

      // assert
      expect(result.isSuccess, false);
      expect(result.messageKey, 'error_key');
      verify(() => mockRepository.sendZaloMessage(
            recipient: tRecipient,
            message: tMessage,
          )).called(1);
    });
  });
}
