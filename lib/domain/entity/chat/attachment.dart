enum AttachmentType {
  image,
  video,
  audio,
  pdf,
  document,
  archive,
  unknown,
}

class Attachment {
  final String url;
  final String name;
  final AttachmentType type;

  const Attachment({
    required this.url,
    required this.name,
    required this.type,
  });
}