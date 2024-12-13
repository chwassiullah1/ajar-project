// import 'dart:convert';
// import 'package:ajar/models/favoriteVehicle/favorite_vehicle.dart';
// import 'package:ajar/models/vehicle/vehicle_model.dart';
// import 'package:ajar/models/vehicle/vehicle_response.dart';
// import 'package:ajar/services/authentication/auth_servcies.dart';
// import 'package:ajar/utils/api_constnsts.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart'; // Assuming constants for URLs

// class VehicleService {
//   // Method to create a vehicle
//   Future<http.Response> createVehicle(Vehicle vehicleData) async {
//     String? accessToken = await AuthService.getAccessToken();

//     if (accessToken == null) {
//       throw Exception('No access token found');
//     }

//     final url = Uri.parse(
//         '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode(vehicleData),
//       );
//       print(
//           "Response from vehicle service class: ${response.statusCode} ${response.body}");
//       return response;
//     } catch (e) {
//       print('Error during vehicle registration: $e');
//       throw Exception('Failed to register vehicle');
//     }
//   }

//   Future<http.Response> uploadVehiclePictures(
//       String vehicleId, List<XFile> images) async {
//     // Get the access token
//     final accessToken = await AuthService.getAccessToken();

//     if (accessToken == null) {
//       throw Exception("Access token is missing.");
//     }
//     final url = Uri.parse(
//         '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/pictures/$vehicleId');

//     try {
//       final request = http.MultipartRequest('PATCH', url)
//         ..headers['Authorization'] = 'Bearer $accessToken';

//       // Add images to the request
//       for (var image in images) {
//         request.files.add(
//           await http.MultipartFile.fromPath('pictures[]', image.path),
//         );
//       }

//       final response = await request.send();
//       final responseData = await http.Response.fromStream(response);
//       return responseData; // Return the http.Response
//     } catch (e) {
//       print("Error uploading vehicle pictures: $e");
//       throw Exception("Failed to upload images");
//     }
//   }

//   Future<http.Response> updateVehicle(
//       Vehicle vehicleData, String vehicleId) async {
//     String? accessToken = await AuthService.getAccessToken();

//     if (accessToken == null) {
//       throw Exception('No access token found');
//     }

//     final url = Uri.parse(
//         '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/$vehicleId');

//     try {
//       final response = await http.patch(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode(vehicleData),
//       );
//       print(
//           "Response from vehicle update service class: ${response.statusCode} ${response.body}");
//       return response;
//     } catch (e) {
//       print('Error during vehicle updation: $e');
//       throw Exception('Failed to update vehicle');
//     }
//   }

//   Future<VehicleResponse> fetchVehicles(
//       {int? limit,
//       String? make,
//       int? page,
//       String? price,
//       String? vehicleId,
//       String? hostId,
//       String? startDate,
//       String? endDate,
//       String? city,
//       String? vehicleType,
//       int? year,
//       int? seats,
//       String? fuelType}) async {
//     final Map<String, String> queryParams = {};
//     if (limit != null) queryParams['limit'] = limit.toString();
//     if (make != null) queryParams['make'] = make;
//     if (page != null) queryParams['page'] = page.toString();
//     if (price != null) queryParams['price'] = price;
//     if (vehicleId != null) queryParams['vehicleId'] = vehicleId;
//     if (hostId != null) queryParams['hostId'] = hostId;
//     if (startDate != null) queryParams['start_date'] = startDate;
//     if (endDate != null) queryParams['end_date'] = endDate;
//     if (city != null) queryParams['city'] = city;
//     if (vehicleType != null) queryParams['vehicle_type'] = vehicleType;
//     if (year != null) {
//       queryParams['year'] =
//           year.toString(); // Add year query parameter if provided.
//     }
//     if (seats != null) queryParams['seats'] = seats.toString();
//     if (fuelType != null) {
//       queryParams['fuel_type'] =
//           fuelType; // Add fuel type query parameter if provided.
//     }
//     print(
//         "Query Params: $queryParams"); // This should include 'hostId' as expected

//     print(queryParams.values);

//     final uri = Uri.parse(
//             '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/filter')
//         .replace(queryParameters: queryParams);

//     try {
//       final response = await http.get(uri);
//       print("Reponse from vehicle fetch and filter: ${response.statusCode}");
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);

//         if (data['success']) {
//           List<Vehicle> vehicles = (data['data']['vehicles'] as List)
//               .map((vehicleJson) => Vehicle.fromJson(vehicleJson))
//               .toList();

//           int totalCount = data["data"]["totalCount"];
//           String? nextPageUrl = data["data"]["nextPageUrl"];
//           return VehicleResponse(
//             vehicles: vehicles,
//             totalCount: totalCount,
//             nextPageUrl: nextPageUrl,
//           );
//         } else {
//           throw Exception(data['message']);
//         }
//       } else {
//         throw Exception('Failed to fetch vehicles: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching vehicles: $e');
//     }
//   }

//   Future<http.Response> addFavoriteVehicle(String vehicleId) async {
//     // Get the access token
//     final accessToken = await AuthService.getAccessToken();

//     if (accessToken == null) {
//       throw Exception("Access token is missing.");
//     }
//     final response = await http.post(
//       Uri.parse('${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//       body: jsonEncode({
//         'vehicle_id': vehicleId,
//       }),
//     );

//     return response;
//   }

//   Future<http.Response> deleteFavoriteVehicle(String favoriteVehicleId) async {
//     final accessToken = await AuthService.getAccessToken();

//     if (accessToken == null) {
//       throw Exception("Access token is missing.");
//     }
//     final response = await http.delete(
//       Uri.parse(
//           '${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite/$favoriteVehicleId'), // Ensure the ID is appended correctly
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//     );

//     return response;
//   }

//   Future<List<FavoriteVehicle>?> fetchFavoriteVehicles() async {
//     final accessToken = await AuthService.getAccessToken();
//     if (accessToken == null) {
//       throw Exception("Access token is missing.");
//     }

//     final response = await http.get(
//       Uri.parse('${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       if (jsonResponse['success']) {
//         return (jsonResponse['data'] as List)
//             .map((vehicleData) => FavoriteVehicle.fromJson(vehicleData))
//             .toList();
//       } else {
//         throw Exception("Failed to fetch favorites.");
//       }
//     } else {
//       throw Exception(
//           "Failed to fetch favorites. Status code: ${response.statusCode}");
//     }
//   }

//   Future<http.Response> deleteVehicle(String vehicleId) async {
//     final accessToken = await AuthService.getAccessToken();
//     if (accessToken == null) {
//       throw Exception("Access token is missing.");
//     }
//     final response = await http.delete(
//       Uri.parse(
//           '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/$vehicleId'), // Ensure the ID is appended correctly
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//     return response;
//   }
// }

import 'dart:convert';
import 'package:ajar/models/vehicle/favoriteVehicle/favorite_vehicle.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/models/vehicle/vehicle_response.dart';
import 'package:ajar/services/authentication/auth_servcies.dart';
import 'package:ajar/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class VehicleService {
  // Default method to generate headers
  Map<String, String> _generateHeaders({String? accessToken}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  // Method to create a vehicle
  Future<http.Response> createVehicle(Vehicle vehicleData) async {
    String? accessToken = await AuthService.getAccessToken();
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/');

    try {
      final response = await http.post(
        url,
        headers: _generateHeaders(accessToken: accessToken),
        body: jsonEncode(vehicleData),
      );
      print(
          "Response from vehicle service class: ${response.statusCode} ${response.body}");
      return response;
    } catch (e) {
      print('Error during vehicle registration: $e');
      throw Exception('Failed to register vehicle');
    }
  }

  Future<http.Response> uploadVehiclePictures(
      String vehicleId, List<XFile> images) async {
    final accessToken = await AuthService.getAccessToken();
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/pictures/$vehicleId');

    try {
      final request = http.MultipartRequest('PATCH', url)
        ..headers.addAll(_generateHeaders(accessToken: accessToken));

      // Add images to the request
      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath('pictures[]', image.path),
        );
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      return responseData;
    } catch (e) {
      print("Error uploading vehicle pictures: $e");
      throw Exception("Failed to upload images");
    }
  }

  Future<http.Response> updateVehicle(
      Vehicle vehicleData, String vehicleId) async {
    String? accessToken = await AuthService.getAccessToken();
    final url = Uri.parse(
        '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/$vehicleId');

    try {
      final response = await http.patch(
        url,
        headers: _generateHeaders(accessToken: accessToken),
        body: jsonEncode(vehicleData),
      );
      print(
          "Response from vehicle update service class: ${response.statusCode} ${response.body}");
      return response;
    } catch (e) {
      print('Error during vehicle updation: $e');
      throw Exception('Failed to update vehicle');
    }
  }

  Future<VehicleResponse> fetchVehicles({
    int? limit,
    String? make,
    int? page,
    String? price,
    String? vehicleId,
    String? hostId,
    String? startDate,
    String? endDate,
    String? city,
    String? vehicleType,
    int? year,
    int? seats,
    String? fuelType,
  }) async {
    final Map<String, String> queryParams = {};
    if (limit != null) queryParams['limit'] = limit.toString();
    if (make != null) queryParams['make'] = make;
    if (page != null) queryParams['page'] = page.toString();
    if (price != null) queryParams['price'] = price;
    if (vehicleId != null) queryParams['vehicleId'] = vehicleId;
    if (hostId != null) queryParams['hostId'] = hostId;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (city != null) queryParams['city'] = city;
    if (vehicleType != null) queryParams['vehicle_type'] = vehicleType;
    if (year != null) {
      queryParams['year'] = year.toString();
    }
    if (seats != null) queryParams['seats'] = seats.toString();
    if (fuelType != null) {
      queryParams['fuel_type'] = fuelType;
    }

    final uri = Uri.parse(
            '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/filter')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: _generateHeaders());
      print("Response from vehicle fetch and filter: ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          List<Vehicle> vehicles = (data['data']['vehicles'] as List)
              .map((vehicleJson) => Vehicle.fromJson(vehicleJson))
              .toList();

          int totalCount = data["data"]["totalCount"];
          String? nextPageUrl = data["data"]["nextPageUrl"];
          return VehicleResponse(
            vehicles: vehicles,
            totalCount: totalCount,
            nextPageUrl: nextPageUrl,
          );
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch vehicles: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching vehicles: $e');
    }
  }

  Future<http.Response> addFavoriteVehicle(String vehicleId) async {
    final accessToken = await AuthService.getAccessToken();
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite'),
      headers: _generateHeaders(accessToken: accessToken),
      body: jsonEncode({
        'vehicle_id': vehicleId,
      }),
    );

    return response;
  }

  Future<http.Response> deleteFavoriteVehicle(String favoriteVehicleId) async {
    final accessToken = await AuthService.getAccessToken();
    final response = await http.delete(
      Uri.parse(
          '${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite/$favoriteVehicleId'),
      headers: _generateHeaders(accessToken: accessToken),
    );

    return response;
  }

  Future<List<FavoriteVehicle>?> fetchFavoriteVehicles() async {
    final accessToken = await AuthService.getAccessToken();
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.userApiVehiclePath}/favorite'),
      headers: _generateHeaders(accessToken: accessToken),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        return (jsonResponse['data'] as List)
            .map((vehicleData) => FavoriteVehicle.fromJson(vehicleData))
            .toList();
      } else {
        throw Exception("Failed to fetch favorites.");
      }
    } else {
      throw Exception(
          "Failed to fetch favorites. Status code: ${response.statusCode}");
    }
  }

  Future<http.Response> deleteVehicle(String vehicleId) async {
    final accessToken = await AuthService.getAccessToken();
    final response = await http.delete(
      Uri.parse(
          '${Constants.baseUrl}${Constants.userApiVehiclePath}/vehicle/$vehicleId'),
      headers: _generateHeaders(accessToken: accessToken),
    );
    return response;
  }
}
