import 'dart:async';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:ai_helpdesk/domain/repository/omnichannel/omnichannel_repository.dart';

class GetZaloQrStatusUseCase extends UseCase<ZaloQrStatusUpdate, String> {
  final OmnichannelRepository _repository;

  GetZaloQrStatusUseCase(this._repository);

  @override
  Future<ZaloQrStatusUpdate> call({required String params}) {
    return _repository.getZaloQrStatus(params);
  }
}
