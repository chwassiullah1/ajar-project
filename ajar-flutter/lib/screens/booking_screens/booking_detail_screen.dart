import 'package:ajar/models/booking/booking.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_details_screen/network_image_carousel.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late final String startDate;
  late final String endDate;
  late final int totalDays;
  late final double vehiclePrice;
  late final String vehicleInfo;
  late final String createdAtDate;
  late final String createdAtTime;
  late final double totalDeliveryCost;

  @override
  void initState() {
    super.initState();
    startDate = formatDate(widget.booking.startDate.toString());
    endDate = formatDate(widget.booking.endDate.toString());
    totalDays = calculateTotalDays(startDate, endDate);
    vehiclePrice = double.parse(widget.booking.vehicle!.price);
    vehicleInfo =
        "${widget.booking.vehicle!.make} ${widget.booking.vehicle!.model} ${widget.booking.vehicle!.year}";
    createdAtDate =
        formatDateInMonthNameFormat(widget.booking.createdAt.toString());
    createdAtTime = formatTime(widget.booking.createdAt.toString());
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 14, color: fMainColor, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details", style: TextStyle(fontSize: 22)),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            // Move NetworkImageCarousel outside the padding
            NetworkImageCarousel(
              networkImages: widget.booking.vehicle!.pictures ??
                  ['assets/vehicles/1.png'], // Provide URLs list
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.booking.vehicle!.make} ${widget.booking.vehicle!.model} ${widget.booking.vehicle!.year}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            widget.booking.vehicle!.transmissionType,
                            style:
                                const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "\$${widget.booking.vehicle!.price}", // Price part
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: fMainColor,
                                  ),
                                ),
                                TextSpan(
                                  text: "/day",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: isDarkMode ? Colors.grey : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Row(
                                children: [
                                  Icon(IconlyLight.star,
                                      color: Colors.orange, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    "3.4",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle("Booking Creation Date"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.timeCircle),
                    title: Text(createdAtDate),
                    subtitle: Text(createdAtTime),
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle("Total Number of Days And Date"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.calendar),
                    title: Text("$totalDays Days"),
                    subtitle: Text(
                        "From ${formatDateInMonthNameFormat(widget.booking.startDate.toString())} To ${formatDateInMonthNameFormat(widget.booking.endDate.toString())}"),
                  ),
                  _buildSectionTitle("Vehicle Total Charges"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.plus),
                    title: Text(
                        "${widget.booking.vehicle!.make} ${widget.booking.vehicle!.model} ${widget.booking.vehicle!.year}"),
                    subtitle: Text(
                        "Vehicle Cost ${widget.booking.invoice.invoice.vehicle.calculation} = ${widget.booking.invoice.invoice.vehicle.total}\$"),
                  ),
                  _buildSectionTitle("Driver Availability and Charges"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.profile),
                    title:
                        Text(widget.booking.withDriver ? "Yes" : "Not Available"),
                    subtitle: widget.booking.withDriver
                        ? Text(
                            "Driver Cost ${widget.booking.invoice.invoice.driver.calculation} = ${widget.booking.invoice.invoice.driver.total}\$")
                        : null,
                  ),
                  _buildSectionTitle("Delivery Availability and Charges"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.activity),
                    title: Text(
                        widget.booking.withDelivery ? "Yes" : "Not Available"),
                    subtitle: widget.booking.withDelivery
                        ? Text(
                            "Charges For Delivery ${widget.booking.invoice.invoice.delivery.calculation} = ${widget.booking.invoice.invoice.delivery.total}\$",
                            style: const TextStyle(fontSize: 12))
                        : null,
                  ),
                  _buildSectionTitle("Booking Status"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.infoSquare),
                    title: Text(widget.booking.status.capitalize()),
                  ),
                  _buildSectionTitle("Booking Total Bill"),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(IconlyLight.chart),
                    title: const Text("Calculations"),
                    subtitle: Text(
                      "${widget.booking.invoice.invoice.vehicle.total}\$"
                      "${widget.booking.withDriver ? " + ${widget.booking.invoice.invoice.driver.total}\$" : ""}"
                      "${widget.booking.withDelivery ? " + ${widget.booking.invoice.invoice.delivery.total}\$" : ""}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      "${widget.booking.totalPrice}\$",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
