// ignore_for_file: use_build_context_synchronously

import 'package:ajar/common/buttons/custom_gradient_button.dart';
import 'package:ajar/common/slide_page_routes/slide_page_route.dart';
import 'package:ajar/common/snakbar/custom_snakbar.dart';
import 'package:ajar/providers/authentication/authentication_provider.dart';
import 'package:ajar/screens/vehicle_screens/vehicle_hosts_screen/vehicle_host_forms.dart';
import 'package:ajar/screens/more_screens/host_info_screens/how_it_works_screen.dart';
import 'package:ajar/screens/more_screens/host_info_screens/we_have_got_your_back.dart';
import 'package:ajar/screens/more_screens/host_info_screens/you_are_coverd_screen.dart';
import 'package:ajar/screens/profile_updation_screens/profile_details_screen.dart';
import 'package:ajar/utils/theme_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BecomeHostScreen extends StatelessWidget {
  const BecomeHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.03),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: const Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/5818/a412/4fd8a2c768759cf461bd6e4635346941?Expires=1729468800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jByviTmhCLq5RlJ5R~ASOA2-Z854js6-W~UUKr9h15V9MwZP0T-UX86n7bYZwgiqWzgDblWYTqb9hBJ3L2UoxEc6XM3uqq7UeR7Rcw63HcDv7TCNiNfwzRUpkWdXTqqq6Its9U5jhICIqibXUVatsfXkIk69htDzsWbck~9WTVePY5eXHdDI0eue1pB3sDOHnVGPRkkeRHDEchDEFisBP5nvkeJf9Mm2mICd-gfpKAScBe1Oztggo8dh-u4GnkWgcriyFVlaecVWPbjhDJIasUpr4ulT~qQqO~9P3J-h2IZq8eW~5YmJgU~ZynHqAg55VVBtH7AS5I~FqSOuw3SoOg__',
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
                  const SizedBox(height: 5),
                  const Text(
                    "Become a host?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Join thousands of hosts earning more than \$10,000* per year per car on Ajar, the world’s largest car sharing marketplace.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Divider(),
              //const SizedBox(height: 8),
              InfoSection(
                icon: Icons.directions_car_outlined,
                title: "How it works",
                description:
                    "Listing is free, and you can set your own prices, availability, and rules. Pickup and return are simple, and you'll get paid quickly after each trip. We’re here to help along the way.",
                buttonText: "Learn More",
                onPressed: () {
                  Navigator.of(context).push(
                    SlidePageRoute(
                      page: const HowItWorksScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              InfoSection(
                icon: Icons.shield_outlined,
                title: "You're covered",
                description:
                    "Each protection plan comes standard with \$750,000 in third-party liability insurance provided under a policy issued to Ajar by Travellers Excess and Surplus Lines Company. Varying levels of vehicle protection are available, just in case there’s a mishap.",
                buttonText: "Learn More",
                onPressed: () {
                  Navigator.of(context).push(
                    SlidePageRoute(
                      page: const YouAreCoverdScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              InfoSection(
                icon: Icons.lock_outline,
                title: "We've got your back",
                description:
                    "From our guest screening to customer support, you can always share your car with confidence.",
                buttonText: "Learn More",
                onPressed: () {
                  Navigator.of(context).push(
                    SlidePageRoute(
                      page: const WeHaveGotYourBack(),
                    ),
                  );
                },
              ),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Figure represents average Ajar earnings among all US-based hosts with two or more active vehicles, with at least seven trip days per month, with a vehicle value between \$25,000 and \$34,999, from October 2024 to March 2025.",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomGradientButton(
                  text: "Get Started",
                  //isLoading: authProvider.isLoading,
                  onPressed: () async {
                    // Check user profile completion
                    if (authProvider.user!.profileCompletion != '100.00') {
                      showCustomSnackBar(
                        context,
                        "Complete your profile to 100% in order to become host!",
                        Colors.red,
                      );
                      // Navigate to the Update Profile Screen

                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const ProfileDetailsScreen(),
                        ),
                      );
                    } else {
                      if (authProvider.user!.role!.title == "Host") {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: const CustomStepperForm(),
                          ),
                        );
                      } else {
                        final statusCode = await authProvider.becomeAHost();
                        if (statusCode == 200) {
                          showCustomSnackBar(
                            context,
                            "You are in host mode now!",
                            Colors.green,
                          );
                          Navigator.of(context).push(
                            SlidePageRoute(
                              page: const CustomStepperForm(),
                            ),
                          );
                        } else if (statusCode == 400) {
                          showCustomSnackBar(
                              context, "Host Mode!", Colors.green);
                          Navigator.of(context).push(
                            SlidePageRoute(
                              page: const CustomStepperForm(),
                            ),
                          );
                        } else {
                          showCustomSnackBar(
                              context, "Failed to become a host!", Colors.red);
                        }
                      }
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

class InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const InfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade200,
      //   borderRadius: BorderRadius.circular(12.0),
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: fMainColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                CustomGradientButton(
                  textStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  text: buttonText,
                  onPressed: onPressed,
                  width: 130,
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
