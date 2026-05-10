// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_info_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChannelInfoDto _$ChannelInfoDtoFromJson(Map<String, dynamic> json) {
  return _ChannelInfoDto.fromJson(json);
}

/// @nodoc
mixin _$ChannelInfoDto {
  @JsonKey(name: 'appID')
  String get appId => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelID')
  String get channelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'config')
  Map<String, dynamic> get config => throw _privateConstructorUsedError;
  @JsonKey(name: 'appInfo')
  Map<String, dynamic> get appInfo => throw _privateConstructorUsedError;

  /// Serializes this ChannelInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChannelInfoDtoCopyWith<ChannelInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelInfoDtoCopyWith<$Res> {
  factory $ChannelInfoDtoCopyWith(
    ChannelInfoDto value,
    $Res Function(ChannelInfoDto) then,
  ) = _$ChannelInfoDtoCopyWithImpl<$Res, ChannelInfoDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'appID') String appId,
    @JsonKey(name: 'channelID') String channelId,
    @JsonKey(name: 'name') String name,
    @JsonKey(name: 'config') Map<String, dynamic> config,
    @JsonKey(name: 'appInfo') Map<String, dynamic> appInfo,
  });
}

/// @nodoc
class _$ChannelInfoDtoCopyWithImpl<$Res, $Val extends ChannelInfoDto>
    implements $ChannelInfoDtoCopyWith<$Res> {
  _$ChannelInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? channelId = null,
    Object? name = null,
    Object? config = null,
    Object? appInfo = null,
  }) {
    return _then(
      _value.copyWith(
            appId:
                null == appId
                    ? _value.appId
                    : appId // ignore: cast_nullable_to_non_nullable
                        as String,
            channelId:
                null == channelId
                    ? _value.channelId
                    : channelId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            config:
                null == config
                    ? _value.config
                    : config // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
            appInfo:
                null == appInfo
                    ? _value.appInfo
                    : appInfo // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChannelInfoDtoImplCopyWith<$Res>
    implements $ChannelInfoDtoCopyWith<$Res> {
  factory _$$ChannelInfoDtoImplCopyWith(
    _$ChannelInfoDtoImpl value,
    $Res Function(_$ChannelInfoDtoImpl) then,
  ) = __$$ChannelInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'appID') String appId,
    @JsonKey(name: 'channelID') String channelId,
    @JsonKey(name: 'name') String name,
    @JsonKey(name: 'config') Map<String, dynamic> config,
    @JsonKey(name: 'appInfo') Map<String, dynamic> appInfo,
  });
}

/// @nodoc
class __$$ChannelInfoDtoImplCopyWithImpl<$Res>
    extends _$ChannelInfoDtoCopyWithImpl<$Res, _$ChannelInfoDtoImpl>
    implements _$$ChannelInfoDtoImplCopyWith<$Res> {
  __$$ChannelInfoDtoImplCopyWithImpl(
    _$ChannelInfoDtoImpl _value,
    $Res Function(_$ChannelInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? channelId = null,
    Object? name = null,
    Object? config = null,
    Object? appInfo = null,
  }) {
    return _then(
      _$ChannelInfoDtoImpl(
        appId:
            null == appId
                ? _value.appId
                : appId // ignore: cast_nullable_to_non_nullable
                    as String,
        channelId:
            null == channelId
                ? _value.channelId
                : channelId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        config:
            null == config
                ? _value._config
                : config // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
        appInfo:
            null == appInfo
                ? _value._appInfo
                : appInfo // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelInfoDtoImpl implements _ChannelInfoDto {
  const _$ChannelInfoDtoImpl({
    @JsonKey(name: 'appID') required this.appId,
    @JsonKey(name: 'channelID') required this.channelId,
    @JsonKey(name: 'name') required this.name,
    @JsonKey(name: 'config') required final Map<String, dynamic> config,
    @JsonKey(name: 'appInfo') required final Map<String, dynamic> appInfo,
  }) : _config = config,
       _appInfo = appInfo;

  factory _$ChannelInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelInfoDtoImplFromJson(json);

  @override
  @JsonKey(name: 'appID')
  final String appId;
  @override
  @JsonKey(name: 'channelID')
  final String channelId;
  @override
  @JsonKey(name: 'name')
  final String name;
  final Map<String, dynamic> _config;
  @override
  @JsonKey(name: 'config')
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  final Map<String, dynamic> _appInfo;
  @override
  @JsonKey(name: 'appInfo')
  Map<String, dynamic> get appInfo {
    if (_appInfo is EqualUnmodifiableMapView) return _appInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_appInfo);
  }

  @override
  String toString() {
    return 'ChannelInfoDto(appId: $appId, channelId: $channelId, name: $name, config: $config, appInfo: $appInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelInfoDtoImpl &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            const DeepCollectionEquality().equals(other._appInfo, _appInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    appId,
    channelId,
    name,
    const DeepCollectionEquality().hash(_config),
    const DeepCollectionEquality().hash(_appInfo),
  );

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelInfoDtoImplCopyWith<_$ChannelInfoDtoImpl> get copyWith =>
      __$$ChannelInfoDtoImplCopyWithImpl<_$ChannelInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelInfoDtoImplToJson(this);
  }
}

abstract class _ChannelInfoDto implements ChannelInfoDto {
  const factory _ChannelInfoDto({
    @JsonKey(name: 'appID') required final String appId,
    @JsonKey(name: 'channelID') required final String channelId,
    @JsonKey(name: 'name') required final String name,
    @JsonKey(name: 'config') required final Map<String, dynamic> config,
    @JsonKey(name: 'appInfo') required final Map<String, dynamic> appInfo,
  }) = _$ChannelInfoDtoImpl;

  factory _ChannelInfoDto.fromJson(Map<String, dynamic> json) =
      _$ChannelInfoDtoImpl.fromJson;

  @override
  @JsonKey(name: 'appID')
  String get appId;
  @override
  @JsonKey(name: 'channelID')
  String get channelId;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'config')
  Map<String, dynamic> get config;
  @override
  @JsonKey(name: 'appInfo')
  Map<String, dynamic> get appInfo;

  /// Create a copy of ChannelInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChannelInfoDtoImplCopyWith<_$ChannelInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
