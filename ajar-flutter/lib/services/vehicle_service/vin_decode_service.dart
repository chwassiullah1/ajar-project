// // VIN Decoding APIs
// // NHTSA (National Highway Traffic Safety Administration) VIN Decoder:

// // Free service provided by the U.S. government.
// // Decodes the basic information of a car (make, model, year, manufacturer, etc.).
// // Endpoint: https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin/{VIN}?format=json
// // Example Request:
// // bash
// // Copy code
// // https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin/1HGCM82633A123456?format=json
// // This will return details about the vehicle associated with the VIN.
// // VinAudit API:

// // Paid service but offers more comprehensive details, including vehicle history reports, mileage, title records, accidents, and more.
// // Endpoint: https://api.vinaudit.com/query.php?key=YOUR_API_KEY&vin={VIN}
// // API Documentation: VinAudit API
// // Carfax API:

// // Carfax is known for providing detailed vehicle history reports.
// // You would need to apply for access, as this is a paid service.
// // Website: Carfax API
// // VINDecoder API:

// // Provides basic information like make, model, year, and additional features such as engine and drivetrain.
// // API Endpoint: https://vindecoder.p.rapidapi.com/decode_vin?vin={VIN}
// // You can use it with RapidAPI.


//  import 'dart:convert';
//  import 'package:http/http.dart' as http;

// import '../../models/car_model.dart';

// // class VinDecoderService {
// //   final String baseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin';

// //   Future<Map<String, dynamic>> fetchCarDetails(String vin) async {
// //     final response = await http.get(Uri.parse('$baseUrl/$vin?format=json'));

// //     if (response.statusCode == 200) {
// //       // Decode JSON response and extract car details
// //       final data = jsonDecode(response.body);
// //       if (data['Results'] != null) {
// //         return {
// //           'make': data['Results'].firstWhere((item) => item['Variable'] == 'Make', orElse: () => {})['Value'] ?? '',
// //           'model': data['Results'].firstWhere((item) => item['Variable'] == 'Model', orElse: () => {})['Value'] ?? '',
// //           'year': data['Results'].firstWhere((item) => item['Variable'] == 'Model Year', orElse: () => {})['Value'] ?? '',
// //           // Add more fields as necessary
// //         };
// //       }
// //       return {};
// //     } else {
// //       throw Exception('Failed to load car details');
// //     }
// //   }
// // }

// class VinDecoderService {
//   final String baseUrl = 'https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVin';

//   Future<CarDetails> fetchCarDetails(String vin) async {
//     final response = await http.get(Uri.parse('$baseUrl/$vin?format=json'));

//     if (response.statusCode == 200) {
//       // Decode JSON response and extract car details
//       final data = jsonDecode(response.body);

//       if (data['Results'] != null) {
//         // Extract values for make, model, year, and engine type
//         String make = data['Results'].firstWhere((item) => item['Variable'] == 'Make', orElse: () => {})['Value'] ?? 'Unknown';
//         String model = data['Results'].firstWhere((item) => item['Variable'] == 'Model', orElse: () => {})['Value'] ?? 'Unknown';
//         String year = data['Results'].firstWhere((item) => item['Variable'] == 'Model Year', orElse: () => {})['Value'] ?? 'Unknown';
//         String engineType = data['Results'].firstWhere((item) => item['Variable'] == 'Engine Configuration', orElse: () => {})['Value'] ?? 'Unknown';

//         // Return an instance of CarDetails
//         return CarDetails(make: make, model: model, year: year, engineType: engineType);
//       }
//       return CarDetails(make: 'Unknown', model: 'Unknown', year: 'Unknown', engineType: 'Unknown');
//     } else {
//       throw Exception('Failed to load car details');
//     }
//   }
// }