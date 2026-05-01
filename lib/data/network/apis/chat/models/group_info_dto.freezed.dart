// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupInfoDto _$GroupInfoDtoFromJson(Map<String, dynamic> json) {
  return _GroupInfoDto.fromJson(json);
}

/// @nodoc
mixin _$GroupInfoDto {
  @JsonKey(name: 'groupID')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'displayName')
  String get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar')
  String get avatar => throw _privateConstructorUsedError;
  List<MemberInfoDto> get members => throw _privateConstructorUsedError;

  /// Serializes this GroupInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupInfoDtoCopyWith<GroupInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupInfoDtoCopyWith<$Res> {
  factory $GroupInfoDtoCopyWith(
    GroupInfoDto value,
    $Res Function(GroupInfoDto) then,
  ) = _$GroupInfoDtoCopyWithImpl<$Res, GroupInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'groupID') String groupId,
    @JsonKey(name: 'displayName') String displayName,
    @JsonKey(name: 'avatar') String avatar,
    List<MemberInfoDto> members,
  });
}

/// @nodoc
class _$GroupInfoDtoCopyWithImpl<$Res, $Val extends GroupInfoDto>
    implements $GroupInfoDtoCopyWith<$Res> {
  _$GroupInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? displayName = null,
    Object? avatar = null,
    Object? members = null,
  }) {
    return _then(
      _value.copyWith(
            groupId:
                null == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String,
            displayName:
                null == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String,
            avatar:
                null == avatar
                    ? _value.avatar
                    : avatar // ignore: cast_nullable_to_non_nullable
                        as String,
            members:
                null == members
                    ? _value.members
                    : members // ignore: cast_nullable_to_non_nullable
                        as List<MemberInfoDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupInfoDtoImplCopyWith<$Res>
    implements $GroupInfoDtoCopyWith<$Res> {
  factory _$$GroupInfoDtoImplCopyWith(
    _$GroupInfoDtoImpl value,
    $Res Function(_$GroupInfoDtoImpl) then,
  ) = __$$GroupInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'groupID') String groupId,
    @JsonKey(name: 'displayName') String displayName,
    @JsonKey(name: 'avatar') String avatar,
    List<MemberInfoDto> members,
  });
}

/// @nodoc
class __$$GroupInfoDtoImplCopyWithImpl<$Res>
    extends _$GroupInfoDtoCopyWithImpl<$Res, _$GroupInfoDtoImpl>
    implements _$$GroupInfoDtoImplCopyWith<$Res> {
  __$$GroupInfoDtoImplCopyWithImpl(
    _$GroupInfoDtoImpl _value,
    $Res Function(_$GroupInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? displayName = null,
    Object? avatar = null,
    Object? members = null,
  }) {
    return _then(
      _$GroupInfoDtoImpl(
        groupId:
            null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String,
        displayName:
            null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String,
        avatar:
            null == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                    as String,
        members:
            null == members
                ? _value._members
                : members // ignore: cast_nullable_to_non_nullable
                    as List<MemberInfoDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupInfoDtoImpl implements _GroupInfoDto {
  const _$GroupInfoDtoImpl({
    @JsonKey(name: 'groupID') this.groupId = '',
    @JsonKey(name: 'displayName') this.displayName = '',
    @JsonKey(name: 'avatar') this.avatar = '',
    final List<MemberInfoDto> members = const [],
  }) : _members = members;

  factory _$GroupInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'groupID')
  final String groupId;
  @override
  @JsonKey(name: 'displayName')
  final String displayName;
  @override
  @JsonKey(name: 'avatar')
  final String avatar;
  final List<MemberInfoDto> _members;
  @override
  @JsonKey()
  List<MemberInfoDto> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'GroupInfoDto(groupId: $groupId, displayName: $displayName, avatar: $avatar, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupInfoDtoImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    displayName,
    avatar,
    const DeepCollectionEquality().hash(_members),
  );

  /// Create a copy of GroupInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupInfoDtoImplCopyWith<_$GroupInfoDtoImpl> get copyWith =>
      __$$GroupInfoDtoImplCopyWithImpl<_$GroupInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupInfoDtoImplToJson(this);
  }
}

abstract class _GroupInfoDto implements GroupInfoDto {
  const factory _GroupInfoDto({
    @JsonKey(name: 'groupID') final String groupId,
    @JsonKey(name: 'displayName') final String displayName,
    @JsonKey(name: 'avatar') final String avatar,
    final List<MemberInfoDto> members,
  }) = _$GroupInfoDtoImpl;

  factory _GroupInfoDto.fromJson(Map<String, dynamic> json) =
      _$GroupInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'groupID')
  String get groupId;
  @override
  @JsonKey(name: 'displayName')
  String get displayName;
  @override
  @JsonKey(name: 'avatar')
  String get avatar;
  @override
  List<MemberInfoDto> get members;

  /// Create a copy of GroupInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupInfoDtoImplCopyWith<_$GroupInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberInfoDto _$MemberInfoDtoFromJson(Map<String, dynamic> json) {
  return _MemberInfoDto.fromJson(json);
}

/// @nodoc
mixin _$MemberInfoDto {
  @JsonKey(name: 'groupID')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'customerID')
  String get customerId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer')
  List<GroupCustomerInfoDto> get groupCustomerInfo =>
      throw _privateConstructorUsedError;

  /// Serializes this MemberInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberInfoDtoCopyWith<MemberInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberInfoDtoCopyWith<$Res> {
  factory $MemberInfoDtoCopyWith(
    MemberInfoDto value,
    $Res Function(MemberInfoDto) then,
  ) = _$MemberInfoDtoCopyWithImpl<$Res, MemberInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'groupID') String groupId,
    @JsonKey(name: 'customerID') String customerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @JsonKey(name: 'customer') List<GroupCustomerInfoDto> groupCustomerInfo,
  });
}

/// @nodoc
class _$MemberInfoDtoCopyWithImpl<$Res, $Val extends MemberInfoDto>
    implements $MemberInfoDtoCopyWith<$Res> {
  _$MemberInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? customerId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? groupCustomerInfo = null,
  }) {
    return _then(
      _value.copyWith(
            groupId:
                null == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String,
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            deletedAt:
                freezed == deletedAt
                    ? _value.deletedAt
                    : deletedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            groupCustomerInfo:
                null == groupCustomerInfo
                    ? _value.groupCustomerInfo
                    : groupCustomerInfo // ignore: cast_nullable_to_non_nullable
                        as List<GroupCustomerInfoDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemberInfoDtoImplCopyWith<$Res>
    implements $MemberInfoDtoCopyWith<$Res> {
  factory _$$MemberInfoDtoImplCopyWith(
    _$MemberInfoDtoImpl value,
    $Res Function(_$MemberInfoDtoImpl) then,
  ) = __$$MemberInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'groupID') String groupId,
    @JsonKey(name: 'customerID') String customerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @JsonKey(name: 'customer') List<GroupCustomerInfoDto> groupCustomerInfo,
  });
}

/// @nodoc
class __$$MemberInfoDtoImplCopyWithImpl<$Res>
    extends _$MemberInfoDtoCopyWithImpl<$Res, _$MemberInfoDtoImpl>
    implements _$$MemberInfoDtoImplCopyWith<$Res> {
  __$$MemberInfoDtoImplCopyWithImpl(
    _$MemberInfoDtoImpl _value,
    $Res Function(_$MemberInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? customerId = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? groupCustomerInfo = null,
  }) {
    return _then(
      _$MemberInfoDtoImpl(
        groupId:
            null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String,
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        deletedAt:
            freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        groupCustomerInfo:
            null == groupCustomerInfo
                ? _value._groupCustomerInfo
                : groupCustomerInfo // ignore: cast_nullable_to_non_nullable
                    as List<GroupCustomerInfoDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberInfoDtoImpl implements _MemberInfoDto {
  const _$MemberInfoDtoImpl({
    @JsonKey(name: 'groupID') this.groupId = '',
    @JsonKey(name: 'customerID') this.customerId = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    @JsonKey(name: 'customer')
    final List<GroupCustomerInfoDto> groupCustomerInfo = const [],
  }) : _groupCustomerInfo = groupCustomerInfo;

  factory _$MemberInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'groupID')
  final String groupId;
  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  final List<GroupCustomerInfoDto> _groupCustomerInfo;
  @override
  @JsonKey(name: 'customer')
  List<GroupCustomerInfoDto> get groupCustomerInfo {
    if (_groupCustomerInfo is EqualUnmodifiableListView)
      return _groupCustomerInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupCustomerInfo);
  }

  @override
  String toString() {
    return 'MemberInfoDto(groupId: $groupId, customerId: $customerId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, groupCustomerInfo: $groupCustomerInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberInfoDtoImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(
              other._groupCustomerInfo,
              _groupCustomerInfo,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    customerId,
    createdAt,
    updatedAt,
    deletedAt,
    const DeepCollectionEquality().hash(_groupCustomerInfo),
  );

  /// Create a copy of MemberInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberInfoDtoImplCopyWith<_$MemberInfoDtoImpl> get copyWith =>
      __$$MemberInfoDtoImplCopyWithImpl<_$MemberInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberInfoDtoImplToJson(this);
  }
}

abstract class _MemberInfoDto implements MemberInfoDto {
  const factory _MemberInfoDto({
    @JsonKey(name: 'groupID') final String groupId,
    @JsonKey(name: 'customerID') final String customerId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
    @JsonKey(name: 'customer')
    final List<GroupCustomerInfoDto> groupCustomerInfo,
  }) = _$MemberInfoDtoImpl;

  factory _MemberInfoDto.fromJson(Map<String, dynamic> json) =
      _$MemberInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'groupID')
  String get groupId;
  @override
  @JsonKey(name: 'customerID')
  String get customerId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'customer')
  List<GroupCustomerInfoDto> get groupCustomerInfo;

  /// Create a copy of MemberInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberInfoDtoImplCopyWith<_$MemberInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupCustomerInfoDto _$GroupCustomerInfoDtoFromJson(Map<String, dynamic> json) {
  return _GroupCustomerInfoDto.fromJson(json);
}

/// @nodoc
mixin _$GroupCustomerInfoDto {
  @JsonKey(name: 'customerID')
  String get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Serializes this GroupCustomerInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupCustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCustomerInfoDtoCopyWith<GroupCustomerInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCustomerInfoDtoCopyWith<$Res> {
  factory $GroupCustomerInfoDtoCopyWith(
    GroupCustomerInfoDto value,
    $Res Function(GroupCustomerInfoDto) then,
  ) = _$GroupCustomerInfoDtoCopyWithImpl<$Res, GroupCustomerInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'name') String name,
  });
}

/// @nodoc
class _$GroupCustomerInfoDtoCopyWithImpl<
  $Res,
  $Val extends GroupCustomerInfoDto
>
    implements $GroupCustomerInfoDtoCopyWith<$Res> {
  _$GroupCustomerInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupCustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerId = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            customerId:
                null == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupCustomerInfoDtoImplCopyWith<$Res>
    implements $GroupCustomerInfoDtoCopyWith<$Res> {
  factory _$$GroupCustomerInfoDtoImplCopyWith(
    _$GroupCustomerInfoDtoImpl value,
    $Res Function(_$GroupCustomerInfoDtoImpl) then,
  ) = __$$GroupCustomerInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'customerID') String customerId,
    @JsonKey(name: 'name') String name,
  });
}

/// @nodoc
class __$$GroupCustomerInfoDtoImplCopyWithImpl<$Res>
    extends _$GroupCustomerInfoDtoCopyWithImpl<$Res, _$GroupCustomerInfoDtoImpl>
    implements _$$GroupCustomerInfoDtoImplCopyWith<$Res> {
  __$$GroupCustomerInfoDtoImplCopyWithImpl(
    _$GroupCustomerInfoDtoImpl _value,
    $Res Function(_$GroupCustomerInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupCustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerId = null, Object? name = null}) {
    return _then(
      _$GroupCustomerInfoDtoImpl(
        customerId:
            null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupCustomerInfoDtoImpl implements _GroupCustomerInfoDto {
  const _$GroupCustomerInfoDtoImpl({
    @JsonKey(name: 'customerID') this.customerId = '',
    @JsonKey(name: 'name') this.name = '',
  });

  factory _$GroupCustomerInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupCustomerInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'customerID')
  final String customerId;
  @override
  @JsonKey(name: 'name')
  final String name;

  @override
  String toString() {
    return 'GroupCustomerInfoDto(customerId: $customerId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupCustomerInfoDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customerId, name);

  /// Create a copy of GroupCustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupCustomerInfoDtoImplCopyWith<_$GroupCustomerInfoDtoImpl>
  get copyWith =>
      __$$GroupCustomerInfoDtoImplCopyWithImpl<_$GroupCustomerInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupCustomerInfoDtoImplToJson(this);
  }
}

abstract class _GroupCustomerInfoDto implements GroupCustomerInfoDto {
  const factory _GroupCustomerInfoDto({
    @JsonKey(name: 'customerID') final String customerId,
    @JsonKey(name: 'name') final String name,
  }) = _$GroupCustomerInfoDtoImpl;

  factory _GroupCustomerInfoDto.fromJson(Map<String, dynamic> json) =
      _$GroupCustomerInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'customerID')
  String get customerId;
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Create a copy of GroupCustomerInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupCustomerInfoDtoImplCopyWith<_$GroupCustomerInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
