import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class GenerateZaloQrUseCase extends UseCase<ZaloQr, void> {
  final OmnichannelRepository _repository;

  GenerateZaloQrUseCase(this._repository);

  @override
  Future<ZaloQr> call({required void params}) {
    return _repository.generateZaloQr();
  }
}
