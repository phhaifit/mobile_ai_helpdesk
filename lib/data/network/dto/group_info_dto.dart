class GroupInfoDto {
  final String groupId;
  final int memberCount;
  final List<MemberInfoDto> members;

  GroupInfoDto({required this.groupId, required this.memberCount, required this.members});

  factory GroupInfoDto.fromJson(Map<String, dynamic> json) {
    return GroupInfoDto(
      groupId: (json['groupID'] ?? '').toString(),
      memberCount: (json['memberCount'] is num) ? (json['memberCount'] as num).toInt() : 0,
      members: (json['members'] is List) ? (json['members'] as List).whereType<Map<String, dynamic>>().map((m) => MemberInfoDto.fromJson(m)).toList() : [],
    );
  }
}

class MemberInfoDto {
    final String customerID;
    final String name;
    
    MemberInfoDto({required this.customerID, required this.name});

    factory MemberInfoDto.fromJson(Map<String, dynamic> json) {
      return MemberInfoDto(
        customerID: (json['customerID'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
      );
    }
  }