// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketInfoDtoImpl _$$TicketInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$TicketInfoDtoImpl(
      ticketId: json['ticketID'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$TicketInfoDtoImplToJson(_$TicketInfoDtoImpl instance) =>
    <String, dynamic>{
      'ticketID': instance.ticketId,
      'status': instance.status,
      'priority': instance.priority,
      'title': instance.title,
      'description': instance.description,
    };
