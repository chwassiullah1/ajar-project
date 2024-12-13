import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_shimmer_loading_widget.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:carded/carded.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllSearchedVehicleScreen extends StatefulWidget {
  const AllSearchedVehicleScreen({
    super.key,
  });

  @override
  State<AllSearchedVehicleScreen> createState() =>
      _AllSearchedVehicleScreenState();
}

class _AllSearchedVehicleScreenState extends State<AllSearchedVehicleScreen> {
  final ScrollController _scrollController = ScrollController();
  String? selectedBrand;
  String? selectedPrice;
  String? selectedVehicleType;
  String? selectedYear;
  String? selectedSeats;
  String? selectedFuelType;
  String? startDate;
  String? endDate;

  bool useMultipleFilters = false; // Track checkbox state

  final List<String> brands = [
    'All',
    'Abarth',
    'Acura',
    'Alfa Romeo',
    'Alpina',
    'Aston Martin',
    'Audi',
    'Austin',
    'Bentley',
    'BMW',
    'Bugatti',
    'Buick',
    'Byd',
    'Cadillac',
    'Changan',
    'Chery',
    'Chevrolet',
    'Chrysler',
    'Citroen',
    'Cupra',
    'Dacia',
    'Daewoo',
    'Dodge',
    'Ferrari',
    'Fiat',
    'Ford',
    'Geely',
    'Genesis',
    'GMC',
    'Great Wall',
    'Haval',
    'Honda',
    'Hyundai',
    'Infiniti',
    'Isuzu',
    'Jaguar',
    'Jeep',
    'Kia',
    'Lada',
    'Lamborghini',
    'Land Rover',
    'Lexus',
    'Lincoln',
    'Lotus',
    'Mahindra',
    'Maserati',
    'Maybach',
    'Mazda',
    'Mercedes',
    'MG',
    'Mini',
    'Mitsubishi',
    'Nissan',
    'Opel',
    'Peugeot',
    'Porsche',
    'Proton',
    'Ram',
    'Renault',
    'Rolls-Royce',
    'Rover',
    'Saab',
    'Skoda',
    'Smart',
    'Ssangyong',
    'Subaru',
    'Suzuki',
    'Tata',
    'Tesla',
    'Toyota',
    'Volkswagen',
    'Volvo',
    'Wey'
  ];

  final List<String> prices = ['All', '\$100', '\$500', '\$1000', '\$3000'];
  final List<String> vehicleTypes = [
    'All',
    'Cars',
    'SUVs',
    'Minivans',
    'Box Trucks',
    'Trucks',
    'Vans',
    'Cargo Vans'
  ];
  final List<String> dateRangeList = [
    'All',
    'Start Date',
    'End Date',
  ];

  final List<String> years = ["All"] +
      List.generate(
        2030 - 1970 + 1,
        (index) => (1970 + index).toString(),
      );
  final List<String> seats = ['All', '2', '4', '8', '10', '20', '50', '100'];
  final List<String> fuelType = [
    'All',
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid'
  ];

  int getItemCount(VehicleProvider provider) {
    if (provider.allSeachedVehicles.isEmpty && !provider.isLoadingWithFilter) {
      return 1;
    }
    return provider.allSeachedVehicles.length + 1;
  }

  void _scrollListener() async {
    if (!context.mounted) return;
    final provider = context.read<VehicleProvider>();

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (provider.hasMoreDataWithFilter && !provider.isLoadingWithFilter) {
        provider.getVehicleItemsWithFilter();
      }
    }
  }

  void onApplyFilters() {
    // Clear existing data
    context.read<VehicleProvider>().clearFiltersData();

    // Check if we are using multiple filters
    if (useMultipleFilters) {
      context.read<VehicleProvider>().getVehicleItemsWithFilter(
            make: (selectedBrand == null || selectedBrand == 'All')
                ? null
                : selectedBrand,
            price: (selectedPrice == null || selectedPrice == 'All')
                ? null
                : selectedPrice?.replaceAll('\$', ''),
            vehicleType:
                (selectedVehicleType == null || selectedVehicleType == 'All')
                    ? null
                    : selectedVehicleType,
            year: (selectedYear == null || selectedYear == 'All')
                ? null
                : int.tryParse(selectedYear!), // Use tryParse for safety
            seats: (selectedSeats == null || selectedSeats == 'All')
                ? null
                : int.tryParse(selectedSeats!), // Use tryParse for safety
            fuelType: (selectedFuelType == null || selectedFuelType == 'All')
                ? null
                : selectedFuelType,
            startDate: startDate,
            endDate: endDate,
          );
    } else {
      // Apply filters individually (if checkbox is not selected)
      if (selectedBrand != null && selectedBrand != 'All') {
        onSelectedBrandFilter();
      }
      if (selectedPrice != null && selectedPrice != 'All') {
        onSelectedPriceFilter();
      }
      if (selectedVehicleType != null && selectedVehicleType != 'All') {
        onSelectedVehicleTypeFilter();
      }
      if (selectedYear != null && selectedYear != 'All') {
        onSelectedVehicleYearFilter();
      }
      if (selectedSeats != null && selectedSeats != 'All') {
        onSelectedSeatsFilter();
      }
      if (selectedFuelType != null && selectedFuelType != 'All') {
        onSelectedFuelTypeFilter();
      }
      if (startDate != null) {
        onSelectedStartDateFilter();
      }
      if (endDate != null) {
        onSelectedEndDateFilter();
      }
    }
  }

  void onSelectedBrandFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          make: selectedBrand == 'All' ? null : selectedBrand,
        );
  }

  void onSelectedPriceFilter() {
    context.read<VehicleProvider>().clearFiltersData();

    // If "All" is selected, pass null; otherwise, remove the '$' sign from the selected price
    String? price = selectedPrice == 'All'
        ? null
        : selectedPrice!.replaceAll('\$', ''); // Remove the dollar sign

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          price: price, // Pass the price without the '$' sign
        );
  }

  void onSelectedVehicleTypeFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          vehicleType:
              selectedVehicleType == 'All' ? null : selectedVehicleType,
        );
  }

  void onSelectedVehicleYearFilter() {
    context.read<VehicleProvider>().clearFiltersData();

    // If "All" is selected, pass null; otherwise, check for null before parsing
    int? year = selectedYear == 'All' || selectedYear == null
        ? null
        : int.tryParse(selectedYear!); // Use tryParse for safety

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          year:
              year, // Pass the year as an integer or null if "All" is selected
        );
  }

  void onSelectedFuelTypeFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          fuelType: selectedFuelType == 'All'
              ? null
              : selectedFuelType, // Handle null or string
        );
  }

  void onSelectedSeatsFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          seats: selectedSeats == 'All'
              ? null
              : int.tryParse(selectedSeats!), // Parse to int or handle null
        );
  }

  void onSelectedDatesFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          startDate: startDate,
          endDate: endDate,
        );
  }

  void onSelectedStartDateFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          startDate: startDate,
        );
  }

  void onSelectedEndDateFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();

    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          endDate: endDate,
        );
  }

  // Add this method to reset dropdown values
  void resetFilters() {
    setState(() {
      selectedBrand = null;
      selectedPrice = null;
      selectedVehicleType = null;
      selectedYear = null;
      selectedSeats = null;
      selectedFuelType = null;
      useMultipleFilters = false; // Reset checkbox if needed
      endDate = null;
      startDate = null;
    });

    // Optionally, you can also clear filters in the provider
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<VehicleProvider>().clearFiltersData();
      context.read<VehicleProvider>().getVehicleItemsWithFilter();
    });
  }

  // Format the date to show only the day number
  // Function to format date to 'yyyy-MM-dd'
  String formatDateToYMD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Function to show DatePicker and update the startDate value
  Future<void> _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        startDate = formatDateToYMD(picked); // Update to new format
        if (!useMultipleFilters) {
          onSelectedStartDateFilter();
        } else {
          onApplyFilters();
        }
      });
    }
  }

  // Function to show DatePicker and update the endDate value
  Future<void> _pickEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        endDate = formatDateToYMD(picked); // Use new format
        if (!useMultipleFilters) {
          onSelectedEndDateFilter();
        } else {
          onApplyFilters();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Vehicles",
          style: TextStyle(fontSize: 20),
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable filter buttons
              CardyContainer(
                color: isDarkMode ? fdarkBlue : Colors.white,
                spreadRadius: 0,
                blurRadius: 1,
                shadowColor: isDarkMode ? fdarkBlue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
                margin: EdgeInsets.zero,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterDropdownButton<String>(
                        value: selectedVehicleType,
                        hint: 'Vehicle Type',
                        items: vehicleTypes,
                        onChanged: (value) {
                          setState(() => selectedVehicleType = value);
                          if (!useMultipleFilters) {
                            onSelectedVehicleTypeFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      FilterDropdownButton<String>(
                        value: selectedBrand,
                        hint: 'Make Brands',
                        items: brands,
                        onChanged: (value) {
                          setState(() => selectedBrand = value);
                          if (!useMultipleFilters) {
                            onSelectedBrandFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      FilterDropdownButton<String>(
                        value: selectedPrice,
                        hint: 'Price',
                        items: prices,
                        onChanged: (value) {
                          setState(() => selectedPrice = value);
                          if (!useMultipleFilters) {
                            onSelectedPriceFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      FilterDropdownButton<String>(
                        value: selectedYear,
                        hint: 'Years',
                        items: years,
                        onChanged: (value) {
                          setState(() => selectedYear = value);
                          if (!useMultipleFilters) {
                            onSelectedVehicleYearFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      FilterDropdownButton<String>(
                        value: selectedSeats,
                        hint: 'Seats',
                        items: seats,
                        onChanged: (value) {
                          setState(() => selectedSeats = value);
                          if (!useMultipleFilters) {
                            onSelectedSeatsFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      FilterDropdownButton<String>(
                        value: selectedFuelType,
                        hint: 'Fuel Type',
                        items: fuelType,
                        onChanged: (value) {
                          setState(() => selectedFuelType = value);
                          if (!useMultipleFilters) {
                            onSelectedFuelTypeFilter();
                          } else {
                            onApplyFilters();
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickStartDate();
                        },
                        child: AbsorbPointer(
                          child: DropdownButton<String>(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            value:
                                null, // Keep it null to open date picker on tap
                            iconSize: 20,
            
                            hint: Text(
                              startDate == null ? "Start Date" : startDate!,
                              style: const TextStyle(fontSize: 14),
                            ),
            
                            underline: Container(),
                            items: const [],
                            onChanged: (String? value) async {
                              await _pickStartDate();
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickEndDate();
                        },
                        child: AbsorbPointer(
                          child: DropdownButton<String>(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            value:
                                null, // Keep it null to open date picker on tap
                            iconSize: 20,
                            hint: Text(
                              endDate == null ? "End Date" : endDate!,
                              style: const TextStyle(fontSize: 14),
                            ),
                            underline: Container(),
                            items: const [],
                            onChanged: (String? value) async {
                              await _pickEndDate();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Checkbox(
                      value: useMultipleFilters,
                      onChanged: (value) {
                        setState(() {
                          useMultipleFilters = value ?? false;
                          // Apply filters when the checkbox is checked
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Use Multiple Filters',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? fdarkBlue : Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      resetFilters();
                    },
                    child: Text(
                      "Reset Filters",
                      style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            
              // Vehicle list
              Expanded(
                child: Consumer<VehicleProvider>(
                  builder: (context, provider, widget) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      controller: _scrollController,
                      itemCount: getItemCount(provider),
                      itemBuilder: (context, i) =>
                          buildItem(context, provider, i),
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

Widget buildItem(BuildContext context, VehicleProvider provider, int index) {
  if (provider.allSeachedVehicles.isEmpty && !provider.isLoadingWithFilter) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text("No vehicles available."),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
  if (index < provider.allSeachedVehicles.length) {
    return VehicleListItemWidget(
      vehicle: provider.allSeachedVehicles[index],
    );
  }

  if (!provider.hasMoreDataWithFilter) {
    return const Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text("No more vehicles available."),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  return Column(
    children: List.generate(
      3, // Adjust this count based on how many shimmer items you want to show
      (index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3),
          child: VehicleListItemShimmer()),
    ),
  );
}

class FilterDropdownButton<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const FilterDropdownButton({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<T>(
        dropdownColor: isDarkMode ? fdarkBlue : Colors.white,
        iconSize: 20,
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14),
        ),
        underline: const SizedBox(), // Hide the underline
        onChanged: (T? newValue) {
          onChanged(newValue);
        },
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
      ),
    );
  }
}
