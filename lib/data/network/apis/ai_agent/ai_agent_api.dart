import 'package:ai_helpdesk/core/data/network/dio/dio_client.dart';
import 'package:ai_helpdesk/data/network/constants/endpoints.dart';
import 'package:ai_helpdesk/domain/entity/ai_agent/ai_agent.dart';

/// Low-level HTTP client for AI-Services AI Agent endpoints.
///
/// Backed by `aiServiceApi` Dio instance (different host from Helpdesk).
/// Returns domain entities directly — BE schema for ai-agents is not fully
/// documented, so [_fromJson] is defensive: only `id` + `name` are treated as
/// load-bearing; missing fields fall back to safe defaults.
class AiAgentApi {
  final DioClient _dioClient;

  AiAgentApi(this._dioClient);

  Future<List<AiAgent>> getAgentsByTenant(String tenantId) async {
    final res = await _dioClient.dio.get(Endpoints.aiAgentByTenant(tenantId));
    final List<dynamic> rawList = _extractMapList(_unwrapApiPayload(res.data));

    return rawList
        .whereType<Map<Object?, Object?>>()
        .map((item) => _fromJson(Map<String, dynamic>.from(item)))
        .where((AiAgent a) => a.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<AiAgent?> getAgentById(String agentId) async {
    final res = await _dioClient.dio.get(Endpoints.aiAgentById(agentId));
    final dynamic payload = _unwrapApiPayload(res.data);
    if (payload is! Map) {
      return null;
    }
    final agent = _fromJson(Map<String, dynamic>.from(payload));
    return agent.id.isEmpty ? null : agent;
  }
}

AiAgent _fromJson(Map<String, dynamic> json) {
  return AiAgent(
    id: _readString(json, const ['id', '_id']),
    name: _readString(json, const ['name', 'title']),
    description: _readString(json, const ['description', 'desc']),
    avatarUrl: _readNullableString(json, const ['avatarUrl', 'avatar_url', 'avatar']),
    mode: _readMode(json),
    platforms: _readStringList(json, const ['platforms', 'channels']),
    workflows: _readStringList(json, const ['workflows', 'flows']),
    teamId: _readNullableString(json, const ['teamId', 'team_id']),
    createdAt: _readDateTime(json, const ['createdAt', 'created_at']) ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}

dynamic _unwrapApiPayload(dynamic data) {
  if (data is List) {
    return data;
  }
  if (data is! Map) {
    return data;
  }
  final map = Map<String, dynamic>.from(data);
  return map['data'] ?? map['result'] ?? map['payload'] ?? map;
}

List<dynamic> _extractMapList(dynamic data) {
  if (data is List) {
    return data;
  }
  if (data is! Map) {
    return const <dynamic>[];
  }
  final map = Map<String, dynamic>.from(data);
  final items = map['agents'] ?? map['items'] ?? map['results'] ?? map['data'];
  return items is List ? items : const <dynamic>[];
}

String _readString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final v = map[key];
    if (v == null) continue;
    final s = v.toString().trim();
    if (s.isNotEmpty) return s;
  }
  return '';
}

String? _readNullableString(Map<String, dynamic> map, List<String> keys) {
  final s = _readString(map, keys);
  return s.isEmpty ? null : s;
}

List<String> _readStringList(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final v = map[key];
    if (v is List) {
      return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
  }
  return const <String>[];
}

AgentMode _readMode(Map<String, dynamic> map) {
  final raw = _readString(map, const ['mode']).toLowerCase();
  switch (raw) {
    case 'auto':
      return AgentMode.auto;
    case 'semiauto':
    case 'semi_auto':
    case 'semi-auto':
      return AgentMode.semiAuto;
    default:
      return AgentMode.auto;
  }
}

DateTime? _readDateTime(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final raw = map[key];
    if (raw is int && raw > 0) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
    }
  }
  return null;
}