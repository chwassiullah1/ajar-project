import 'package:ajar/models/booking/booking_invoice.dart';
import 'package:ajar/models/booking/renter_address.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';

class Booking {
  String id;
  String renterId;
  String hostId;
  String vehicleId;
  DateTime startDate;
  DateTime endDate;
  String totalPrice;
  String status;
  BookingInvoice invoice;
  RenterAddress renterAddress;
  bool withDriver;
  bool withDelivery;
  DateTime createdAt;
  DateTime updatedAt;
  Vehicle? vehicle;

  Booking({
    required this.id,
    required this.renterId,
    required this.hostId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.invoice,
    required this.renterAddress,
    required this.withDriver,
    required this.withDelivery,
    required this.createdAt,
    required this.updatedAt,
    this.vehicle,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        renterId: json["renter_id"],
        hostId: json["host_id"],
        vehicleId: json["vehicle_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        totalPrice: json["total_price"],
        status: json["status"],
        invoice: BookingInvoice.fromJson(json["invoice"]),
        renterAddress: RenterAddress.fromJson(json["renter_address"]),
        withDriver: json["with_driver"],
        withDelivery: json["with_delivery"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        vehicle: Vehicle.fromJsonNewCreateVehicle(json["vehicle"]),
      );

  factory Booking.fromJsonCreatingBooking(Map<String, dynamic> json) => Booking(
        id: json["id"],
        renterId: json["renter_id"],
        hostId: json["host_id"],
        vehicleId: json["vehicle_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        totalPrice: json["total_price"],
        status: json["status"],
        invoice: BookingInvoice.fromJson(json["invoice"]),
        renterAddress: RenterAddress.fromJson(json["renter_address"]),
        withDriver: json["with_driver"],
        withDelivery: json["with_delivery"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "renter_id": renterId,
        "host_id": hostId,
        "vehicle_id": vehicleId,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "total_price": totalPrice,
        "status": status,
        "invoice": invoice.toJson(),
        "renter_address": renterAddress.toJson(),
        "with_driver": withDriver,
        "with_delivery": withDelivery,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "vehicle": vehicle!.toJson(),
      };
}
