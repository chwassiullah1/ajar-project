import 'package:ajar/models/booking/booking.dart';

class FetchBookings {
  List<Booking> hostBookings;
  List<Booking> renterBookings;

  FetchBookings({
    required this.hostBookings,
    required this.renterBookings,
  });

  factory FetchBookings.fromJson(Map<String, dynamic> json) {
    return FetchBookings(
      hostBookings: (json['hostBookings'] as List<dynamic>?)
              ?.map((item) => Booking.fromJson(item))
              .toList() ??
          [],
      renterBookings: (json['renterBookings'] as List<dynamic>?)
              ?.map((item) => Booking.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "hostBookings": hostBookings.map((booking) => booking.toJson()).toList(),
      "renterBookings":
          renterBookings.map((booking) => booking.toJson()).toList(),
    };
  }
}
