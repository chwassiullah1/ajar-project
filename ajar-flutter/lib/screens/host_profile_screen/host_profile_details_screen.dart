import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/models/auth/user_model.dart';
import 'package:ajar/providers/vehicles/vehicle_provider.dart';
import 'package:ajar/screens/host_profile_screen/view_all_host_vehicles_screen.dart';
import 'package:ajar/screens/vehicle_screens/custom_widgets/vehicle_list_item_widget.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostProfileDetailsScreen extends StatefulWidget {
  final UserModel host;
  const HostProfileDetailsScreen({super.key, required this.host});

  @override
  State<HostProfileDetailsScreen> createState() =>
      _HostProfileDetailsScreenState();
}

class _HostProfileDetailsScreenState extends State<HostProfileDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<VehicleProvider>().clearMyHostedData();
      context.read<VehicleProvider>().fetchMyHostedVehicles(widget.host.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final host = widget.host;
    print(host.profilePicture);
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? fMainColor : Colors.grey.shade300,
                      ),
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(34.0),
                      //   child: CachedNetworkImage(
                      //     imageUrl: host.profilePicture!,
                      //     fit: BoxFit.cover,
                      //     placeholder: (context, url) => Center(
                      //       child: SizedBox(
                      //         width: 40.0,
                      //         height: 40.0,
                      //         child: CircularProgressIndicator(
                      //           color: isDarkMode ? Colors.white : Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      //     errorWidget: (context, url, error) =>
                      //         const Icon(Icons.error),
                      //   ),
                      // ),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          host.profilePicture!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.host.firstName} ${widget.host.lastName}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Joined on ${formatDateInMonthNameFormat(widget.host.createdAt)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              headingWidget("Verified Info"),
              const SizedBox(height: 15),
              const Divider(),
              customListTile("Email", Icons.check_circle),
              const Divider(),
              customListTile("Phone", Icons.check_circle),
              const Divider(),
              customListTile("Driving License", Icons.check_circle),

              const Divider(),
              const SizedBox(height: 10),
              headingWidget("About"),
              const SizedBox(height: 10),
              const Divider(),
              customListTileMethod('Country', widget.host.address!.country!),
              const Divider(),
              customListTileMethod('State', widget.host.address!.state!),
              const Divider(),
              customListTileMethod('City', widget.host.address!.city!),
              const Divider(),
              const SizedBox(height: 15),
              headingWidget("Hosted Vehicles"),
              const SizedBox(height: 10),
              // Vehicle list with limited items and "See More" button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Consumer<VehicleProvider>(
                  builder: (context, provider, widget) {
                    final vehicleList = provider.allMyHostedVehicles;
                    return Column(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              vehicleList.length > 3 ? 3 : vehicleList.length,
                          itemBuilder: (context, index) {
                            return VehicleListItemWidget(
                              vehicle: vehicleList[index],
                            );
                          },
                        ),
                        if (vehicleList.length > 3)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? fdarkBlue
                                    : Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  SlidePageRoute(
                                    page: ViewAllHostVehiclesScreen(host: host),
                                  ),
                                );
                              },
                              child: Text(
                                "See More",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
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

  Widget customListTile(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          icon,
          color: fMainColor,
          size: 24,
        ),
      ),
    );
  }

  Widget customListTileMethod(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        trailing: Text(trailing,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
      ),
    );
  }
}
