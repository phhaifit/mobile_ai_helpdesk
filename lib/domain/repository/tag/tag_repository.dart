import 'package:ai_helpdesk/domain/entity/customer/tag.dart';

abstract class TagRepository {
  Future<List<Tag>> getTags();
  Future<Tag> createTag(String tagName);
  Future<Tag> updateTag(String tagId, String tagName);
  Future<void> deleteTag(String tagId);
}
