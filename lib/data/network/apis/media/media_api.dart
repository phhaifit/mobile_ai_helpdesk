import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/media/media_file.dart';

class MediaApi {
  final DioClient _dioClient;

  MediaApi(this._dioClient);

  Future<MediaFile> uploadFile(String tenantId, PlatformFile file) async {
    final MultipartFile multipart;
    if (file.bytes != null) {
      multipart = MultipartFile.fromBytes(file.bytes!, filename: file.name);
    } else if (file.path != null) {
      multipart = await MultipartFile.fromFile(file.path!, filename: file.name);
    } else {
      throw Exception('File has no bytes or path available');
    }

    final formData = FormData.fromMap({'file': multipart});

    final response = await _dioClient.dio.post(
      Endpoints.uploadFile(tenantId),
      data: formData,
    );

    return MediaFile.fromJson(response.data as Map<String, dynamic>);
  }
}
