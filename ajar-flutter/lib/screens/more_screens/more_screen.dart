// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/dialog_box/logout_dialogbox.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_hosts_screen/vehicle_host_forms.dart';
import 'package:ajar/screens/profile_updation_screens/profile_details_screen.dart';
import 'package:ajar/screens/more_screens/account_screens/account_screen.dart';
import 'package:ajar/screens/more_screens/host_info_screens/become_host_screen.dart';
import 'package:ajar/screens/more_screens/host_info_screens/how_it_works_screen.dart';
import 'package:ajar/screens/more_screens/host_info_screens/we_have_got_your_back.dart';
import 'package:ajar/screens/more_screens/host_info_screens/you_are_coverd_screen.dart';
import 'package:ajar/screens/vehicle_screens/my_hosted_vehicles_screens.dart/my_hosted_vehicles_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: size.height * 0.04,
              ),
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
                    //     filterQuality: FilterQuality.low,
                    //     imageUrl: authProvider.user!.profilePicture!,
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
                        authProvider.user!.profilePicture!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${authProvider.user!.firstName} ${authProvider.user!.lastName}',
                    //'Frank Martin',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const ProfileDetailsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "View and Edit Profile",
                      style: TextStyle(color: fMainColor, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile Completion",
                              style: TextStyle(
                                fontSize: 16,
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
                          "Complete your profile to appear more trustworthy.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Use a ternary operator or if-else statement to check user role
                  if (authProvider.user!.role!.title == "Host")
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "List Your Vehicle",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Start listing your vehicle to reach potential renters and maximize your earnings.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          const SizedBox(height: 15),
                          CustomGradientButton(
                            text: "Start Listing",
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            onPressed: () {
                              // Navigate to your listing screen or any other action
                              Navigator.of(context).push(
                                SlidePageRoute(
                                  page: const CustomStepperForm(),
                                ),
                              );
                            },
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Become a host?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Join thousands of hosts building businesses and earning meaningful income on Ajar.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          const SizedBox(height: 15),
                          CustomGradientButton(
                            text: "Learn More",
                            textStyle: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            onPressed: () {
                              Navigator.of(context).push(
                                SlidePageRoute(
                                  page: const BecomeHostScreen(),
                                ),
                              );
                            },
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(),
                  // Account Options
                  ListTile(
                    leading: const Icon(
                      IconlyLight.profile,
                      size: 20,
                    ),
                    title: const Text(
                      'Account',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const AccountScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  if (authProvider.user!.role!.title == "Host") ...[
                    ListTile(
                      leading: const Icon(
                        IconlyLight.paper,
                        size: 20,
                      ),
                      title: const Text(
                        'Your Listings',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: const MyHostedVehiclesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],

                  ListTile(
                    leading: const Icon(
                      IconlyLight.infoSquare,
                      size: 20,
                    ),
                    title: const Text(
                      'How Ajar Works',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const HowItWorksScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      IconlyLight.call,
                      size: 20,
                    ),
                    title: const Text(
                      'Contact Support',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const WeHaveGotYourBack(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      IconlyLight.shieldDone,
                      size: 20,
                    ),
                    title: const Text(
                      'Legal',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const YouAreCoverdScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      IconlyLight.work,
                      size: 20,
                    ),
                    title: const Text(
                      'Open Source License',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
