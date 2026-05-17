class JarvisMessageDto {
  final String userId;
  final String userRole;
  final String message;
  final List<String> history;
  final String? sessionId;
  final List<String> messageImages;

  const JarvisMessageDto({
    required this.userId,
    required this.userRole,
    required this.message,
    this.history = const [],
    this.sessionId,
    this.messageImages = const [],
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userRole': userRole,
        'message': message,
        if (history.isNotEmpty) 'history': history,
        if (sessionId != null) 'sessionId': sessionId,
        if (messageImages.isNotEmpty) 'messageImages': messageImages,
      };
}

class JarvisResponse {
  final String message;
  final String? sessionId;
  final bool requiresConfirmation;
  final String? proposalAction;

  const JarvisResponse({
    required this.message,
    this.sessionId,
    this.requiresConfirmation = false,
    this.proposalAction,
  });

  factory JarvisResponse.fromJson(Map<String, dynamic> json) => JarvisResponse(
        message: json['message'] as String? ?? '',
        sessionId: json['sessionId'] as String?,
        requiresConfirmation: json['requiresConfirmation'] as bool? ?? false,
        proposalAction: json['proposalAction'] as String?,
      );
}

enum HitlAction { approveOnce, approveAlways, deny }

class JarvisConfirmDto {
  final String userId;
  final String sessionId;
  final HitlAction action;
  final String? language;

  const JarvisConfirmDto({
    required this.userId,
    required this.sessionId,
    required this.action,
    this.language,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'sessionId': sessionId,
        'action': switch (action) {
          HitlAction.approveOnce => 'approve_once',
          HitlAction.approveAlways => 'approve_always',
          HitlAction.deny => 'deny',
        },
        if (language != null) 'language': language,
      };
}
