import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/data/network/dto/tag/tag_dto.dart';

class TagApi {
  final DioClient _dioClient;

  TagApi(this._dioClient);

  Future<List<TagDto>> getTags() async {
    final response = await _dioClient.dio.get(Endpoints.tags);
    final listTagDto = ListTagDto.fromJson(response.data as Map<String, dynamic>);
    return listTagDto.data;
  }

  Future<TagDto> createTag(String tagName) async {
    final response = await _dioClient.dio.post(
      Endpoints.tags,
      data: {'tagName': tagName},
    );
    return TagDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<TagDto> updateTag(String tagId, String tagName) async {
    final response = await _dioClient.dio.put(
      Endpoints.tag(tagId),
      data: {'tagName': tagName},
    );
    return TagDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteTag(String tagId) async {
    await _dioClient.dio.delete(Endpoints.tag(tagId));
  }
}
