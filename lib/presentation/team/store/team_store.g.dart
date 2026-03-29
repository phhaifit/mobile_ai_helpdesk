// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamStore on _TeamStore, Store {
  late final _$teamMembersAtom = Atom(
    name: '_TeamStore.teamMembers',
    context: context,
  );

  @override
  ObservableList<TeamMember> get teamMembers {
    _$teamMembersAtom.reportRead();
    return super.teamMembers;
  }

  @override
  set teamMembers(ObservableList<TeamMember> value) {
    _$teamMembersAtom.reportWrite(value, super.teamMembers, () {
      super.teamMembers = value;
    });
  }

  late final _$invitationsAtom = Atom(
    name: '_TeamStore.invitations',
    context: context,
  );

  @override
  ObservableList<Invitation> get invitations {
    _$invitationsAtom.reportRead();
    return super.invitations;
  }

  @override
  set invitations(ObservableList<Invitation> value) {
    _$invitationsAtom.reportWrite(value, super.invitations, () {
      super.invitations = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TeamStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$loadTeamDataAsyncAction = AsyncAction(
    '_TeamStore.loadTeamData',
    context: context,
  );

  @override
  Future<void> loadTeamData() {
    return _$loadTeamDataAsyncAction.run(() => super.loadTeamData());
  }

  late final _$inviteMemberAsyncAction = AsyncAction(
    '_TeamStore.inviteMember',
    context: context,
  );

  @override
  Future<void> inviteMember({
    required String email,
    required TeamRole role,
    required String invitedByMemberId,
  }) {
    return _$inviteMemberAsyncAction.run(
      () => super.inviteMember(
        email: email,
        role: role,
        invitedByMemberId: invitedByMemberId,
      ),
    );
  }

  late final _$resendInvitationAsyncAction = AsyncAction(
    '_TeamStore.resendInvitation',
    context: context,
  );

  @override
  Future<void> resendInvitation(String invitationId) {
    return _$resendInvitationAsyncAction.run(
      () => super.resendInvitation(invitationId),
    );
  }

  late final _$acceptInvitationAsyncAction = AsyncAction(
    '_TeamStore.acceptInvitation',
    context: context,
  );

  @override
  Future<void> acceptInvitation(String invitationId) {
    return _$acceptInvitationAsyncAction.run(
      () => super.acceptInvitation(invitationId),
    );
  }

  late final _$declineInvitationAsyncAction = AsyncAction(
    '_TeamStore.declineInvitation',
    context: context,
  );

  @override
  Future<void> declineInvitation(String invitationId) {
    return _$declineInvitationAsyncAction.run(
      () => super.declineInvitation(invitationId),
    );
  }

  late final _$updateMemberProfileAsyncAction = AsyncAction(
    '_TeamStore.updateMemberProfile',
    context: context,
  );

  @override
  Future<bool> updateMemberProfile({
    required String memberId,
    required TeamRole role,
    String? displayName,
    String? phoneNumber,
  }) {
    return _$updateMemberProfileAsyncAction.run(
      () => super.updateMemberProfile(
        memberId: memberId,
        role: role,
        displayName: displayName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  late final _$removeMemberAsyncAction = AsyncAction(
    '_TeamStore.removeMember',
    context: context,
  );

  @override
  Future<bool> removeMember(String memberId) {
    return _$removeMemberAsyncAction.run(() => super.removeMember(memberId));
  }

  late final _$updatePermissionsAsyncAction = AsyncAction(
    '_TeamStore.updatePermissions',
    context: context,
  );

  @override
  Future<void> updatePermissions({
    required String memberId,
    required List<Permission> permissions,
  }) {
    return _$updatePermissionsAsyncAction.run(
      () =>
          super.updatePermissions(memberId: memberId, permissions: permissions),
    );
  }

  late final _$_TeamStoreActionController = ActionController(
    name: '_TeamStore',
    context: context,
  );

  @override
  void _clearTeamData() {
    final _$actionInfo = _$_TeamStoreActionController.startAction(
      name: '_TeamStore._clearTeamData',
    );
    try {
      return super._clearTeamData();
    } finally {
      _$_TeamStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
teamMembers: ${teamMembers},
invitations: ${invitations},
isLoading: ${isLoading}
    ''';
  }
}
