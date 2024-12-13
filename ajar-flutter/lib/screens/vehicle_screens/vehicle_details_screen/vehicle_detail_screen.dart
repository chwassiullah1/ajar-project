import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/models/chat/conversation.dart';
import 'package:ajar/models/vehicle/favoriteVehicle/favorite_vehicle.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/chatting/chatting_provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/booking_screens/booking_custom_stepper.dart';
import 'package:ajar/screens/chatting_and_notifications/chat_screen.dart';
import 'package:ajar/screens/host_profile_screen/host_profile_details_screen.dart';
import 'package:ajar/screens/profile_updation_screens/profile_details_screen.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/delete_widget_warning_dialogbox.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_review_widget.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_details_screen/detail_row_widget.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_details_screen/network_image_carousel.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_update_screen/vehicle_update_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final vehicleProvider =
        Provider.of<VehicleProvider>(context); // Get the provider

    final authProvider = Provider.of<AuthenticationProvider>(context);

    // Check if the vehicle is hosted by the current user
    bool isHostedByCurrentUser = vehicle.hostId == authProvider.user!.id;

    // Check if vehicle is favorite
    bool isFavorite =
        vehicleProvider.favorites?.any((fav) => fav.vehicleId == vehicle.id) ??
            false;

    // Current date
    DateTime currentDate = DateTime.now();

    // Parse vehicle's end date
    DateTime? vehicleEndDate = DateFormat('yyyy-MM-dd').parse(vehicle.endDate);

    // Check if the vehicle's booking period is still valid
    bool isBookingAvailable = currentDate.isBefore(vehicleEndDate);

    Future<void> handleConversation(
        BuildContext context,
        ChattingProvider chatProvider,
        String hostId,
        String currentUserId) async {
      // First, check if a conversation already exists with the host
      Conversation? existingConversation;

      try {
        existingConversation = chatProvider.conversations.firstWhere(
          (conversation) =>
              conversation.members.contains(currentUserId) &&
              conversation.members.contains(hostId),
        );
      } catch (e) {
        if (e is StateError) {
          existingConversation = null;
        } else {
          rethrow; // Unexpected error, rethrow it
        }
      }

      if (existingConversation != null) {
        // Navigate to the existing conversation
        Navigator.of(context).push(
          SlidePageRoute(
            page: ChatScreen(conversation: existingConversation),
          ),
        );
      } else {
        // No existing conversation, so create a new one
        int statusCode =
            await chatProvider.startConversation(hostId, authProvider.user!.id);

        if (statusCode == 200) {
          // Fetch updated conversations
          await chatProvider.fetchConversations();

          try {
            // Check again for the newly created conversation
            existingConversation = chatProvider.conversations.firstWhere(
              (conversation) =>
                  conversation.members.contains(currentUserId) &&
                  conversation.members.contains(hostId),
            );

            // Navigate to the newly created conversation
            Navigator.of(context).push(
              SlidePageRoute(
                page: ChatScreen(conversation: existingConversation),
              ),
            );
          } catch (e) {
            if (e is StateError) {
              showCustomSnackBar(
                  context,
                  "Conversation created, but couldn't be found in the list.",
                  Colors.red);
            } else {
              rethrow; // Unexpected error, rethrow it
            }
          }
        } else {
          // Handle error if conversation creation failed
          showCustomSnackBar(context,
              chatProvider.errorMessage ?? "Error occurred", Colors.red);
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(IconlyLight.arrowLeft),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    if (isHostedByCurrentUser) ...[
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(IconlyLight.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                SlidePageRoute(
                                  page: VehicleUpdateScreen(vehicle: vehicle),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(IconlyLight.delete),
                            onPressed: () async {
                              showDeleteConfirmationDialog(
                                context,
                                vehicle.id!,
                              );
                            },
                          ),
                        ],
                      )
                    ] else ...[
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? IconlyBold.heart : IconlyLight.heart,
                              color: isFavorite ? Colors.green : fMainColor,
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                // Remove from favorites
                                final favoriteVehicle =
                                    vehicleProvider.favorites!.firstWhere(
                                  (fav) => fav.vehicleId == vehicle.id,
                                  orElse: () => FavoriteVehicle(
                                      id: '',
                                      userId: '',
                                      vehicleId: vehicle.id!,
                                      createdAt: '',
                                      vehicle: vehicle),
                                );
                                await vehicleProvider.removeFavoriteVehicle(
                                    favoriteVehicle.id, context);
                                await vehicleProvider.fetchFavoriteVehicles();
                              } else {
                                // Add to favorites
                                await vehicleProvider.addVehicleToFavorites(
                                    context, vehicle.id!);
                                await vehicleProvider.fetchFavoriteVehicles();
                              }
                            },
                          ),
                          Consumer<ChattingProvider>(
                            builder: (context, chatProvider, child) {
                              return TextButton(
                                onPressed: () async {
                                  await handleConversation(
                                    context,
                                    chatProvider,
                                    vehicle.hostId!,
                                    authProvider.user!.id,
                                  );
                                },
                                child: const Text("Contact"),
                              );
                            },
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Example Usage in another widget
              NetworkImageCarousel(
                networkImages: vehicle.pictures ??
                    ['assets/vehicles/1.png'], // Provide URLs list
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${vehicle.make} ${vehicle.model} ${vehicle.year}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          vehicle.transmissionType,
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
                                text: "\$${vehicle.price}", // Price part
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      fMainColor, // Your main color for the price
                                ),
                              ),
                              TextSpan(
                                text: "/day", // Day part
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.grey
                                      : Colors.grey, // Color for the "day" part
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          children: [
                            Row(
                              children: [
                                Icon(IconlyBold.star,
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
              ),
              const SizedBox(height: 10),
              const Divider(),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vehicle Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: fMainColor),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        vehicle.description,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DetailRow(
                  title: 'Availability Dates',
                  icon1: IconlyLight.calendar,
                  value1:
                      'From ${formatDateInMonthNameFormat(vehicle.startDate)} To ${formatDateInMonthNameFormat(vehicle.endDate)}',
                  icon2: isBookingAvailable == false
                      ? IconlyLight.dangerCircle
                      : null,
                  value2: isBookingAvailable == false
                      ? (isHostedByCurrentUser
                          ? "Your vehicle's availability has expired. Please update the availability dates."
                          : "The booking period for this vehicle has expired.")
                      : null,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: fMainColor,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        const Icon(IconlyLight.location, size: 24),
                        const SizedBox(width: 15),
                        Expanded(
                          // Wrap Column with Expanded to handle space better
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "City ${vehicle.city}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                vehicle.fullAddress,
                                maxLines:
                                    3, // Limits to 3 lines; adjust as needed
                                overflow: TextOverflow
                                    .ellipsis, // Shows ellipsis if text overflows
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14), // Adds spacing between lines
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DetailRow(
                  title: 'Driver Options',
                  icon1: IconlyLight.profile,
                  value1: vehicle.driverAvailability,
                  icon2: vehicle.driverAvailability != "Without Driver"
                      ? IconlyLight.infoSquare
                      : null, // Show the price icon only if driver availability is not "Without driver"
                  value2: vehicle.driverAvailability != "Without Driver"
                      ? 'Driver Price Per Day - \$${vehicle.driverPrice}'
                      : null, // Show the price value only if driver availability is not "Without driver"
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DetailRow(
                  title: 'Delivery Options',
                  icon1: IconlyLight.send,
                  value1: vehicle.deliveryAvailable == true
                      ? 'Available'
                      : 'Not Available',
                  icon2: vehicle.deliveryAvailable == true
                      ? IconlyLight.infoSquare
                      : null, // Show the price icon only if delivery is available
                  value2: vehicle.deliveryAvailable == true
                      ? 'Delivery Price Per KM - \$${vehicle.deliveryPrice}'
                      : null, // Show the price value only if delivery is available
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Basics",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fMainColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3, // Number of columns
                      mainAxisSpacing: 10, // Vertical spacing between items
                      crossAxisSpacing: 10, // Horizontal spacing between items
                      childAspectRatio: 1.5, // Aspect ratio for items

                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5), // Padding around the grid
                      children: [
                        buildInfoTile(context, "Type", vehicle.vehicleType),
                        buildInfoTile(
                            context, "Seats", vehicle.seats.toString()),
                        buildInfoTile(
                            context, "Mileage", vehicle.mileage.toString()),
                        buildInfoTile(context, "Fuel", vehicle.fuelType),
                        buildInfoTile(context, "Engine", vehicle.engineSize),
                        buildInfoTile(context, "Color",
                            vehicle.color), // Example of a sixth item
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Features",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fMainColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3, // Number of columns
                      mainAxisSpacing: 10, // Vertical spacing between items
                      crossAxisSpacing: 10, // Horizontal spacing between items
                      childAspectRatio: 1.5, // Aspect ratio for items
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5), // Padding around the grid
                      children: [
                        // Display Yes for true, No for false
                        buildInfoTile(
                            context, "AC", vehicle.isAc ? "Yes" : "No"),
                        buildInfoTile(
                            context, "GPS", vehicle.isGps ? "Yes" : "No"),
                        buildInfoTile(
                            context, "USB", vehicle.isUsb ? "Yes" : "No"),
                        buildInfoTile(context, "Charger",
                            vehicle.isCharger ? "Yes" : "No"),
                        buildInfoTile(context, "Bluetooth",
                            vehicle.isBluetooth ? "Yes" : "No"),
                        buildInfoTile(context, "Sunroof",
                            vehicle.isSunroof ? "Yes" : "No"),
                        buildInfoTile(context, "Button Start",
                            vehicle.isPushButtonStart ? "Yes" : "No"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // New Column to stack review text and review cards
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: fMainColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    vehicle.reviews != null && vehicle.reviews!.isNotEmpty
                        ? SizedBox(
                            height: 150, // Adjust height to fit your UI needs
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vehicle.reviews!.length,
                              itemBuilder: (ctx, index) {
                                final review = vehicle.reviews![index];
                                // Only display reviews that are not empty
                                if (review.review.isNotEmpty) {
                                  return ReviewWidget(
                                      review:
                                          review); // Custom widget for displaying review
                                } else {
                                  return Container(); // Return an empty container if review is empty
                                }
                              },
                            ),
                          )
                        : const Text(
                            'No reviews available for this vehicle yet.',
                            style: TextStyle(fontSize: 14),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hosted By",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fMainColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: HostProfileDetailsScreen(host: vehicle.host!),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          //Container(
                          //   width: 40,
                          //   height: 40,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: isDarkMode
                          //         ? fMainColor
                          //         : Colors.grey.shade300,
                          //   ),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(34.0),
                          //     child: CachedNetworkImage(
                          //       filterQuality: FilterQuality.low,
                          //       imageUrl: vehicle.host!.profilePicture!,
                          //       fit: BoxFit.cover,
                          //       placeholder: (context, url) => Center(
                          //         child: SizedBox(
                          //           width: 40.0,
                          //           height: 40.0,
                          //           child: CircularProgressIndicator(
                          //             color: isDarkMode
                          //                 ? Colors.white
                          //                 : Colors.black,
                          //           ),
                          //         ),
                          //       ),
                          //       errorWidget: (context, url, error) =>
                          //           const Icon(Icons.error),
                          //     ),
                          //   ),
                          // ),

                          // Avatar

                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                vehicle.host!.profilePicture!),
                            radius: 24,
                          ),

                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${vehicle.host!.firstName} ${vehicle.host!.lastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                "Joined on ${formatDateInMonthNameFormat(vehicle.host!.createdAt)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Row(
                            children: [
                              Icon(IconlyBold.star,
                                  color: Colors.orange, size: 18),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "5.0",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isHostedByCurrentUser) ...[
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomGradientButton(
                    height: 55,
                    icon: Icons.arrow_forward,
                    text: "Book this vehicle",
                    onPressed: () {
                      if (authProvider.user!.profileCompletion != '100.00') {
                        showCustomSnackBar(
                          context,
                          "Complete your profile to book this vehicle!",
                          Colors.red,
                        );
                        // Navigate to the Update Profile Screen
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: const ProfileDetailsScreen(),
                          ),
                        );
                      } else if (isBookingAvailable) {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: BookingCustomStepper(vehicle: vehicle),
                          ),
                        );
                      } else {
                        showCustomSnackBar(
                          context,
                          "The booking date for this vehicle has expired.",
                          Colors.red,
                        );
                      }
                    },
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile(BuildContext context, String title, String text) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      borderRadius: BorderRadius.circular(10),
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
      color: isDarkMode ? fdarkBlue : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0), // Padding can be adjusted as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13, color: fMainColor),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
