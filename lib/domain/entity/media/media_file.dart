class MediaFile {
  final String id;
  final String url;
  final String filename;
  final String mimeType;

  const MediaFile({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        id: json['id'] as String,
        url: json['url'] as String,
        filename: json['filename'] as String,
        mimeType: json['mimeType'] as String,
      );
}
