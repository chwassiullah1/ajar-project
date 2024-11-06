import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/material.dart';

class WeHaveGotYourBack extends StatelessWidget {
  const WeHaveGotYourBack({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.03),
          child: ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                InkWell(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                const Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: fMainColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  "We’ve got your back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: fMainColor,
                  ),
                )
              ]),
              const SizedBox(height: 16),
              const HowItWorksSection(
                title: "Safe & trusted community",
                description:
                    "Before booking, every guest must provide a valid driver's license, verified phone number, and other information. In addition, Ajar screens every guest using advanced risk scoring to ensure they're trustworthy.",
              ),
              const HowItWorksSection(
                title: "Customer support",
                description:
                    "The Ajar support team is standing by to assist you and your guests by phone, email, and live chat, and guests have access to 24/7 roadside assistance.",
              ),
              const HowItWorksSection(
                title: "Two-way reviews",
                description:
                    "Hosts and guests review each other after every trip, so you can see your guests' reviews before hosting them.",
              ),
              const HowItWorksSection(
                title: "Rules of the road",
                description:
                    "Ajar has strict community standards and expects all guests to care for your car as if it were their own. Plus, you can set custom ground rules for your car..",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  final String title;
  final String description;

  const HowItWorksSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
