// Step-by-Step Solution Using CarQuery API
// Register for an API Key: First, you'll need to register for an API key from CarQuery API.

// Fetch Car Models by Brand: Once you have the API key, you can make API calls to fetch car models for any selected brand.

// API Request for Car Models:

// Use the CarQuery API endpoint for models:
// Example request:
// Copy code
// https://www.carqueryapi.com/api/0.3/?cmd=getModels&make=toyota
// You replace "toyota" with the selected car brand.
// Integrating API Call in Flutter: You can make the API request using the http package in Flutter. Here's how you can implement it:

import 'dart:async';
import 'dart:convert';
import 'package:ajar/providers/vehicles/car_models.dart';
import 'package:http/http.dart' as http;

class GetVehicleModelsService {
  final String baseUrl = 'https://www.carqueryapi.com/api/0.3/';

  Future<List<CarModel>> fetchCarModels(String brand) async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl?cmd=getModels&make=$brand'),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out. Please try again.');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Models'] == null) {
          throw Exception('No models found for the brand $brand.');
        }

        return (data['Models'] as List)
            .map((json) => CarModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load car models. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching car models for $brand: $e');
      throw Exception('Failed to fetch car models: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCarDetails(String modelId) async {
    final response = await http
        .get(Uri.parse('$baseUrl?cmd=getModelDetails&model_id=$modelId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load car details');
    }
  }
}
