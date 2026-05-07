import 'package:ai_helpdesk/domain/entity/customer/tag.dart';
import 'package:ai_helpdesk/domain/repository/tag/tag_repository.dart';
import 'package:ai_helpdesk/data/network/apis/tag/tag_api.dart';

class TagRepositoryImpl implements TagRepository {
  final TagApi _api;

  TagRepositoryImpl(this._api);

  @override
  Future<List<Tag>> getTags() async {
    final dtos = await _api.getTags();
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Tag> createTag(String tagName) async {
    final dto = await _api.createTag(tagName);
    return dto.toEntity();
  }

  @override
  Future<Tag> updateTag(String tagId, String tagName) async {
    final dto = await _api.updateTag(tagId, tagName);
    return dto.toEntity();
  }

  @override
  Future<void> deleteTag(String tagId) async {
    await _api.deleteTag(tagId);
  }
}
