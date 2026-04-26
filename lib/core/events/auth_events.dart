/// Fired on the shared [EventBus] whenever the refresh-token flow fails
/// terminally (token revoked or expired). Listeners should clear any
/// remaining in-memory session state and navigate the user back to the
/// sign-in screen.
class AuthUnauthorizedEvent {
  final String reason;
  const AuthUnauthorizedEvent([this.reason = 'refresh_failed']);
}
