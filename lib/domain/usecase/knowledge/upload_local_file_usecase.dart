import 'dart:io';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class UploadLocalFileUseCase extends UseCase<KnowledgeSource, File> {
  final KnowledgeRepository _repository;

  UploadLocalFileUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required File params}) {
    return _repository.uploadLocalFile(params);
  }
}
