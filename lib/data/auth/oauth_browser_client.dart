import 'package:ai_helpdesk/utils/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Thrown when the user dismisses the in-app browser before the OAuth flow
/// completes. Distinct from network/state-mismatch errors so the repository
/// can map it to [OAuthCancelledFailure] and the UI can stay quiet.
class OAuthCancelledException implements Exception {
  const OAuthCancelledException();
}

/// Thin abstraction over the OAuth browser session so [AuthRepositoryImpl]
/// can be unit-tested without platform channels in the loop.
abstract class OAuthBrowserClient {
  /// Open [url] in a browser surface, wait for a navigation matching the
  /// callback URL, and return that URL.
  ///
  /// [callbackUrlScheme] is the scheme part of the redirect URI we registered
  /// with the OAuth provider (always `https` here, since Stack Auth's
  /// whitelist only contains the HTTPS web redirect URL). Implementations
  /// also need the host + path prefix to know which navigation to intercept;
  /// they read those from the URL passed to [authenticate] indirectly via
  /// the constructor in production. In the WebView impl they are hard-coded
  /// from [EnvConfig.oauthRedirectUri].
  ///
  /// Throws [OAuthCancelledException] when the user dismisses the session.
  ///
  /// When [forceAccountChooser] is true, implementations should clear any
  /// cached browser state (cookies, web storage) so the OAuth provider is
  /// forced to show its full account chooser instead of silently reusing
  /// the previously signed-in account.
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    bool forceAccountChooser = false,
  });
}

/// In-app WebView implementation. Stack Auth only whitelists the HTTPS web
/// redirect URL `https://helpdesk.jarvis.cx/oauth2callback`, and the web
/// frontend at that URL does NOT bounce the request back to the mobile app.
/// To capture the OAuth callback without depending on App Links / Universal
/// Links infrastructure (assetlinks.json / apple-app-site-association we
/// can't deploy from the mobile project), we render the OAuth flow in our
/// own WebView and intercept the navigation to [callbackUrlPrefix] before
/// the WebView loads the web page that would otherwise consume it.
///
/// The User-Agent is overridden to a plain Chrome string so Google's
/// `disallowed_useragent` check doesn't reject the embedded WebView.
class WebViewBrowserClient implements OAuthBrowserClient {
  /// Full prefix the WebView listens for; navigation matching this is
  /// captured and the URL is returned to the caller. Hard-coded from
  /// [EnvConfig.oauthRedirectUri] at construction time.
  final String callbackUrlPrefix;

  const WebViewBrowserClient({required this.callbackUrlPrefix});

  static const _desktopChromeUserAgent =
      'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/124.0.0.0 Mobile Safari/537.36';

  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
    bool forceAccountChooser = false,
  }) async {
    final navigator = AppNavigator.key.currentState;
    if (navigator == null) {
      throw StateError('Navigator not ready — cannot start OAuth WebView.');
    }
    if (forceAccountChooser) {
      // Cookies / web storage in webview_flutter are globally shared across
      // every WebViewController instance; clearing here means the next
      // authorize request lands on Google's full account chooser instead of
      // auto-resuming the previously signed-in account.
      await WebViewCookieManager().clearCookies();
    }
    final result = await navigator.push<String>(
      MaterialPageRoute<String>(
        fullscreenDialog: true,
        builder: (_) => _OAuthWebViewScreen(
          authorizeUrl: url,
          callbackUrlPrefix: callbackUrlPrefix,
          userAgent: _desktopChromeUserAgent,
          clearStorageBeforeLoad: forceAccountChooser,
        ),
      ),
    );
    if (result == null) {
      throw const OAuthCancelledException();
    }
    return result;
  }
}

class _OAuthWebViewScreen extends StatefulWidget {
  const _OAuthWebViewScreen({
    required this.authorizeUrl,
    required this.callbackUrlPrefix,
    required this.userAgent,
    this.clearStorageBeforeLoad = false,
  });

  final String authorizeUrl;
  final String callbackUrlPrefix;
  final String userAgent;
  final bool clearStorageBeforeLoad;

  @override
  State<_OAuthWebViewScreen> createState() => _OAuthWebViewScreenState();
}

class _OAuthWebViewScreenState extends State<_OAuthWebViewScreen> {
  late final WebViewController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(widget.userAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (_isCallback(request.url)) {
              _finish(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            final url = change.url;
            if (url != null && _isCallback(url)) {
              _finish(url);
            }
          },
        ),
      );
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (widget.clearStorageBeforeLoad) {
      // Belt-and-braces: cookies are cleared by the caller, but localStorage /
      // sessionStorage on accounts.google.com can also keep the user signed in.
      await _controller.clearLocalStorage();
      await _controller.clearCache();
    }
    await _controller.loadRequest(Uri.parse(widget.authorizeUrl));
  }

  bool _isCallback(String url) => url.startsWith(widget.callbackUrlPrefix);

  void _finish(String url) {
    if (_completed) return;
    _completed = true;
    Navigator.of(context).pop(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in with Google'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!_completed) {
              _completed = true;
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
