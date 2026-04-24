class CustomerInfoDto {
  final String customerId;
  final String name;

  CustomerInfoDto({required this.customerId, required this.name});

  factory CustomerInfoDto.fromJson(Map<String, dynamic> json) {
    return CustomerInfoDto(
      customerId: (json['customerID'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}