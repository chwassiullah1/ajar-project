import 'package:ajar/models/booking/delivery.dart';

class InvoiceInvoice {
  final DateTime startDate;
  final DateTime endDate;
  final String days;
  final Delivery vehicle;
  final Delivery driver;
  final Delivery delivery;
  final int totalCost;

  InvoiceInvoice({
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.vehicle,
    required this.driver,
    required this.delivery,
    required this.totalCost,
  });

  factory InvoiceInvoice.fromJson(Map<String, dynamic> json) => InvoiceInvoice(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        days: json["days"].toString(),
        vehicle: Delivery.fromJson(json["vehicle"]),
        driver: Delivery.fromJson(json["driver"]),
        delivery: Delivery.fromJson(json["delivery"]),
        totalCost: json["totalCost"],
      );

  Map<String, dynamic> toJson() => {
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "days": days,
        "vehicle": vehicle.toJson(),
        "driver": driver.toJson(),
        "delivery": delivery.toJson(),
        "totalCost": totalCost,
      };
}
