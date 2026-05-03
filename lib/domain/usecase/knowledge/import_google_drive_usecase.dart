import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/knowledge/knowledge_source.dart';
import 'package:ai_helpdesk/domain/repository/knowledge/knowledge_repository.dart';

class ImportGoogleDriveParams {
  final String name;
  final List<String> includePaths;
  final String customerSupportId;
  final GoogleDriveCredentials credentials;
  final CrawlInterval interval;

  const ImportGoogleDriveParams({
    required this.name,
    required this.includePaths,
    required this.customerSupportId,
    required this.credentials,
    required this.interval,
  });
}

class ImportGoogleDriveUseCase
    extends UseCase<KnowledgeSource, ImportGoogleDriveParams> {
  final KnowledgeRepository _repository;

  ImportGoogleDriveUseCase(this._repository);

  @override
  Future<KnowledgeSource> call({required ImportGoogleDriveParams params}) {
    return _repository.importGoogleDrive(
      name: params.name,
      includePaths: params.includePaths,
      customerSupportId: params.customerSupportId,
      credentials: params.credentials,
      interval: params.interval,
    );
  }
}
