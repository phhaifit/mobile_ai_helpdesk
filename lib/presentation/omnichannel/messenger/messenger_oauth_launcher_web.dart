import 'package:web/web.dart' as web;

void launchMessengerOauth(String url) {
  web.window.location.assign(url);
}

String currentOrigin() {
  return web.window.location.origin;
}
