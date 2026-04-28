// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageListDtoImpl _$$MessageListDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessageListDtoImpl(
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      entities: MessageEntitiesDto.fromJson(
        json['entities'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$MessageListDtoImplToJson(
  _$MessageListDtoImpl instance,
) => <String, dynamic>{
  'messages': instance.messages,
  'entities': instance.entities,
};
