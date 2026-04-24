import 'dart:convert';

class DraftResponseSseEvent {
  final String event;
  final String data;

  DraftResponseSseEvent({required this.event, required this.data});

  static DraftResponseSseEvent? parse(String raw) {
    String? event;
    final dataLines = <String>[];

    for (final line in const LineSplitter().convert(raw)) {
      if (line.startsWith('event:')) {
        event = line.substring('event:'.length).trim();
      } else if (line.startsWith('data:')) {
        dataLines.add(line.substring('data:'.length).trim());
      }
    }

    final evt = event ?? '';
    final data = dataLines.join('\n');
    if (evt.isEmpty && data.isEmpty) return null;
    return DraftResponseSseEvent(event: evt, data: data);
  }

  Map<String, dynamic>? get dataJson {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
      return null;
    } catch (_) {
      return null;
    }
  }
}