import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedVehicleScreen extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String city;

  const SearchedVehicleScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.city,
  });

  @override
  State<SearchedVehicleScreen> createState() => _SearchedVehicleScreenState();
}

class _SearchedVehicleScreenState extends State<SearchedVehicleScreen> {
  final ScrollController _scrollController = ScrollController();
  String? selectedBrand;
  String? selectedPrice;
  String? selectedVehicleType;
  String? selectedYear;

  // Example data for dropdowns
  final List<String> brands = ['Honda', 'Tesla', 'Ford', 'Toyota'];
  final List<String> prices = ['\$0 - \$50', '\$50 - \$100', '\$100+'];
  final List<String> vehicleTypes = ['SUV', 'Sedan', 'Truck'];
  final List<String> years = ['2020', '2021', '2022', '2023'];

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
        provider.getVehicleItemsWithFilter(
          startDate: widget.startDate,
          endDate: widget.endDate,
          city: widget.city,
        );
      }
    }
  }

  void onSelectedBrandFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          make: selectedBrand,
        );
  }

  void onSelectedPriceFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          price: selectedPrice,
        );
  }

  void onSelectedVehicleTypeFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          vehicleType: selectedVehicleType,
        );
  }

  void onSelectedVehicleYearFilter() {
    // Fetch vehicles with selected filters
    context.read<VehicleProvider>().clearFiltersData();
    context.read<VehicleProvider>().getVehicleItemsWithFilter(
          year: int.parse(selectedYear!),
        );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<VehicleProvider>().getVehicleItemsWithFilter(
            startDate: widget.startDate,
            endDate: widget.endDate,
            city: widget.city,
          );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Card(
                      elevation: 0.5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(width: 0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.city,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.startDate} / ${widget.endDate}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),

              // Location and Date information

              const SizedBox(height: 8),

              // Scrollable filter buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterDropdownButton<String>(
                      value: selectedPrice,
                      hint: 'Price',
                      items: prices,
                      onChanged: (value) {
                        setState(() => selectedPrice = value);
                        onSelectedPriceFilter();
                      },
                    ),
                    FilterDropdownButton<String>(
                      value: selectedVehicleType,
                      hint: 'Vehicle Type',
                      items: vehicleTypes,
                      onChanged: (value) {
                        setState(() => selectedVehicleType = value);
                        onSelectedVehicleTypeFilter();
                      },
                    ),
                    FilterDropdownButton<String>(
                      value: selectedBrand,
                      hint: 'Make',
                      items: brands,
                      onChanged: (value) {
                        setState(() => selectedBrand = value);
                        onSelectedBrandFilter();
                      },
                    ),
                    FilterDropdownButton<String>(
                      value: selectedYear,
                      hint: 'Years',
                      items: years,
                      onChanged: (value) {
                        setState(() => selectedYear = value);
                        onSelectedVehicleYearFilter();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Vehicle list
              Expanded(
                child: Consumer<VehicleProvider>(
                  builder: (context, provider, widget) {
                    return ListView.builder(
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
        Text("No vehicles available."),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  return const Center(
    child: SizedBox(width: 40, height: 40, child: CircularProgressIndicator()),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint),
        underline: const SizedBox(), // Hide the underline
        onChanged: onChanged,
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
