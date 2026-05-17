// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_attachment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FileAttachmentDto _$FileAttachmentDtoFromJson(Map<String, dynamic> json) {
  return _FileAttachmentDto.fromJson(json);
}

/// @nodoc
mixin _$FileAttachmentDto {
  String get url => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this FileAttachmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileAttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileAttachmentDtoCopyWith<FileAttachmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileAttachmentDtoCopyWith<$Res> {
  factory $FileAttachmentDtoCopyWith(
    FileAttachmentDto value,
    $Res Function(FileAttachmentDto) then,
  ) = _$FileAttachmentDtoCopyWithImpl<$Res, FileAttachmentDto>;
  @useResult
  $Res call({String url, String type, String name});
}

/// @nodoc
class _$FileAttachmentDtoCopyWithImpl<$Res, $Val extends FileAttachmentDto>
    implements $FileAttachmentDtoCopyWith<$Res> {
  _$FileAttachmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileAttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? type = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            url:
                null == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FileAttachmentDtoImplCopyWith<$Res>
    implements $FileAttachmentDtoCopyWith<$Res> {
  factory _$$FileAttachmentDtoImplCopyWith(
    _$FileAttachmentDtoImpl value,
    $Res Function(_$FileAttachmentDtoImpl) then,
  ) = __$$FileAttachmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String type, String name});
}

/// @nodoc
class __$$FileAttachmentDtoImplCopyWithImpl<$Res>
    extends _$FileAttachmentDtoCopyWithImpl<$Res, _$FileAttachmentDtoImpl>
    implements _$$FileAttachmentDtoImplCopyWith<$Res> {
  __$$FileAttachmentDtoImplCopyWithImpl(
    _$FileAttachmentDtoImpl _value,
    $Res Function(_$FileAttachmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileAttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? type = null, Object? name = null}) {
    return _then(
      _$FileAttachmentDtoImpl(
        url:
            null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
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
class _$FileAttachmentDtoImpl implements _FileAttachmentDto {
  const _$FileAttachmentDtoImpl({
    this.url = '',
    this.type = '',
    this.name = '',
  });

  factory _$FileAttachmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileAttachmentDtoImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'FileAttachmentDto(url: $url, type: $type, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileAttachmentDtoImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, type, name);

  /// Create a copy of FileAttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileAttachmentDtoImplCopyWith<_$FileAttachmentDtoImpl> get copyWith =>
      __$$FileAttachmentDtoImplCopyWithImpl<_$FileAttachmentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FileAttachmentDtoImplToJson(this);
  }
}

abstract class _FileAttachmentDto implements FileAttachmentDto {
  const factory _FileAttachmentDto({
    final String url,
    final String type,
    final String name,
  }) = _$FileAttachmentDtoImpl;

  factory _FileAttachmentDto.fromJson(Map<String, dynamic> json) =
      _$FileAttachmentDtoImpl.fromJson;

  @override
  String get url;
  @override
  String get type;
  @override
  String get name;

  /// Create a copy of FileAttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileAttachmentDtoImplCopyWith<_$FileAttachmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
