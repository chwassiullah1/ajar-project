import 'dart:convert';
import 'package:ajar/models/booking/booking.dart';
import 'package:ajar/models/booking/fetch_bookings.dart';
import 'package:ajar/models/booking/renter_address.dart';
import 'package:ajar/services/authentication/auth_servcies.dart';
import 'package:ajar/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class BookingService {
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

  Future<http.Response> createBooking({
    required String vehicleId,
    required String startDate,
    required String endDate,
    required bool withDriver,
    required bool withDelivery,
    required int distanceForDelivery,
    required RenterAddress renterAddress,
  }) async {
    String? accessToken = await AuthService.getAccessToken();

    if (accessToken == null) {
      throw Exception('No access token found');
    }
    try {
      final response = await http.post(
        Uri.parse("${Constants.baseUrl}${Constants.userApiBookinPath}"),
        headers: _generateHeaders(accessToken: accessToken),
        body: jsonEncode(
          {
            "vehicle_id": vehicleId,
            "start_date": startDate,
            "end_date": endDate,
            "with_driver": withDriver,
            "with_delivery": withDelivery,
            "distance_for_delivery": distanceForDelivery,
            "renter_address": renterAddress,
          },
        ),
      );
      return response; // Return the raw HTTP response
    } catch (e) {
      throw Exception("Failed to create booking: $e");
    }
  }

  // Method to parse booking data from response
  Booking parseBookingData(String responseBody) {
    final Map<String, dynamic>? jsonData =
        jsonDecode(responseBody)['data']['booking'][0];

    return Booking.fromJsonCreatingBooking(jsonData!);
  }

  Future<FetchBookings?> fetchBookings() async {
    try {
      String? accessToken = await AuthService.getAccessToken();

      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse("${Constants.baseUrl}${Constants.userApiBookinPath}"),
        headers: _generateHeaders(accessToken: accessToken),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Check if the data field is an empty list
        if (jsonData['data'] is List && (jsonData['data'] as List).isEmpty) {
          // Return an empty FetchBookings object if there are no bookings
          return FetchBookings(hostBookings: [], renterBookings: []);
        }

        // Parse the data as a map if it's not an empty list
        return FetchBookings.fromJson(jsonData['data']);
      } else {
        print('Failed to fetch bookings. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching bookings: $e');
      return null;
    }
  }
}
