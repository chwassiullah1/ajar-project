import 'package:ajar/models/vehicle/vehicle_model.dart';

class VehicleResponse {
  final List<Vehicle>? vehicles;
  final int totalCount;
  final String? nextPageUrl;

  VehicleResponse({
    required this.vehicles,
    required this.totalCount,
    this.nextPageUrl,
  });
}