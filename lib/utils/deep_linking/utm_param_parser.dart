import 'package:flutter/foundation.dart';

/// Model containing parsed UTM parameters from a URL.
class UTMData {
  final String? source; // utm_source
  final String? medium; // utm_medium
  final String? campaign; // utm_campaign
  final String? content; // utm_content
  final String? term; // utm_term

  const UTMData({
    this.source,
    this.medium,
    this.campaign,
    this.content,
    this.term,
  });

  /// Checks if any UTM parameters were present.
  bool get hasAnyParams =>
      source != null ||
      medium != null ||
      campaign != null ||
      content != null ||
      term != null;

  /// Converts UTM data to a map for analytics tracking.
  Map<String, String> toMap() {
    final map = <String, String>{};
    if (source != null) map['utm_source'] = source!;
    if (medium != null) map['utm_medium'] = medium!;
    if (campaign != null) map['utm_campaign'] = campaign!;
    if (content != null) map['utm_content'] = content!;
    if (term != null) map['utm_term'] = term!;
    return map;
  }

  @override
  String toString() =>
      'UTMData('
      'source: $source, '
      'medium: $medium, '
      'campaign: $campaign, '
      'content: $content, '
      'term: $term)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UTMData &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          medium == other.medium &&
          campaign == other.campaign &&
          content == other.content &&
          term == other.term;

  @override
  int get hashCode =>
      source.hashCode ^
      medium.hashCode ^
      campaign.hashCode ^
      content.hashCode ^
      term.hashCode;
}

/// Parser for UTM (Urchin Tracking Module) parameters from URLs.
///
/// This class extracts and validates UTM campaign parameters that are commonly
/// used to track the source of traffic in marketing campaigns.
///
/// UTM parameters:
/// - utm_source: Identifies the source (e.g., google, facebook, newsletter)
/// - utm_medium: Identifies the medium (e.g., cpc, organic, email)
/// - utm_campaign: Identifies the campaign (e.g., spring_sale, promo)
/// - utm_content: Identifies a specific ad or link (e.g., banner, text_link)
/// - utm_term: Identifies the keyword (for paid search)
///
/// Example:
/// ```dart
/// // From URL: https://example.com/promo?utm_source=google&utm_medium=cpc&utm_campaign=summer_sale
/// final utmData = UTMParamParser.parseUrlString('https://example.com/promo?utm_source=google&utm_medium=cpc&utm_campaign=summer_sale');
/// print(utmData.source);     // 'google'
/// print(utmData.campaign);  // 'summer_sale'
/// ```
class UTMParamParser {
  // Maximum length for UTM parameter values
  static const int _maxParamLength = 100;

  // Characters that are allowed in UTM parameters
  static const String _allowedChars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~';

  /// Parses UTM parameters from a complete URL string.
  ///
  /// Parameters:
  /// - [urlString]: The full URL to parse (e.g., 'https://example.com?utm_source=google')
  ///
  /// Returns:
  /// - [UTMData] with any found UTM parameters
  ///
  /// Example:
  /// ```dart
  /// final utm = UTMParamParser.parseUrlString('https://app.example.com?utm_source=instagram&utm_campaign=promo');
  /// ```
  static UTMData parseUrlString(String urlString) {
    try {
      final uri = Uri.parse(urlString);
      return _parseQueryParameters(uri.queryParameters);
    } catch (e) {
      debugPrint('[UTM] Failed to parse URL: $e');
      return const UTMData();
    }
  }

  /// Parses UTM parameters from a URI object.
  ///
  /// Parameters:
  /// - [uri]: The URI to extract parameters from
  ///
  /// Returns:
  /// - [UTMData] with any found UTM parameters
  static UTMData parseUri(Uri uri) {
    try {
      return _parseQueryParameters(uri.queryParameters);
    } catch (e) {
      debugPrint('[UTM] Failed to parse URI: $e');
      return const UTMData();
    }
  }

  /// Parses UTM parameters from a route path/query string.
  ///
  /// Parameters:
  /// - [routePath]: The route path with query string (e.g., '/promo?utm_source=google&utm_campaign=summer')
  ///
  /// Returns:
  /// - [UTMData] with any found UTM parameters
  ///
  /// Example:
  /// ```dart
  /// final utm = UTMParamParser.parseRoutePath('/home?utm_source=email&utm_medium=newsletter');
  /// ```
  static UTMData parseRoutePath(String routePath) {
    try {
      // Extract query string if present
      if (!routePath.contains('?')) {
        return const UTMData();
      }

      final queryString = routePath.split('?')[1];
      final params = _parseQueryString(queryString);
      return _parseQueryParameters(params);
    } catch (e) {
      debugPrint('[UTM] Failed to parse route path: $e');
      return const UTMData();
    }
  }

  /// Parses UTM parameters from a raw query string.
  ///
  /// Parameters:
  /// - [queryString]: The query string without the '?' prefix (e.g., 'utm_source=google&utm_campaign=promo')
  ///
  /// Returns:
  /// - [UTMData] with any found UTM parameters
  static UTMData parseQueryString(String queryString) {
    try {
      final params = _parseQueryString(queryString);
      return _parseQueryParameters(params);
    } catch (e) {
      debugPrint('[UTM] Failed to parse query string: $e');
      return const UTMData();
    }
  }

  /// Parses a query string into a map of parameters.
  ///
  /// Handles URL-encoded parameters and special characters.
  static Map<String, String> _parseQueryString(String queryString) {
    final params = <String, String>{};

    if (queryString.isEmpty) {
      return params;
    }

    for (final param in queryString.split('&')) {
      if (param.isEmpty) continue;

      final parts = param.split('=');
      if (parts.length == 2) {
        final key = Uri.decodeComponent(parts[0]);
        final value = Uri.decodeComponent(parts[1]);
        params[key] = value;
      }
    }

    return params;
  }

  /// Extracts and validates UTM parameters from a query parameter map.
  ///
  /// Parameters:
  /// - [queryParams]: Map of query parameters from URI
  ///
  /// Returns:
  /// - [UTMData] with validated UTM parameters
  static UTMData _parseQueryParameters(Map<String, String> queryParams) {
    try {
      return UTMData(
        source: _sanitizeParameter(queryParams['utm_source']),
        medium: _sanitizeParameter(queryParams['utm_medium']),
        campaign: _sanitizeParameter(queryParams['utm_campaign']),
        content: _sanitizeParameter(queryParams['utm_content']),
        term: _sanitizeParameter(queryParams['utm_term']),
      );
    } catch (e) {
      debugPrint('[UTM] Failed to extract UTM parameters: $e');
      return const UTMData();
    }
  }

  /// Sanitizes and validates a UTM parameter value.
  ///
  /// Performs:
  /// - Null check
  /// - Trimming whitespace
  /// - Length validation (max 100 chars)
  /// - Character validation (removes invalid chars)
  ///
  /// Parameters:
  /// - [value]: The raw parameter value to sanitize
  ///
  /// Returns:
  /// - Sanitized parameter value, or null if invalid
  static String? _sanitizeParameter(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Trim whitespace
    String sanitized = value.trim();

    // Check length
    if (sanitized.length > _maxParamLength) {
      debugPrint(
        '[UTM] Parameter truncated from ${sanitized.length} to $_maxParamLength chars',
      );
      sanitized = sanitized.substring(0, _maxParamLength);
    }

    // Remove invalid characters (keep only alphanumeric and special chars allowed in URLs)
    final buffer = StringBuffer();
    for (final char in sanitized.split('')) {
      if (_allowedChars.contains(char) || char == '_') {
        buffer.write(char);
      }
    }

    final result = buffer.toString();

    // Return null if empty after sanitization
    if (result.isEmpty) {
      return null;
    }

    return result;
  }

  /// Validates if a string contains valid UTM parameters.
  ///
  /// Parameters:
  /// - [urlString]: URL string to check
  ///
  /// Returns:
  /// - true if URL contains any valid UTM parameters
  static bool containsUTMParameters(String urlString) {
    try {
      final utmData = parseUrlString(urlString);
      return utmData.hasAnyParams;
    } catch (e) {
      return false;
    }
  }
}
