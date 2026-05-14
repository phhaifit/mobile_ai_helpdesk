import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class SendZaloMessageParams {
  final String recipient;
  final String message;

  const SendZaloMessageParams({
    required this.recipient,
    required this.message,
  });
}

class SendZaloMessageUseCase
    extends UseCase<ActionFeedback, SendZaloMessageParams> {
  final OmnichannelRepository _repository;

  SendZaloMessageUseCase(this._repository);

  @override
  Future<ActionFeedback> call({required SendZaloMessageParams params}) {
    return _repository.sendZaloMessage(
      recipient: params.recipient,
      message: params.message,
    );
  }
}
