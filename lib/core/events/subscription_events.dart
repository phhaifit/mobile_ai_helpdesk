/// Fired on the shared EventBus when the backend reports the tenant's
/// subscription is required/expired.
///
/// Triggered from the helpdesk Dio error interceptor on 403 + code
/// `SUBSCRIPTION_REQUIRED`.
class SubscriptionRequiredEvent {
  final String message;
  const SubscriptionRequiredEvent([this.message = '']);
}

