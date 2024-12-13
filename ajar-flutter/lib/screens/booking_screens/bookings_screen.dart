import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/models/booking/booking.dart';
import 'package:ajar/providers/booking/booking_provider.dart';
import 'package:ajar/screens/booking_screens/booking_detail_screen.dart';
import 'package:ajar/screens/booking_screens/booking_list_item_shimmer.dart';
import 'package:ajar/screens/vehicle_screens/searched_detail_screen/all_vehicle_searched_screen.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    // Fetch vehicles when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).loadBookings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Bookings",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(height: 5),
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(text: "My Bookings"),
                        Tab(text: "Hosts Booking"),
                      ],
                      labelColor: isDarkMode ? Colors.white : fMainColor,
                      unselectedLabelColor:
                          isDarkMode ? Colors.grey : Colors.grey,
                      indicatorColor: isDarkMode ? Colors.white : fMainColor,
                    ),
                    Expanded(
                      child: Consumer<BookingProvider>(
                        builder: (context, bookingProvider, _) {
                          if (bookingProvider.isBookingFetching) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: BookingListItemShimmer());
                              },
                            );
                          }
                          return TabBarView(
                            children: [
                              // My Bookings Tab
                              bookingProvider.fetchBookings?.renterBookings
                                          .isNotEmpty ??
                                      false
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      itemCount: bookingProvider
                                          .fetchBookings!.renterBookings.length,
                                      itemBuilder: (context, index) {
                                        final booking = bookingProvider
                                            .fetchBookings!
                                            .renterBookings[index];

                                        return getBookingWidget(
                                          context,
                                          booking,
                                        );
                                      },
                                    )
                                  : _emptyBookingsView("No upcoming trips yet!",
                                      "Explore the Ajar to book your next trip.",
                                      () {
                                      Navigator.of(context).pushReplacement(
                                        SlidePageRoute(
                                          page:
                                              const AllSearchedVehicleScreen(),
                                        ),
                                      );
                                    }, "Start Searchings", context),

                              // Host Bookings Tab
                              bookingProvider.fetchBookings?.hostBookings
                                          .isNotEmpty ??
                                      false
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      itemCount: bookingProvider
                                          .fetchBookings!.hostBookings.length,
                                      itemBuilder: (context, index) {
                                        final booking = bookingProvider
                                            .fetchBookings!.hostBookings[index];
                                        return getBookingWidget(
                                          context,
                                          booking,
                                        );
                                      },
                                    )
                                  : _emptyBookingsView(
                                      "No one has booked your vehicle!",
                                      "Explore the Ajar to learn hosting of your vehicles.",
                                      () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (_) => const MoreScreen(),
                                      //   ),
                                      // );
                                    }, "Start Hosting", context),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyBookingsView(String title, String subtitle,
      VoidCallback onPressed, String buttonText, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/trip.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 20),
        if (buttonText != "Start Hosting")
          CustomGradientButton(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            text: buttonText,
            onPressed: onPressed,
          ),
      ],
    );
  }

  // Define colors for the dark mode shimmer effect
  final darkBaseColor =
      fdarkBlue.withOpacity(0.7); // Slightly lighter fdarkBlue
  final darkHighlightColor = fMainColor.withOpacity(0.5); // Faded main color
  final darkBackgroundColor =
      fdarkBlue.withOpacity(0.9); // Darker base for backgrounds

  Widget getBookingWidget(BuildContext context, Booking booking) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(
            page: BookingDetailScreen(booking: booking),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: CardyContainer(
          color: isDarkMode ? fdarkBlue : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          borderRadius: BorderRadius.circular(10),
          spreadRadius: 0,
          blurRadius: 1,
          shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: booking.vehicle!.pictures != null &&
                          booking.vehicle!.pictures!.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode ? fMainColor : Colors.grey.shade300,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: booking.vehicle!.pictures![0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: isDarkMode
                                  ? darkBaseColor
                                  : Colors.grey.shade300,
                              highlightColor: isDarkMode
                                  ? darkHighlightColor
                                  : Colors.grey.shade100,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                color: isDarkMode
                                    ? darkBackgroundColor
                                    : Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : Image.asset(
                          'assets/vehicles/1.png', // Default image if pictures are null or empty
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for name and rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${booking.vehicle!.make} ${booking.vehicle!.model}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                            "${calculateTotalDays(formatDate(DateTime.parse(booking.startDate.toString()).toString()), formatDate(DateTime.parse(booking.endDate.toString()).toString()))} Day"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    // Row for transmission type and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.status == 'pending'
                              ? 'Pending'
                              : booking.status,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\$${booking.totalPrice}", // Price part
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color:
                                      fMainColor, // Your main color for the price
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
