import 'package:ajar/models/auth/user_model.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_shimmer_loading_widget.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllHostVehiclesScreen extends StatefulWidget {
  final UserModel host;
  const ViewAllHostVehiclesScreen({super.key, required this.host});

  @override
  State<ViewAllHostVehiclesScreen> createState() =>
      _ViewAllHostVehiclesScreenState();
}

class _ViewAllHostVehiclesScreenState extends State<ViewAllHostVehiclesScreen> {
  final ScrollController _scrollController = ScrollController();

  int getItemCount(VehicleProvider provider) {
    if (provider.allMyHostedVehicles.isEmpty &&
        !provider.isMyHostedVehiclesLoading) {
      return 1;
    }
    return provider.allMyHostedVehicles.length + 1;
  }

  void _scrollListener() async {
    if (!context.mounted) return;
    final provider = context.read<VehicleProvider>();

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (provider.hasMoreDataMyHostedVehicles &&
          !provider.isMyHostedVehiclesLoading) {
        provider.fetchMyHostedVehicles(widget.host.id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<VehicleProvider>().clearMyHostedData();
      context.read<VehicleProvider>().fetchMyHostedVehicles(widget.host.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Hosted Vehicles",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vehicle list
              Expanded(
                child: Consumer<VehicleProvider>(
                  builder: (context, provider, widget) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: _scrollController,
                      shrinkWrap: true,
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

  Padding headingWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
            color: fMainColor, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget buildItem(BuildContext context, VehicleProvider provider, int index) {
    if (provider.allMyHostedVehicles.isEmpty &&
        !provider.isMyHostedVehiclesLoading) {
      return const Center(
        child: Text('No vehicles available.'),
      );
    }

    if (index < provider.allMyHostedVehicles.length) {
      return VehicleListItemWidget(
        vehicle: provider.allMyHostedVehicles[index],
      );
    }

    if (!provider.isMyHostedVehiclesLoading) {
      return const Center(
        child: Text('No more vehicles available.'),
      );
    }
    return Column(
      children: List.generate(
        3, // Adjust this count based on how many shimmer items you want to show
        (index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: VehicleListItemShimmer(),
        ),
      ),
    );
  }
}
