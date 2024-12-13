// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ajar/models/tokens/auth_tokens.dart';
import 'package:ajar/utils/api_constnsts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../models/auth/user_model.dart';
import '../../services/authentication/auth_servcies.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthService _authService = AuthService(); // Instance of AuthService
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // bool _isGoogleLoading = false;
  // bool get isGoogleLoading => _isGoogleLoading;

  UserModel? _user; // Private variable to hold user data
  UserModel? get user => _user; // Getter for user data

  // Register user through AuthService
  Future<int> registerUser({
    required String email,
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authService
          .registerUser(
            email: email,
            phone: phone,
            password: password,
            firstName: firstName,
            lastName: lastName,
          )
          .timeout(const Duration(seconds: 10));
      _isLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data']['data'][0];
        _user = UserModel.fromJson(responseData);
        notifyListeners();
      }
      return response.statusCode; // Return the status code
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error: $e');
      return -1; // Return -1 for any network error or exceptions
    }
  }

  Future<int> verifyAccount({
    required String email,
    required String otp,
  }) async {
    try {
      // Set loading state
      _isLoading = true;
      notifyListeners();

      // Call the AuthService verifyAccount method
      http.Response response = await _authService
          .verifyAccount(email: email, otp: otp)
          .timeout(const Duration(seconds: 10));

      // Stop loading state
      _isLoading = false;
      notifyListeners();

      // Handle response based on status code
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          // OTP verified successfully, update user data
          _user = UserModel.fromJson(data['data']['data'][0]);
          notifyListeners();

          return 200; // OTP verified successfully
        }
      }

      // If the status code is not 200, return a failure code (400)
      return 400; // Bad request or verification failed
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      print("Error in provider: $e");
      return -1; // Return -1 for any error
    }
  }

  Future<int> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .login(email: email, password: password)
          .timeout(const Duration(seconds: 10)); // Call the AuthService method
      print(
        response.statusCode,
      );
      print(
        response.body,
      );
      // Handle the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userData = responseData['data']['data'];
        final tokens = AuthTokens.fromJson(responseData['data']);

        // Store tokens using AuthService
        await AuthService.storeTokens(tokens.accessToken, tokens.refreshToken);

        _user = UserModel.fromJson(userData);

        notifyListeners();

        return 200; // Success: User logged in
      }

      return response.statusCode; // Return the status code for other responses
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print("Error From Provider: $error");
      return -1; // Return -1 for network or other errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getUserData() async {
    try {
      final response = await AuthService()
          .getUserData()
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _user = UserModel.fromJson(data['data']);
          print("This is your host id ${_user!.id}");
          notifyListeners();
          return 200; // Success
        }
      }

      // Handle the case where access token is expired
      if (response.statusCode == 401) {
        final refreshResponse = await _authService
            .refreshAccessToken()
            .timeout(const Duration(seconds: 10));
        print("Refreshing access token");
        if (refreshResponse.statusCode == 200) {
          final data = json.decode(refreshResponse.body);
          if (data['success']) {
            await AuthService.storeTokens(
              data['data']['accessToken'],
              data['data']['refreshToken'],
            );
            return await getUserData(); // Retry fetching user data
          }
        }
        if (refreshResponse.statusCode == 403) {
          throw Exception('Refresh token invalid!');
        }
      }

      return response.statusCode; // Return other error codes
    } catch (e) {
      print("Error occurred: $e");
      return -1; // Indicate error
    } finally {}
  }

  Future<int> requestNewOTP(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .requestNewOTP(email)
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      _isLoading = false;
      notifyListeners();

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _user = UserModel.fromJson(data['data'][0]);
          notifyListeners();
          return 200; // Success
        } else {
          return 400; // Custom code for unsuccessful operation
        }
      } else {
        return response.statusCode; // Return actual error code
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
      return -1; // Indicate an error occurred
    }
  }

  Future<int> verifyOTP(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .verifyOTP(email, otp)
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      _isLoading = false;
      notifyListeners();

      print(response.statusCode);
      print(response.body);

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success']) {
        // OTP verified successfully
        _user = UserModel.fromJson(data['data']['data'][0]);
        return 200; // Success code
      } else if (response.statusCode == 400) {
        // Handle error cases
        return 400; // Bad request
      } else {
        // Handle other unsuccessful responses
        return response.statusCode; // Return the actual error code
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
      return -1; // Indicate an error occurred
    }
  }

  Future<int> resetForgetPassword(String email, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .resetForgetPassword(email, newPassword)
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      _isLoading = false;
      notifyListeners();

      print(response.statusCode);
      print(response.body);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        // Password reset successfully
        return 200; // Success code
      } else if (response.statusCode == 400) {
        // Check for specific error messages
        if (data['message'] is String) {
          // Handle the case where the message is a string (e.g., previous and new passwords are the same)
          return 400; // Custom code for previous password same as new password
        } else if (data['message'] is List) {
          // Handle the case where the message is an array of validation errors
          return 500; // Custom code for validation errors
        }
      }
      print("Password reset response: ${response.statusCode}");
      return response
          .statusCode; // Return actual error code for other responses
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
      return -1; // Indicate an error occurred
    }
  }

  Future<int> updatePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .updatePassword(oldPassword, newPassword)
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      _isLoading = false;
      notifyListeners();

      // Handle success response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return 200; // Password updated successfully
        }
      }

      // Handle token expiry (401) and retry logic
      else if (response.statusCode == 401) {
        // Access token expired, refresh token
        await _authService.refreshAccessToken();
        final accessToken = await AuthService.getAccessToken(); // Get new token

        if (accessToken == null) {
          return 401; // Failed to refresh token
        }

        // Retry the request with the new token
        final retryResponse = await AuthService()
            .updatePassword(oldPassword, newPassword)
            .timeout(const Duration(seconds: 10));

        if (retryResponse.statusCode == 200) {
          final retryData = json.decode(retryResponse.body);
          if (retryData['success']) {
            return 200; // Password updated successfully after retry
          }
        }
      }

      // Handle other error responses
      final errorData = json.decode(response.body);
      if (response.statusCode == 400) {
        if (errorData['message'] is List) {
          print("Error: ${errorData['message'][0]['message']}");
          return 500; // Custom code for validation errors
        } else {
          print("Error: ${errorData['message']}");
          return 400; // Custom code for bad request
        }
      }

      return response.statusCode; // Return other status codes (e.g., 400)
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Error occurred: $e");
      return -1; // Indicate a general error
    }
  }

  Future<int> updateDrivingLicense(
    String firstName,
    String lastName,
    String country,
    String state,
    String licenseNumber,
    String dateOfBirth,
    String expirationDate,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService
          .updateDrivingLicenseDetails(
            firstName: firstName,
            lastName: lastName,
            country: country,
            state: state,
            licenseNumber: licenseNumber,
            dateOfBirth: dateOfBirth,
            expirationDate: expirationDate,
          )
          .timeout(const Duration(seconds: 10));

      _isLoading = false;
      notifyListeners();

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        _user = UserModel.fromJson(responseData);
        notifyListeners();
        return 200; // Return 200 for successful update
      } else if (response.statusCode == 400) {
        // Custom error handling for 400 response
        final responseBody = json.decode(response.body);
        if (responseBody['message'] is List) {
          for (var error in responseBody['message']) {
            if (error['field'] == 'date_of_birth') {
              print("Error: You must be at least 18 years old.");
              return 401; // Return a custom status code for age validation
            } else if (error['field'] == 'expiration_date') {
              print("Error: Expiration date must be in the future.");
              return 402; // Return a custom status code for expiration date validation
            } else {
              print("Error: ${error['message']}");
            }
          }
        }
      }

      return response
          .statusCode; // Return the original status code if it's not handled
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error: $e');
      return -1; // Return -1 for any network error or exceptions
    }
  }

  Future<int> completeUserProfile(
    String nationalIdCardNumber,
    String gender,
    String country,
    String state,
    String city,
    int streetNo,
    String postalCode,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService
          .completeUserProfile(
            cnic: nationalIdCardNumber,
            gender: gender,
            streetNo: streetNo,
            city: city,
            state: state,
            postalCode: postalCode,
            country: country,
          )
          .timeout(const Duration(seconds: 10));
      _isLoading = false;
      notifyListeners();

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData =
            json.decode(response.body)['data']; // Access data directly
        _user = UserModel.fromJson(responseData); // No need for [0]
        notifyListeners();
        return 200; // Return 200 for successful update
      }

      return response
          .statusCode; // Return the original status code if it's not handled
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error: $e');
      return -1; // Return -1 for any network error or exceptions
    }
  }

  Future<int> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService()
          .logout()
          .timeout(const Duration(seconds: 10)); // Call the AuthService method

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          // Clear stored tokens using AuthService
          await AuthService.clearTokens();
          return 200; // Logout successful
        } else {
          return 400; // You can change this based on your API error handling logic
        }
      } else {
        return response
            .statusCode; // Return the actual error code from response
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print('Logout failed with error: $error');
      return 500; // Return 500 or a custom error code indicating internal server error or other issue
    }
  }

  Future<int> updateProfilePicture(XFile image) async {
    String? accessToken = await AuthService.getAccessToken();

    if (accessToken == null) {
      return 401; // Access token is missing
    }

    _isLoading = true;
    notifyListeners();

    final String? profilePictureUrl = await AuthService()
        .updateProfilePicture(image.path)
        .timeout(const Duration(seconds: 10));

    _isLoading = false;
    notifyListeners();

    if (profilePictureUrl != null) {
      _updateUserProfilePicture(
          profilePictureUrl); // Update user model with the new picture URL

      return 200; // Return success status code
    }

    return 500; // Return error code for failure
  }

  // Method to update just the profile picture in UserModel
  void _updateUserProfilePicture(String profilePictureUrl) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        email: _user!.email,
        phone: _user!.phone,
        password: _user!.password,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        gender: _user!.gender,
        otp: _user!.otp,
        profilePicture:
            '${Constants.baseUrl}$profilePictureUrl', // Update profile picture
        cnic: _user!.cnic,
        address: _user!.address,
        isAdmin: _user!.isAdmin,
        isVerified: _user!.isVerified,
        role: _user!.role,
        createdAt: _user!.createdAt,
        updatedAt: _user!.updatedAt,
        profileCompletion: _user!.profileCompletion,
        roleId: _user!.roleId,
      );
    }
    notifyListeners();
  }

  Future<int> becomeAHost() async {
    String? accessToken = await AuthService.getAccessToken();
    if (accessToken == null) {
      return 401; // Access token is missing
    }

    _isLoading = true; // Start loading
    notifyListeners();

    try {
      final response =
          await _authService.becomeAHost().timeout(const Duration(seconds: 10));

      // Stop loading
      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        _user = UserModel.fromJson(responseData);

        // Notify listeners for user role changes
        notifyListeners(); // This can be optional based on how your UI is structured

        return 200; // Successfully became a host
      }
      return response.statusCode; // Return the status code if it's not 200
    } catch (e) {
      _isLoading = false; // Ensure loading stops even on error
      notifyListeners(); // Notify listeners on error to update the UI
      print('Error in becomeAHost: $e');
      return 500; // Return a default error status code
    }
  }

  // Future<Map<String, dynamic>?> registerWithGoogle({
  //   required String email,
  //   required String displayName,
  //   required String idToken,
  // }) async {
  //   _isGoogleLoading = true;
  //   notifyListeners();

  //   const String url = 'https://yourapi.com/register-with-google';

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //         'display_name': displayName,
  //         'id_token': idToken, // Send the Google ID token
  //       }),
  //     );

  //     _isGoogleLoading = false;
  //     notifyListeners();

  //     final Map<String, dynamic> responseData = jsonDecode(response.body);

  //     return responseData; // Return the response data for further handling
  //   } catch (e) {
  //     _isGoogleLoading = false;
  //     notifyListeners();
  //     return {
  //       'success': false,
  //       'message': 'An error occurred. Please try again.'
  //     };
  //   }
  // }
}
