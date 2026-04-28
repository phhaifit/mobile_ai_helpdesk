enum MessageType {
  text('text'),
  image('image'),
  file('file'),
  system('system');

  const MessageType(this.value);
  final String value;
}