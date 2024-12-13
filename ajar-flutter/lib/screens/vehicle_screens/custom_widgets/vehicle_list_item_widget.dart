import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/models/vehicle/favoriteVehicle/favorite_vehicle.dart';
import 'package:ajar/models/vehicle/vehicle_model.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_details_screen/vehicle_detail_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carded/carded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class VehicleListItemWidget extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleListItemWidget({
    super.key,
    required this.vehicle,
  });

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

    // Define colors for the dark mode shimmer effect
    final darkBaseColor =
        fdarkBlue.withOpacity(0.7); // Slightly lighter fdarkBlue
    final darkHighlightColor = fMainColor.withOpacity(0.5); // Faded main color
    final darkBackgroundColor =
        fdarkBlue.withOpacity(0.9); // Darker base for backgrounds

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(
            page: VehicleDetailScreen(vehicle: vehicle),
          ),
        );
      },
      child: Stack(
        children: [
          CardyContainer(
            color: isDarkMode ? fdarkBlue : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                    child: vehicle.pictures != null &&
                            vehicle.pictures!.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? fMainColor
                                  : Colors.grey.shade300,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: vehicle.pictures![0],
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
                            "${vehicle.make} ${vehicle.model}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(
                                IconlyBold.star,
                                color: Colors.orange,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Row for transmission type and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vehicle.transmissionType,
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
                                  text: "\$${vehicle.price}", // Price part
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
                                        ? Colors.white70
                                        : Colors
                                            .grey, // Color for the "day" part
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
          if (!isHostedByCurrentUser)
            Positioned(
              top: 5,
              right: 10,
              child: IconButton(
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
            ),
        ],
      ),
    );
  }
}
