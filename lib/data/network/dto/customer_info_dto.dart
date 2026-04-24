class CustomerInfoDto {
  final String customerID;
  final String name;

  CustomerInfoDto({required this.customerID, required this.name});

  factory CustomerInfoDto.fromJson(Map<String, dynamic> json) {
    return CustomerInfoDto(
      customerID: (json['customerID'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}