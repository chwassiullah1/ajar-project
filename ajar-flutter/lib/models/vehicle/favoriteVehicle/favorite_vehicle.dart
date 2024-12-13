import 'package:ajar/models/vehicle/vehicle_model.dart';

class FavoriteVehicle {
  String id;
  String userId;
  String vehicleId;
  String createdAt;
  final Vehicle? vehicle; // The Vehicle model

  FavoriteVehicle({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.createdAt,
    this.vehicle,
  });

  factory FavoriteVehicle.fromJson(Map<String, dynamic> json) {
    return FavoriteVehicle(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      createdAt: json['created_at'],
      vehicle:  Vehicle.fromJsonWithoutHost(
          json['vehicle']), // Parse the nested Vehicle
    );
  }

  factory FavoriteVehicle.fromJsonAddToFavorite(Map<String, dynamic> json) {
    return FavoriteVehicle(
      id: json['id'],
      userId: json['user_id'],
      vehicleId: json['vehicle_id'],
      createdAt: json['created_at'],
    );
  }
}
