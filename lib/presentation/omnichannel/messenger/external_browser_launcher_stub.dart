void openExternalUrl(String url) {
  throw UnsupportedError(
    'External browser launcher is only available on web. '
    'Mobile platforms should integrate via Android App Links / iOS Universal Links.',
  );
}
