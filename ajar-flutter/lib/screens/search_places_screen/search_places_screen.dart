import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/providers/google_service_providers/google_service_provider.dart';
import 'package:ajar/screens/vehicle_screens/searched_detail_screen/all_vehicle_searched_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

class SearchPlacesScreen extends StatelessWidget {
  const SearchPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(IconlyLight.search,
                              color: isDarkMode ? Colors.white : Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              cursorColor: fMainColor,
                              onChanged: (value) {
                                final placesProvider =
                                    Provider.of<GoogleServiceProvider>(
                                  context,
                                  listen: false,
                                );
                                placesProvider.setSearching(value.isNotEmpty);
                                if (value.isNotEmpty) {
                                  placesProvider.fetchSuggestions(value);
                                } else {
                                  placesProvider.clearSuggestions();
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                  const SizedBox(width: 10),
                  Expanded(
                      child: TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<GoogleServiceProvider>(
                  builder: (context, placesProvider, child) {
                    if (placesProvider.isLoading) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: fMainColor,
                      ));
                    } else {
                      return ListView(
                        children: [
                          if (!placesProvider.isSearching) ...[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: fMainColor,
                                ),
                                child: const Icon(
                                  IconlyBold.location,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text('Current Location'),
                              onTap: () {
                                // Implement action for "Current Location"
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: fMainColor,
                                ),
                                child: const Icon(
                                  IconlyBold.send,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text('Anywhere'),
                              subtitle: const Text('Browse all cars'),
                              onTap: () {
                                Navigator.of(context).push(
                                  SlidePageRoute(
                                    page: const AllSearchedVehicleScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (placesProvider.suggestions.isNotEmpty)
                                ...placesProvider.suggestions.map((suggestion) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(IconlyBold.location,
                                        color: fMainColor),
                                    title: Text(suggestion.mainText),
                                    subtitle: Text(suggestion.secondaryText),
                                    onTap: () {
                                      // Implement action on selecting a location
                                    },
                                  );
                                }),
                            ],
                          ),
                        ],
                      );
                    }
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
