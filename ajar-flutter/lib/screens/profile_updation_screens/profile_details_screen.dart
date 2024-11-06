import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/profile_updation_screens/driving_licesnse_info_complete.dart';
import 'package:ajar/screens/profile_updation_screens/profile_updation_screen.dart';
import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:ajar/utils/date_and_time_formatting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            color: Colors.grey.shade300,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(34.0),
                            child: CachedNetworkImage(
                              imageUrl: authProvider.user!.profilePicture!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${authProvider.user!.firstName} ${authProvider.user!.lastName}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Joined on ${formatDate(authProvider.user!.createdAt)}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile Completion",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${double.parse(authProvider.user!.profileCompletion.toString()).toInt()}%",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: fMainColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Profile with personal info and connected with email appear more trustworthy.',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  headingWidget("Verified Info"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  customVerifiedListTile("Email", authProvider.user!.email),
                  const Divider(),
                  customVerifiedListTile("Phone", authProvider.user!.phone),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text(
                          "About",
                          style: TextStyle(
                              color: fMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProfileCompleteScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                              color: fMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  customListTileMethod(
                      "National ID Card", "${authProvider.user!.cnic}"),
                  const Divider(),
                  customListTileMethod(
                      'Country', authProvider.user!.address!.country!),
                  const Divider(),
                  customListTileMethod(
                      'State', authProvider.user!.address!.state!),
                  const Divider(),
                  customListTileMethod(
                      'City', authProvider.user!.address!.city!),
                  const Divider(),
                  customListTileMethod(
                      'Street No.', '${authProvider.user!.address!.streetNo}'),
                  const Divider(),
                  customListTileMethod(
                      'Postal Code', authProvider.user!.address!.postalCode!),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Text(
                          "Driving License",
                          style: TextStyle(
                              color: fMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DrivingLicenseInfoComplete(),
                                ));
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                                color: fMainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'First Name',
                    authProvider.user!.drivingLicenseDetails!.firstName,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'Last Name',
                    authProvider.user!.drivingLicenseDetails!.lastName,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'Country',
                    authProvider.user!.drivingLicenseDetails!.country,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'State',
                    authProvider.user!.drivingLicenseDetails!.state,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'License Numnber',
                    authProvider.user!.drivingLicenseDetails!.licenseNumber,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'Date of Birth',
                    authProvider.user!.drivingLicenseDetails!.dateOfBirth,
                  ),
                  const Divider(),
                  customListTileMethod(
                    'Expiration Date',
                    authProvider.user!.drivingLicenseDetails!.expirationDate,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget customVerifiedListTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.check_circle,
          color: fMainColor,
          size: 24,
        ),
      ),
    );
  }

  Widget headingWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(
            color: fMainColor, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget customListTileMethod(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
