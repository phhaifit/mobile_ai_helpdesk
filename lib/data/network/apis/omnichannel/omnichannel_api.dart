import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/omnichannel/omnichannel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'omnichannel_api.g.dart';

class MessengerPageDto {
  final String id;
  final String channelId;
  final String name;
  final String pageId;
  final bool connected;
  final bool? autoReply;
  final String? businessHours;
  final DateTime? lastSyncAt;

  const MessengerPageDto({
    required this.id,
    required this.channelId,
    required this.name,
    required this.pageId,
    required this.connected,
    this.autoReply,
    this.businessHours,
    this.lastSyncAt,
  });

  factory MessengerPageDto.fromJson(Map<String, dynamic> json) {
    final String id = _readString(json, const <String>['id']);
    final String channelId = _readString(json, const <String>[
      'channelId',
      'channel_id',
      'id',
    ]);
    final String pageId = _readString(json, const <String>[
      'pageId',
      'page_id',
      'id',
    ]);
    final String rawBusinessHours = _readString(json, const <String>[
      'businessHours',
      'business_hours',
      'greeting',
    ]);

    return MessengerPageDto(
      id: id,
      channelId: channelId,
      name: _readString(json, const <String>['name', 'pageName', 'page_name']),
      pageId: pageId,
      connected: _readBool(json, const <String>[
        'connected',
        'isConnected',
        'is_connected',
      ]),
      autoReply: _readNullableBool(json, const <String>[
        'autoReply',
        'auto_reply',
      ]),
      businessHours: rawBusinessHours.isEmpty ? null : rawBusinessHours,
      lastSyncAt: _readDateTime(json, const <String>[
        'lastSyncAt',
        'last_sync_at',
        'updatedAt',
        'updated_at',
      ]),
    );
  }
}

@JsonSerializable()
class ZaloQrDto {
  final String code;
  final String qrUrl;

  const ZaloQrDto({
    required this.code,
    required this.qrUrl,
  });

  factory ZaloQrDto.fromJson(Map<String, dynamic> json) => _$ZaloQrDtoFromJson(json);

  ZaloQr toEntity() => ZaloQr(
    code: code,
    url: qrUrl,
  );
}

@JsonSerializable()
class ZaloQrStatusDto {
  final String status;
  final String? authCode;

  const ZaloQrStatusDto({
    required this.status,
    this.authCode,
  });

  factory ZaloQrStatusDto.fromJson(Map<String, dynamic> json) => _$ZaloQrStatusDtoFromJson(json);

  ZaloQrStatusUpdate toEntity() {
    ZaloQrStatus domainStatus;
    switch (status) {
      case 'scanned':
        domainStatus = ZaloQrStatus.scanned;
        break;
      case 'confirmed':
        domainStatus = ZaloQrStatus.confirmed;
        break;
      case 'expired':
        domainStatus = ZaloQrStatus.expired;
        break;
      case 'pending':
      default:
        domainStatus = ZaloQrStatus.pending;
        break;
    }
    return ZaloQrStatusUpdate(status: domainStatus, authCode: authCode);
  }
}

class OmnichannelApi {
  final DioClient _dioClient;

  OmnichannelApi(this._dioClient);

  Future<List<MessengerPageDto>> getMessengerPages() async {
    final res = await _dioClient.dio.get(Endpoints.messengerPages());
    final List<dynamic> rawPages = _extractMapList(_unwrapApiPayload(res.data));

    return rawPages
        .whereType<Map<Object?, Object?>>()
        .map(
          (Map<Object?, Object?> item) =>
              MessengerPageDto.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  Future<dynamic> verifyMessengerAuthCode(String code) {
    return _dioClient.dio.post(
      Endpoints.verifyMessengerAuthCode(),
      data: <String, dynamic>{'code': code},
    );
  }

  Future<dynamic> deleteMessengerPage(String channelId) {
    return _dioClient.dio.delete(Endpoints.deleteMessengerPage(channelId));
  }

  Future<dynamic> resyncMessengerPage(String channelId) {
    return _dioClient.dio.post(
      Endpoints.resyncMessengerPage(),
      data: <String, dynamic>{'channelId': channelId},
    );
  }

  Future<dynamic> updateMessengerPageConfig({
    required String channelId,
    required bool autoReply,
    String? greeting,
  }) {
    return _dioClient.dio.post(
      Endpoints.updateMessengerPageConfig(),
      data: <String, dynamic>{
        'channelId': channelId,
        'autoReply': autoReply,
        if (greeting != null) 'greeting': greeting,
      },
    );
  }

  Future<dynamic> getMessengerCustomers({int offset = 0, int limit = 20}) {
    return _dioClient.dio.get(
      Endpoints.messengerCustomers(),
      queryParameters: <String, dynamic>{'offset': offset, 'limit': limit},
    );
  }

  Future<ZaloQrDto> generateZaloQr() async {
    final res = await _dioClient.dio.get(Endpoints.zaloGenerateQr());
    return ZaloQrDto.fromJson(
      Map<String, dynamic>.from(_unwrapApiPayload(res.data) as Map),
    );
  }

  Future<ZaloQrStatusDto> getZaloQrStatus(String code) async {
    final response = await _dioClient.dio.get(
      Endpoints.zaloQrStatus(code).replaceFirst('{code}', code),
    );
    return ZaloQrStatusDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<dynamic> verifyZaloAuthCode(String code) {
    return _dioClient.dio.post(
      Endpoints.verifyZaloAuthCode(),
      data: <String, dynamic>{'code': code},
    );
  }

  Future<dynamic> connectZalo(String authCode) {
    return _dioClient.dio.post(
      Endpoints.zaloConnect(),
      data: <String, dynamic>{'authCode': authCode},
    );
  }

  Future<dynamic> deleteZalo() {
    return _dioClient.dio.delete(Endpoints.zaloDisconnect());
  }
}

dynamic _unwrapApiPayload(dynamic data) {
  if (data is List) {
    return data;
  }

  if (data is! Map) {
    return data;
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(data);
  final dynamic wrapped = map['data'] ?? map['result'] ?? map['payload'] ?? map;
  return wrapped;
}

List<dynamic> _extractMapList(dynamic data) {
  if (data is List) {
    return data;
  }

  if (data is! Map) {
    return const <dynamic>[];
  }

  final Map<String, dynamic> map = Map<String, dynamic>.from(data);
  final dynamic pages =
      map['pages'] ??
      map['items'] ??
      map['results'] ??
      map['channels'] ??
      map['data'];

  if (pages is List) {
    return pages;
  }

  return const <dynamic>[];
}

String _readString(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic value = map[key];
    if (value == null) {
      continue;
    }
    final String normalized = value.toString().trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return '';
}

bool _readBool(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final String normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
  }
  return false;
}

bool? _readNullableBool(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    if (!map.containsKey(key)) {
      continue;
    }

    final dynamic value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final String normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }
  }

  return null;
}

DateTime? _readDateTime(Map<String, dynamic> map, List<String> keys) {
  for (final String key in keys) {
    final dynamic raw = map[key];
    if (raw == null) {
      continue;
    }

    if (raw is int) {
      if (raw <= 0) {
        continue;
      }
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }

    if (raw is String) {
      final DateTime? parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}
