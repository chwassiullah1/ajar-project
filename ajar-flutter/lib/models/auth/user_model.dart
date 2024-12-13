import 'package:ajar/models/auth/address_model.dart';
import 'package:ajar/models/auth/driving_license_details.dart';
import 'package:ajar/models/auth/role_model.dart';
import 'package:ajar/utils/api_constnsts.dart';

class UserModel {
  final String id;
  final String email;
  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? otp;
  final String? profilePicture;
  final String? cnic;
  final AddressModel? address;
  final bool isAdmin;
  final bool isVerified;
  final String? roleId;
  final DrivingLicenseDetails? drivingLicenseDetails;
  final String profileCompletion;
  final String createdAt;
  final String updatedAt;
  final RoleModel? role;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.otp,
    this.profilePicture,
    this.cnic,
    this.address,
    required this.isAdmin,
    required this.isVerified,
    this.roleId,
    this.drivingLicenseDetails,
    required this.profileCompletion,
    required this.createdAt,
    required this.updatedAt,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      otp: json['otp'],
      profilePicture: json['profile_picture'] != null
          ? "${Constants.baseUrl}${json['profile_picture']}"
          : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
      cnic: json['cnic'] ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : AddressModel(
              streetNo: 0,
              city: '',
              state: '',
              postalCode: '',
              country: '',
            ),
      isAdmin: json['is_admin'],
      isVerified: json['is_verified'],
      roleId: json['role_id'],
      drivingLicenseDetails: json['driving_license_details'] != null
          ? DrivingLicenseDetails.fromJson(json['driving_license_details'])
          : DrivingLicenseDetails(
              firstName: '',
              lastName: '',
              country: '',
              state: '',
              licenseNumber: '',
              dateOfBirth: '',
              expirationDate: '',
            ),
      profileCompletion: json['profile_completion'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'])
          : RoleModel(id: '', title: ''),
    );
  }

  factory UserModel.fromJsonForReviewer(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      otp: json['otp'],
      profilePicture:
          json['profile_picture'] ?? 'assets/images/profile-picture.jpg',
      cnic: json['cnic'] ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : AddressModel(
              streetNo: 0,
              city: '',
              state: '',
              postalCode: '',
              country: '',
            ),
      isAdmin: json['is_admin'],
      isVerified: json['is_verified'],
      roleId: json['role_id'],
      drivingLicenseDetails: json['driving_license_details'] != null
          ? DrivingLicenseDetails.fromJson(json['driving_license_details'])
          : DrivingLicenseDetails(
              firstName: '',
              lastName: '',
              country: '',
              state: '',
              licenseNumber: '',
              dateOfBirth: '',
              expirationDate: '',
            ),
      profileCompletion: json['profile_completion'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'])
          : RoleModel(id: '', title: ''),
    );
  }

    factory UserModel.fromJsonGetConversations(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      otp: json['otp'],
      profilePicture: json['profile_picture'] != null
          ? "${Constants.baseUrl}${json['profile_picture']}"
          : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
      cnic: json['cnic'] ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : AddressModel(
              streetNo: 0,
              city: '',
              state: '',
              postalCode: '',
              country: '',
            ),
      isAdmin: json['is_admin'],
      isVerified: json['is_verified'],
      roleId: json['role_id'],
      drivingLicenseDetails: json['driving_license_details'] != null
          ? DrivingLicenseDetails.fromJson(json['driving_license_details'])
          : DrivingLicenseDetails(
              firstName: '',
              lastName: '',
              country: '',
              state: '',
              licenseNumber: '',
              dateOfBirth: '',
              expirationDate: '',
            ),
      profileCompletion: json['profile_completion'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
