class RenterAddress {
  final int? streetNo;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  RenterAddress({
    required this.streetNo,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory RenterAddress.fromJson(Map<String, dynamic> json) {
    return RenterAddress(
      streetNo: json['streetNo'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
  // Convert AddressModel to a JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'state': state,
      'city': city,
      'streetNo': streetNo,
      'postalCode': postalCode,
    };
  }
}
