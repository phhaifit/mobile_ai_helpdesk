class FileAttachmentDto {
  final String url;
  final String type; // MIME type (image/png, application/pdf, etc.)
  final String name;

  FileAttachmentDto({required this.url, required this.type, required this.name});

  factory FileAttachmentDto.fromJson(Map<String, dynamic> json) {
    return FileAttachmentDto(
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}