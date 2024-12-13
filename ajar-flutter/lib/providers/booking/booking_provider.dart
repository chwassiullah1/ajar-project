// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:ajar/models/booking/booking.dart';
import 'package:ajar/models/booking/fetch_bookings.dart';
import 'package:ajar/models/booking/renter_address.dart';
import 'package:ajar/services/booking_service/booking_service.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  Booking? _booking;
  Booking? get booking => _booking;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String errorMessage = '';

  bool _isBookingFetching = false;
  bool get isBookingFetching => _isBookingFetching;

  // Create a booking and handle the response
  Future<int> createBooking({
    required String vehicleId,
    required String startDate,
    required String endDate,
    required bool withDriver,
    required bool withDelivery,
    required int distanceForDelivery,
    required RenterAddress renterAddress,
  }) async {
    _isLoading = true;
    notifyListeners();

    BookingService bookingService = BookingService();
    try {
      final response = await bookingService.createBooking(
        vehicleId: vehicleId,
        startDate: startDate,
        endDate: endDate,
        withDriver: withDriver,
        withDelivery: withDelivery,
        distanceForDelivery: distanceForDelivery,
        renterAddress: renterAddress,
      );

      if (response.statusCode == 200) {
        // Parse and store booking data using the model
        _booking = bookingService.parseBookingData(response.body);

        notifyListeners();
      } else {
        // Handle the error
        var responseData = jsonDecode(response.body);
        errorMessage = responseData['message'];
        notifyListeners();
      }

      return response.statusCode; // Return status code
    } catch (e) {
      print(e);
      errorMessage = 'Error creating booking';
      notifyListeners();
      return 500; // Return a custom error code
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  FetchBookings? _fetchBookings;

  FetchBookings? get fetchBookings => _fetchBookings;

  final BookingService _bookingService = BookingService();

  Future<void> loadBookings() async {
    _isBookingFetching = true;
    notifyListeners();

    final result = await _bookingService.fetchBookings();

    if (result != null) {
      _fetchBookings = result;
    } else {
      _fetchBookings = FetchBookings(hostBookings: [], renterBookings: []);
    }

    _isBookingFetching = false;
    notifyListeners();
  }
}
