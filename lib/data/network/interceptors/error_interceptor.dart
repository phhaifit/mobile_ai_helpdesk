import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';

import 'package:ai_helpdesk/core/domain/error/api_failure.dart';
import 'package:ai_helpdesk/core/events/subscription_events.dart';
import 'package:ai_helpdesk/data/network/utils/helpdesk_error_mapper.dart';

class ErrorInterceptor extends Interceptor {
  final EventBus _eventBus;

  ErrorInterceptor(this._eventBus);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Fire global events for app-wide error handling concerns.
    // This interceptor must remain side-effect only (no UI logic).
    try {
      final failure = HelpdeskErrorMapper.map(err);
      if (failure is ApiFailure &&
          failure.kind == ApiErrorKind.subscriptionRequired) {
        _eventBus.fire(SubscriptionRequiredEvent(failure.safeMessage ?? ''));
      }
    } catch (_) {
      // Never break the Dio pipeline due to error parsing failures.
    }

    _eventBus.fire(
      ErrorEvent(path: err.requestOptions.path, response: err.response),
    );
    super.onError(err, handler);
  }
}

class ErrorEvent {
  final String path;
  final Response<dynamic>? response;

  ErrorEvent({required this.path, this.response});
}
