import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';

class MyHostedVehiclesScreen extends StatefulWidget {
  const MyHostedVehiclesScreen({super.key});

  @override
  State<MyHostedVehiclesScreen> createState() => _MyHostedVehiclesScreenState();
}

class _MyHostedVehiclesScreenState extends State<MyHostedVehiclesScreen> {
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
    final authProvider = context.read<AuthenticationProvider>();

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (provider.hasMoreDataMyHostedVehicles &&
          !provider.isMyHostedVehiclesLoading) {
        provider.fetchMyHostedVehicles(authProvider.user!.id);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    final authProvider = context.read<AuthenticationProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<VehicleProvider>().clearMyHostedData();
      context
          .read<VehicleProvider>()
          .fetchMyHostedVehicles(authProvider.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Hosted Vehicles",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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

    if (provider.isMyHostedVehiclesLoading) {
      // Show multiple shimmer widgets when loading more data
      return Column(
        children: List.generate(
          3, // Adjust this count based on how many shimmer items you want to show
          (index) => const VehicleListItemShimmer(),
        ),
      );
    }

    return const Center(
      child: Text('No more vehicles available.'),
    );
  }
}
