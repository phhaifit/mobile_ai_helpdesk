class MessengerPage {
  final String id;
  final String name;
  final String pageId;
  final bool connected;

  const MessengerPage({
    required this.id,
    required this.name,
    required this.pageId,
    required this.connected,
  });

  factory MessengerPage.fromJson(Map<String, dynamic> json) => MessengerPage(
        id: json['id'] as String,
        name: json['name'] as String,
        pageId: json['pageId'] as String,
        connected: json['connected'] as bool,
      );
}
