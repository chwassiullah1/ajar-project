import 'package:ajar/models/auth/user_model.dart';
import 'package:ajar/models/reviews/reviews_model.dart';
import 'package:ajar/utils/api_constnsts.dart';

class Vehicle {
  String? id;
  String? hostId;
  String latitude;
  String longitude;
  String fullAddress;
  String city;
  String vinNumber;
  String make;
  String model;
  int year;
  String vehicleType;
  String color;
  String reasonForHosting;
  String startDate;
  String endDate;
  String transmissionType;
  String fuelType;
  int mileage;
  int seats;
  String engineSize;
  String price;
  String driverPrice;
  bool deliveryAvailable;
  String? deliveryPrice;
  List<String>? pictures;
  String registrationNumber;
  String licensePlate;
  bool? isAvailable;
  String description;
  bool isAc;
  bool isGps;
  bool isUsb;
  bool isCharger;
  bool isBluetooth;
  bool isSunroof;
  bool isPushButtonStart;
  String driverAvailability;
  String? searchTerm;
  String? createdAt;
  String? updatedAt;
  UserModel? host;
  bool? isFavorite;
  List<Review>? reviews; // Can be an empty list
  String? averageRating;

  // Main constructor
  Vehicle({
    this.id,
    this.hostId,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.city,
    required this.vinNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    required this.color,
    required this.reasonForHosting,
    required this.startDate,
    required this.endDate,
    required this.transmissionType,
    required this.fuelType,
    required this.mileage,
    required this.seats,
    required this.engineSize,
    required this.price,
    required this.driverPrice,
    required this.deliveryAvailable,
    this.deliveryPrice,
    required this.pictures,
    required this.registrationNumber,
    required this.licensePlate,
    this.isAvailable,
    required this.description,
    required this.isAc,
    required this.isGps,
    required this.isUsb,
    required this.isCharger,
    required this.isBluetooth,
    required this.isSunroof,
    required this.isPushButtonStart,
    required this.driverAvailability,
    this.reviews,
    this.searchTerm,
    this.createdAt,
    this.updatedAt,
    this.host,
    this.isFavorite = false,
    this.averageRating,
  });

  // Factory constructor with host field
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      hostId: json['host_id'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      fullAddress: json['full_address'],
      city: json['city'],
      vinNumber: json['vin_number'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      vehicleType: json['vehicle_type'],
      color: json['color'],
      reasonForHosting: json['reason_for_hosting'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      transmissionType: json['transmission_type'],
      fuelType: json['fuel_type'],
      mileage: json['mileage'],
      seats: json['seats'],
      engineSize: json['engine_size'],
      price: json['price'].toString(),
      driverPrice: json['driver_price'].toString(),
      deliveryAvailable: json['delivery_available'],
      deliveryPrice: json['delivery_price'].toString(),
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
              .map((picture) => "${Constants.baseUrl}$picture")
              .toList()
          : null,
      registrationNumber: json['registration_number'],
      licensePlate: json['license_plate'],
      isAvailable: json['is_available'],
      description: json['description'],
      isAc: json['is_ac'],
      isGps: json['is_gps'],
      isUsb: json['is_usb'],
      isCharger: json['is_charger'],
      isBluetooth: json['is_bluetooth'],
      isSunroof: json['is_sunroof'],
      isPushButtonStart: json['is_push_button_start'],
      driverAvailability: json['driver_availability'],
      searchTerm: json['search_term'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      host: UserModel.fromJson(
        json['host'],
      ),
      reviews: json['reviews'] != null
          ? List<Review>.from(
              json['reviews'].map(
                (review) => Review.fromJson(review),
              ),
            )
          : [],
      averageRating: json['average_rating'].toString(),
    );
  }

  // Factory constructor without host field
  factory Vehicle.fromJsonWithoutHost(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      hostId: json['host_id'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      fullAddress: json['full_address'],
      city: json['city'],
      vinNumber: json['vin_number'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      vehicleType: json['vehicle_type'],
      color: json['color'],
      reasonForHosting: json['reason_for_hosting'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      transmissionType: json['transmission_type'],
      fuelType: json['fuel_type'],
      mileage: json['mileage'],
      seats: json['seats'],
      engineSize: json['engine_size'],
      price: json['price'].toString(),
      driverPrice: json['driver_price'].toString(),
      deliveryAvailable: json['delivery_available'],
      deliveryPrice: json['delivery_price'].toString(),
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
              .map((picture) => "${Constants.baseUrl}$picture")
              .toList()
          : null,
      registrationNumber: json['registration_number'],
      licensePlate: json['license_plate'],
      isAvailable: json['is_available'],
      description: json['description'],
      isAc: json['is_ac'],
      isGps: json['is_gps'],
      isUsb: json['is_usb'],
      isCharger: json['is_charger'],
      isBluetooth: json['is_bluetooth'],
      isSunroof: json['is_sunroof'],
      isPushButtonStart: json['is_push_button_start'],
      driverAvailability: json['driver_availability'],
      searchTerm: json['search_term'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      host: UserModel.fromJson(json['host']),
      reviews: json['reviews'] != null
          ? List<Review>.from(
              json['reviews'].map((review) => Review.fromJson(review)))
          : [],
      averageRating: json['average_rating'].toString(),
    );
  }

  // Factory constructor without host field
  factory Vehicle.fromJsonNewCreateVehicle(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      hostId: json['host_id'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      fullAddress: json['full_address'],
      city: json['city'],
      vinNumber: json['vin_number'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      vehicleType: json['vehicle_type'],
      color: json['color'],
      reasonForHosting: json['reason_for_hosting'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      transmissionType: json['transmission_type'],
      fuelType: json['fuel_type'],
      mileage: json['mileage'],
      seats: json['seats'],
      engineSize: json['engine_size'],
      price: json['price'].toString(),
      driverPrice: json['driver_price'].toString(),
      deliveryAvailable: json['delivery_available'],
      deliveryPrice: json['delivery_price'].toString(),
      pictures: json['pictures'] != null
          ? List<String>.from(json['pictures'])
              .map((picture) => "${Constants.baseUrl}$picture")
              .toList()
          : null,
      registrationNumber: json['registration_number'],
      licensePlate: json['license_plate'],
      isAvailable: json['is_available'],
      description: json['description'],
      isAc: json['is_ac'],
      isGps: json['is_gps'],
      isUsb: json['is_usb'],
      isCharger: json['is_charger'],
      isBluetooth: json['is_bluetooth'],
      isSunroof: json['is_sunroof'],
      isPushButtonStart: json['is_push_button_start'],
      driverAvailability: json['driver_availability'],
      searchTerm: json['search_term'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "host_id": hostId,
        "latitude": latitude,
        "longitude": longitude,
        "full_address": fullAddress,
        "vin_number": vinNumber,
        "city": city,
        "make": make,
        "model": model,
        "year": year,
        "vehicle_type": vehicleType,
        "color": color,
        "reason_for_hosting": reasonForHosting,
        "start_date": startDate,
        "end_date": endDate,
        "transmission_type": transmissionType,
        "fuel_type": fuelType,
        "mileage": mileage,
        "seats": seats,
        "engine_size": engineSize,
        "pictures": pictures,
        "registration_number": registrationNumber,
        "license_plate": licensePlate,
        "is_available": isAvailable,
        "description": description,
        "driver_availability": driverAvailability,
        "driver_price": driverPrice,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "delivery_price": deliveryPrice,
        "delivery_available": deliveryAvailable,
        "is_ac": isAc,
        "is_gps": isGps,
        "is_usb": isUsb,
        "is_charger": isCharger,
        "is_bluetooth": isBluetooth,
        "is_sunroof": isSunroof,
        "is_push_button_start": isPushButtonStart,
        "price": price
      };
}
