import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/buttons/icon_gradient_button.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/common/text_form_fields/custom_text_form_field.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/providers/chatting/chatting_provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/profile_updation_screens/profile_details_screen.dart';
import 'package:ajar/screens/search_places_screen/search_places_screen.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_shimmer_loading_widget.dart';
import 'package:ajar/screens/vehicle_screens/searched_detail_screen/all_vehicle_searched_screen.dart';
import 'package:ajar/screens/vehicle_screens/searched_detail_screen/searched_detail_vehicles.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch vehicles when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleProvider>(context, listen: false)
          .fetchFavoriteVehicles();
      Provider.of<VehicleProvider>(context, listen: false)
          .getVehicleItemsWithoutFilter();
      Provider.of<ChattingProvider>(context, listen: false)
          .fetchConversations();
    });
  }

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _selectedDateRange = TextEditingController();

  DateTimeRange? _dateRange;
  void _onSubmit() {
    if (_locationController.text.isNotEmpty && _dateRange != null) {
      Provider.of<VehicleProvider>(context, listen: false).clearFiltersData();

      String location = _locationController.text;
      // Extracting just the date part (first 10 characters) from the DateTime
      String startDate = _dateRange!.start.toIso8601String().substring(0, 10);
      String endDate = _dateRange!.end.toIso8601String().substring(0, 10);

      // Navigate to another screen with the formatted date
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchedVehicleScreen(
            startDate: startDate,
            endDate: endDate,
            city: location,
          ),
        ),
      );
    } else {
      showCustomSnackBar(context, "Select all fields!", Colors.red);
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Search',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Los Angles, CA',
                      controller: _locationController,
                      showIcon: true,
                      iconData: IconlyLight.location,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomTextFormField(
                            isEditable: false,
                            label: 'Add Dates',
                            controller: _selectedDateRange,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomGradientButton(
                            textStyle: const TextStyle(
                                fontSize: 10, color: Colors.white),
                            onPressed: () async {
                              DateTimeRange? picked = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(
                                    2000), // Start allowing selection from the year 2000
                                lastDate: DateTime(
                                    2100), // Allow selection up to the year 2100
                                initialDateRange:
                                    _dateRange, // Use the existing date range if available
                              );

                              // If dates were picked, update the controller
                              if (picked != null) {
                                setState(() {
                                  _dateRange = picked;
                                  _selectedDateRange.text =
                                      formatDateRange(picked);
                                });
                              }
                            },
                            text: "+",
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
                CustomGradientButton(
                  onPressed: () {
                    _onSubmit();
                  },
                  text: 'Search',
                  width: 100,
                  height: 50,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your location",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "Norvey, USA",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const ProfileDetailsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? fMainColor : Colors.grey.shade300,
                      ),
                      child: Consumer<AuthenticationProvider>(
                          builder: (context, provider, child) {
                        return
                            // return ClipRRect(
                            //   borderRadius: BorderRadius.circular(34.0),
                            //   child: CachedNetworkImage(
                            //     filterQuality: FilterQuality.low,
                            //     imageUrl: provider.user!.profilePicture!,
                            //     fit: BoxFit.cover,
                            //     placeholder: (context, url) => Center(
                            //       child: SizedBox(
                            //         width: 40.0,
                            //         height: 40.0,
                            //         child: CircularProgressIndicator(
                            //           color:
                            //               isDarkMode ? Colors.white : Colors.black,
                            //         ),
                            //       ),
                            //     ),
                            //     errorWidget: (context, url, error) =>
                            //         const Icon(Icons.error),
                            //   ),
                            // );

                            CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                            provider.user!.profilePicture!,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select or search your",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Text(
                "Favourite vehicle",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: fMainColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Search bar container
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? fdarkBlue : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              spreadRadius: 0),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            SlidePageRoute(
                              page: const SearchPlacesScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(IconlyLight.search,
                                color: isDarkMode ? Colors.white : Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabled: false,
                                  hintText: "Search City, State or Country",
                                  hintStyle: TextStyle(
                                    color:
                                        isDarkMode ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      width:
                          10), // Add spacing between search bar and filter icon
                  IconGradientButton(
                      height: 50,
                      width: 50,
                      icon: IconlyLight.filter2,
                      onPressed:
                          //  () =>
                          //     showCustomDialog(context), // Corrected line
                          () {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: const AllSearchedVehicleScreen(),
                          ),
                        );
                      }),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Cars",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const AllSearchedVehicleScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        color: fMainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Vehicle List
              Expanded(
                child: Consumer<VehicleProvider>(
                  builder: (context, vehicleProvider, child) {
                    if (vehicleProvider.isLoadingWithoutFilter) {
                      // Display shimmer loading effect
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        itemCount: 5, // Number of shimmer placeholders
                        itemBuilder: (context, index) {
                          return const VehicleListItemShimmer();
                        },
                      );
                    }
                    // Filter only available vehicles
                    final availableVehicles = vehicleProvider.allVehicles
                        .where((vehicle) => vehicle.isAvailable == true)
                        .toList();
                    // Check if the vehicle list is empty
                    if (availableVehicles.isEmpty) {
                      return const Center(
                        child: Text(
                          "No vehicle available!",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      );
                    }

                    // Display the first 5 vehicles
                    final vehicleList = availableVehicles.length > 9
                        ? availableVehicles.sublist(0, 9)
                        : availableVehicles;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      itemCount: vehicleList.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicleList[index];
                        return VehicleListItemWidget(
                          vehicle: vehicle,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
