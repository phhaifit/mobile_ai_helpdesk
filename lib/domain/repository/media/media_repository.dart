import 'package:file_picker/file_picker.dart';

import '/domain/entity/media/media_file.dart';

abstract class MediaRepository {
  Future<MediaFile> uploadFile(String tenantId, PlatformFile file);
}
