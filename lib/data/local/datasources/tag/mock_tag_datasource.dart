import 'package:ai_helpdesk/domain/entity/customer/tag.dart';

class MockTagDataSource {
  final List<Tag> _tags = [];

  MockTagDataSource() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    _tags.addAll([
      Tag(
        id: 'tag_1',
        name: 'VIP',
        tenantId: 'default_tenant',
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Tag(
        id: 'tag_2',
        name: 'New',
        tenantId: 'default_tenant',
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      Tag(
        id: 'tag_3',
        name: 'Luxury',
        tenantId: 'default_tenant',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ]);
  }

  Future<List<Tag>> getTags() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tags.toList();
  }

  Future<Tag> createTag(String tagName) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newTag = Tag(
      id: 'tag_${DateTime.now().millisecondsSinceEpoch}',
      name: tagName,
      tenantId: 'default_tenant',
      createdAt: DateTime.now(),
    );
    _tags.add(newTag);
    return newTag;
  }

  Future<Tag> updateTag(String tagId, String tagName) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _tags.indexWhere((t) => t.id == tagId);
    if (index == -1) {
      throw Exception('Tag not found');
    }
    final updated = _tags[index].copyWith(
      name: tagName,
      updatedAt: DateTime.now(),
    );
    _tags[index] = updated;
    return updated;
  }

  Future<void> deleteTag(String tagId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tags.removeWhere((t) => t.id == tagId);
  }
}
