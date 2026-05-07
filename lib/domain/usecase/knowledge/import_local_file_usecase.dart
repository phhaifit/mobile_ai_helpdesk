import 'dart:io';

import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ImportLocalFileParams {
  final File file;
  final String fileName;
  final void Function(int sent, int total)? onSendProgress;

  const ImportLocalFileParams({
    required this.file,
    required this.fileName,
    this.onSendProgress,
  });
}

class ImportLocalFileUseCase
    extends UseCase<KnowledgeSource, ImportLocalFileParams> {
  final KnowledgeRepository _repository;

  ImportLocalFileUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required ImportLocalFileParams params}) {
    return _repository.importLocalFile(
      file: params.file,
      fileName: params.fileName,
      onSendProgress: params.onSendProgress,
    );
  }
}
