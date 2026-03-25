import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../domain/analytics/analytics_service.dart';

/// Firebase implementation of AnalyticsService.
///
/// Wraps Firebase Analytics SDK and enforces:
/// - PII filtering (no email, phone, personal data)
/// - Parameter validation (length limits, character restrictions)
/// - Debug mode support for development
class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics;
  final bool _debugMode;

  /// Maximum length for parameter values
  static const int _maxParameterLength = 100;

  /// Sensitive words that indicate PII (used for validation)
  static const List<String> _piiIndicators = [
    'email',
    'phone',
    'password',
    'ssn',
    'credit',
    'card',
    'address',
    'name',
  ];

  FirebaseAnalyticsServiceImpl({
    FirebaseAnalytics? firebaseAnalytics,
    bool debugMode = false,
  }) : _firebaseAnalytics = firebaseAnalytics ?? FirebaseAnalytics.instance,
       _debugMode = debugMode;

  @override
  Future<void> trackAppOpen({
    required String installSource,
    Map<String, String>? utmParams,
    String? sessionId,
  }) async {
    try {
      final params = <String, String>{
        'install_source': _sanitizeParameter('install_source', installSource),
        if (sessionId != null)
          'session_id': _sanitizeParameter('session_id', sessionId),
      };

      // Add UTM parameters if available
      if (utmParams != null) {
        utmParams.forEach((key, value) {
          if (key.startsWith('utm_')) {
            params[key] = _sanitizeParameter(key, value);
          }
        });
      }

      await _firebaseAnalytics.logAppOpen();

      if (_debugMode) {
        debugPrint('[Analytics] App Open - Install Source: $installSource');
      }
    } catch (e) {
      debugPrint('[Analytics Error] Failed to track app open: $e');
    }
  }

  @override
  Future<void> trackEvent(
    String eventName, {
    Map<String, String>? parameters,
  }) async {
    try {
      // Validate event name
      if (eventName.isEmpty) {
        debugPrint('[Analytics Error] Event name cannot be empty');
        return;
      }

      // Sanitize parameters and filter PII
      final sanitizedParams = <String, String>{};
      if (parameters != null) {
        parameters.forEach((key, value) {
          // Check for PII patterns
          if (_containsPII(key, value)) {
            debugPrint('[Analytics Warning] Skipping PII parameter: $key');
            return;
          }
          sanitizedParams[key] = _sanitizeParameter(key, value);
        });
      }

      await _firebaseAnalytics.logEvent(
        name: eventName,
        parameters: sanitizedParams,
      );

      if (_debugMode) {
        debugPrint('[Analytics] Event: $eventName - Params: $sanitizedParams');
      }
    } catch (e) {
      debugPrint('[Analytics Error] Failed to track event "$eventName": $e');
    }
  }

  @override
  Future<void> trackScreenView(
    String screenName, {
    String? screenClass,
    Map<String, String>? utmParams,
  }) async {
    try {
      final params = <String, Object>{
        'screen_name': screenName,
        'screen_class': ?screenClass,
      };

      // Add UTM parameters as strings (Firebase expects Object types)
      if (utmParams != null) {
        utmParams.forEach((key, value) {
          if (key.startsWith('utm_')) {
            params[key] = _sanitizeParameter(key, value);
          }
        });
      }

      await _firebaseAnalytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
        parameters: params,
      );

      if (_debugMode) {
        debugPrint('[Analytics] Screen View: $screenName');
      }
    } catch (e) {
      debugPrint(
        '[Analytics Error] Failed to track screen view "$screenName": $e',
      );
    }
  }

  @override
  Future<void> setUserProperties(
    String userId, {
    required Map<String, String> userProperties,
  }) async {
    try {
      // Filter and sanitize user properties
      final sanitizedProperties = <String, String>{};
      userProperties.forEach((key, value) {
        if (_containsPII(key, value)) {
          debugPrint('[Analytics Warning] Skipping PII user property: $key');
          return;
        }
        sanitizedProperties[key] = _sanitizeParameter(key, value);
      });

      // Note: User ID tracking is handled by Firebase anonymous user ID
      // Additional custom user properties can be set below:

      // Set user properties
      for (final entry in sanitizedProperties.entries) {
        await _firebaseAnalytics.setUserProperty(
          name: entry.key,
          value: entry.value,
        );
      }

      if (_debugMode) {
        debugPrint(
          '[Analytics] User Properties Set: ${sanitizedProperties.keys.join(', ')}',
        );
      }
    } catch (e) {
      debugPrint('[Analytics Error] Failed to set user properties: $e');
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    try {
      // Check for PII
      if (_containsPII(name, value)) {
        debugPrint('[Analytics Warning] Skipping PII user property: $name');
        return;
      }

      final sanitizedValue = _sanitizeParameter(name, value);
      await _firebaseAnalytics.setUserProperty(
        name: name,
        value: sanitizedValue,
      );

      if (_debugMode) {
        debugPrint('[Analytics] User Property Set: $name = $sanitizedValue');
      }
    } catch (e) {
      debugPrint('[Analytics Error] Failed to set user property "$name": $e');
    }
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _firebaseAnalytics.setAnalyticsCollectionEnabled(enabled);
      debugPrint('[Analytics] Collection Enabled: $enabled');
    } catch (e) {
      debugPrint('[Analytics Error] Failed to set analytics collection: $e');
    }
  }

  /// Sanitizes a parameter value to remove unwanted characters and enforce length limit.
  ///
  /// Returns:
  /// - Trimmed, truncated string without special characters
  String _sanitizeParameter(String key, String value) {
    // Remove leading/trailing whitespace
    String sanitized = value.trim();

    // Truncate to max length
    if (sanitized.length > _maxParameterLength) {
      sanitized = sanitized.substring(0, _maxParameterLength);
    }

    // Remove or replace problematic characters
    sanitized = sanitized.replaceAll(RegExp(r'[^\w\s\-\.]'), '');

    return sanitized;
  }

  /// Checks if a parameter contains potential PII.
  ///
  /// Returns true if the key or value suggests sensitive data.
  bool _containsPII(String key, String value) {
    final lowerKey = key.toLowerCase();
    final lowerValue = value.toLowerCase();

    // Check key for PII indicators
    for (final indicator in _piiIndicators) {
      if (lowerKey.contains(indicator)) {
        return true;
      }
    }

    // Check for common PII patterns in value
    // Email pattern
    if (lowerValue.contains('@') && lowerValue.contains('.')) {
      return true;
    }

    // Phone pattern (simple heuristic)
    if (RegExp(r'^\d{3}[-.\s]?\d{3}[-.\s]?\d{4}$').hasMatch(value)) {
      return true;
    }

    // Credit card pattern
    if (RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b').hasMatch(value)) {
      return true;
    }

    return false;
  }
}
