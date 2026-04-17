import 'package:file_picker/file_picker.dart';

import '/data/network/apis/media/media_api.dart';
import '/domain/entity/media/media_file.dart';
import '/domain/repository/media/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaApi _api;

  MediaRepositoryImpl(this._api);

  @override
  Future<MediaFile> uploadFile(String tenantId, PlatformFile file) =>
      _api.uploadFile(tenantId, file);
}
