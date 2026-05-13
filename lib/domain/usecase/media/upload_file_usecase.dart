import 'package:file_picker/file_picker.dart';

import '/core/domain/usecase/use_case.dart';
import '/domain/entity/media/media_file.dart';
import '/domain/repository/media/media_repository.dart';

class UploadFileParams {
  final String tenantId;
  final PlatformFile file;

  const UploadFileParams({required this.tenantId, required this.file});
}

class UploadFileUseCase extends UseCase<MediaFile, UploadFileParams> {
  final MediaRepository _repository;

  UploadFileUseCase(this._repository);

  @override
  Future<MediaFile> call({required UploadFileParams params}) =>
      _repository.uploadFile(params.tenantId, params.file);
}
