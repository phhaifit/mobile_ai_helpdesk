import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'splash_store.g.dart';

/// Where the splash guard should route after it has evaluated the cached
/// session.
enum SplashDestination { home, signIn }

// ignore: library_private_types_in_public_api
class SplashStore = _SplashStoreBase with _$SplashStore;

abstract class _SplashStoreBase with Store {
  final AuthRepository _authRepository;
  final AccountRepository _accountRepository;
  final AuthStore _authStore;

  _SplashStoreBase({
    required AuthRepository authRepository,
    required AccountRepository accountRepository,
    required AuthStore authStore,
  })  : _authRepository = authRepository,
        _accountRepository = accountRepository,
        _authStore = authStore;

  @observable
  SplashDestination? destination;

  @observable
  String? transientError;

  @action
  Future<SplashDestination> boot() async {
    transientError = null;
    final session = await _authRepository.loadSession();
    if (session == null) {
      destination = SplashDestination.signIn;
      return SplashDestination.signIn;
    }

    final cached = await _accountRepository.loadCached();
    if (cached != null) {
      _authStore.hydrate(session: session, account: cached);
    }

    // Validate session with the server. If it fails with a session-expired
    // failure, force sign-in. Network / transient failures keep the cached
    // account so offline starts still work.
    final result = await _accountRepository.getCurrent();
    return result.fold((failure) async {
      if (failure is SessionExpiredFailure) {
        _authStore.onSignedOut(reason: 'sso_validate_session_expired');
        destination = SplashDestination.signIn;
        return SplashDestination.signIn;
      }
      if (cached == null) {
        transientError = 'common_error_network';
        destination = SplashDestination.signIn;
        return SplashDestination.signIn;
      }
      destination = SplashDestination.home;
      return SplashDestination.home;
    }, (fresh) {
      _authStore.hydrate(session: session, account: fresh);
      destination = SplashDestination.home;
      return SplashDestination.home;
    });
  }
}
