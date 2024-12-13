import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_shimmer_loading_widget.dart';
import 'package:ajar/screens/vehicle_screens/searched_detail_screen/all_vehicle_searched_screen.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';

class FavoriteVehiclesScreen extends StatefulWidget {
  const FavoriteVehiclesScreen({super.key});

  @override
  State<FavoriteVehiclesScreen> createState() => _FavoriteVehiclesScreenState();
}

class _FavoriteVehiclesScreenState extends State<FavoriteVehiclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleProvider>(context, listen: false)
          .fetchFavoriteVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                const Text(
                  "Favorites",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Consumer<VehicleProvider>(
                    builder: (context, vehicleProvider, child) {
                      if (vehicleProvider.isFavoriteLoading) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          itemCount: vehicleProvider.favorites!
                              .length, // Number of shimmer placeholders
                          itemBuilder: (context, index) {
                            return const VehicleListItemShimmer();
                          },
                        );
                      } else if (vehicleProvider.errorMessage != null) {
                        return Center(
                          child: Text(vehicleProvider.errorMessage!),
                        );
                      } else if (vehicleProvider.favorites == null ||
                          vehicleProvider.favorites!.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Get Started with Favorites",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Tap the heart icon in detail screen to save your favorite vehicles to a list",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            CustomGradientButton(
                              height: 50,
                              text: "Find New Vehicles",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllSearchedVehicleScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          shrinkWrap: true,
                          itemCount: vehicleProvider.favorites!.length,
                          itemBuilder: (context, index) {
                            
                            final favoriteVehicle =
                                vehicleProvider.favorites![index];
                            final vehicle = favoriteVehicle.vehicle;
                            return VehicleListItemWidget(vehicle: vehicle!);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
