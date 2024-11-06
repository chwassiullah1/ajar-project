class DrivingLicenseDetails {
  final String firstName;
  final String lastName;
  final String country;
  final String state;
  final String licenseNumber;
  final String dateOfBirth;
  final String expirationDate;

  DrivingLicenseDetails({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.state,
    required this.licenseNumber,
    required this.dateOfBirth,
    required this.expirationDate,
  });

  factory DrivingLicenseDetails.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseDetails(
      firstName: json['first_name'],
      lastName: json['last_name'],
      country: json['country'],
      state: json['state'],
      licenseNumber: json['license_number'],
      dateOfBirth: json['date_of_birth'],
      expirationDate: json['expiration_date'],
    );
  }
}